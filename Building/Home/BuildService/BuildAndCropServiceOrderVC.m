//
//  BuildAndCropServiceOrderVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/11.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "BuildAndCropServiceOrderVC.h"
#import "RRTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AlipaySDK/AlipaySDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddressListVC.h"
#import "paySelectControl.h"

@interface BuildAndCropServiceOrderVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *gongsiNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet RRTextView *myTextView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *countLiuYanLabel;

@property (strong, nonatomic) NSArray <AddressModel*> *addressList;
@property (nonatomic, copy)  NSString  *token;//header传参,登录了传，没有不传，不影响数据的获取
@property (strong, nonatomic) AddressModel *currentAddressModel;//收货地址
@property (copy, nonatomic) NSString *buyCountStr;//当前购买数量
@property (strong, nonatomic) ServiceProductSkuPriceModel *currentProductPriceModel;

@property (nonatomic, strong) paySelectControl *ps;//委托视图
@property (assign, nonatomic) int navBarHeight;


@end

@implementation BuildAndCropServiceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单确认";

    //数据初始化
    self.addressList = [[NSMutableArray alloc] init];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    self.currentAddressModel = nil;
    [self.view endEditing:YES];
    
    _myTextView = [RRTextView new];
    [_myTextView setFont:UIFontWithSize(13)];
    [_myTextView setPlaceholderOriginY:6 andOriginX:2.5];
    _myTextView.placeholder = @"留言信息（最多300字）";
    _myTextView.backgroundColor = UIColorFromHEX(0xf7f7f7);
    [_myTextView setPlaceholderColor:UIColorFromHEX(0xbababa)];
    _myTextView.contentInset = UIEdgeInsetsMake(15, 18, 15, 18);
    
    _myTextView.delegate = self;
    [self.contentView addSubview:self.myTextView];
    
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countLiuYanLabel.mas_bottom).offset(12);
        make.left.equalTo(@13);
        make.right.equalTo(@13);
        make.height.equalTo(@190);
    }];


    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.detailModel = self.detailModel;
    [self gainAddressList];
    [self configPaySelect];
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    //NSLog(@"handleBackgroundTap");
    [self.myTextView resignFirstResponder];
}

//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //NSLog(@"touchesBegan");
    [self.myTextView resignFirstResponder];
    //_myTextView.placeholder.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self gainAddressList];
    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.ps hide];
}

-(void)textViewDidChange:(UITextView *)textView
{
    long currentLen = (long)textView.text.length;
    //NSLog(@"currentLen:%ld", currentLen );
    //[self.myTextView resignFirstResponder];
    if( currentLen >= 300 )
    {
        self.countLiuYanLabel.text = [NSString stringWithFormat:@"还可输入%ld字",0];
        //textView.editable = NO;
        textView.text = [textView.text substringToIndex:300];
        //return NO;
    }
    else
    {
        //还可输入300字
        self.countLiuYanLabel.text = [NSString stringWithFormat:@"还可输入%ld字",300-currentLen];
        //textView.editable = YES;
    }
    
//    if( currentLen > 0 )
//    {
//        [_myTextView setHidden:YES];
//    }
    //return YES;
}

#pragma mark - requests
//获取地址列表
- (void)gainAddressList
{
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainAddressListWithHeaderParams:paramsHeader Success:^(NSArray *addressArr) {
        wself.addressList = addressArr;
        for (AddressModel* item in addressArr) {
            if (item.defaultBool == true) {
                [wself updateCurrentAddressModelAndUI:item];
                
                break;
            }
        }
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
}

#pragma mark - Actions
//支付
- (IBAction)buyButtonAction:(id)sender {
    [self.view endEditing:YES];

    if  (self.token == nil) {
        [self showHint:self.view text:@"请登录"];
        return;
    }
    
    if (self.currentAddressModel == nil){
        [self showHint:@"请选择收货地址"];
        return;
    }
    self.ps.paymode = 1;
    [self.ps showFrom:self completion:nil];

    /*
     addressId:收货人id;message:留言;number:购买数量;orderSn:订单编号,个人中心，待付款 调用 传参，其他时候该参数不填；productId:产品id;productSaleId:商品属性价格id:token;登录返回的token,header 传参
     */
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
//    [params setObject:self.currentAddressModel.idStr forKey:@"addressId" ];
//    [params setObject:self.myTextView.text forKey:@"message" ];
//    [params setObject:self.buyCountStr forKey:@"number" ];
////    [params setObject:@"" forKey:@"orderSn" ];
//    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.detailModel.productInfo.productId] forKey:@"productId" ];
//    [params setObject:[NSString stringWithFormat:@"%ld", self.currentProductPriceModel.productSaleId] forKey:@"productSaleId" ];
 
    self.ps.idStr = self.currentAddressModel.idStr;
    self.ps.message = self.myTextView.text;
    self.ps.number = self.buyCountStr;
    self.ps.productId = [NSString stringWithFormat:@"%ld",(long)self.detailModel.productInfo.productId];
    self.ps.productSaleId = [NSString stringWithFormat:@"%ld", self.currentProductPriceModel.productSaleId];
    
//    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
//    if (self.token != nil) {
//        [paramsHeader setObject:self.token forKey:@"token"];
//    }
    //NSLog(@"gainAliPayInfoWithParams:%ld", self.detailModel.productInfo.productId );
    /*
    //ygz test
    //支付信息获取接口，用于从后台获取支付所需信息
    __weak __typeof__ (self) weakSelf = self;
    [HomeNetworkService gainAliPayInfoWithParams:params headerParams:paramsHeader Success:^(NSString *payStr) {
        [[AlipaySDK defaultService] payOrder:payStr fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"payreslut : %@",resultDic);
            [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^{}];
        }];
    } failure:^(NSString *response) {
        [weakSelf showHint:response];
    }];
    */
    
}


- (void)coverViewTapActionOfpsView{
    [self.ps hide];
    //self.tabBarController.tabBar.hidden = NO;
    //NSLog(@"coverViewTapActionOfDelegateToSaleView");
    
    //[self configPaySelect];
    //[self.delegateView removeFromSuperview];
}

- (void)coverViewTapActionOfpsOkView{
    [self.ps hide];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configPaySelect{
    //委托视图
    self.ps = [[paySelectControl alloc] init];
    self.ps.pscd = self;
}


//选择地址
- (IBAction)addressViewTap:(id)sender {
    [self.view endEditing:YES];

    AddressListVC * loginVC = [[AddressListVC alloc] init];
    __weak __typeof__ (self) wself = self;
    loginVC.selectAddressBlock = ^(AddressModel *addressModel){
       [wself updateCurrentAddressModelAndUI:addressModel];
    };
    [loginVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - Private
- (void)updateCurrentAddressModelAndUI:(AddressModel *)addressModel{
    self.currentAddressModel = addressModel;
    
    self.nameLabel.text = addressModel.receiver;
    self.telLabel.text = addressModel.contact;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@%@%@%@", addressModel.provinceName, addressModel.cityName, addressModel.countyName, addressModel.address];
    
    NSLog(@"nameLabel:%@, %@,%@",addressModel.receiver, addressModel.contact, [NSString stringWithFormat:@"收货地址：%@%@%@%@", addressModel.provinceName, addressModel.cityName, addressModel.countyName, addressModel.address] );
}

#pragma mark - setters
- (void)setDetailModel:(ServiceDetailModel *)detailModel{
    _detailModel = detailModel;
    [self.view endEditing:YES];

    self.gongsiNameLabel.text = detailModel.productInfo.supplierName;
    NSURL *url = [NSURL URLWithString:@""];
    if (detailModel.productInfo.detailImg.count > 0) {
        url = [NSURL URLWithString:detailModel.productInfo.detailImg[0]];
    }
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.oneLabel.text = detailModel.productInfo.name;
    
    ServiceProductSkuInfoAttrModel *selectItem = nil;
    for (ServiceProductSkuInfoAttrModel *item in detailModel.productSku.skuInfo[0].attrList) {
        if (item.isSelect == true) {
            self.twoLabel.text = item.attrName;
            selectItem = item;
            break;
        }
    }
    
    for (ServiceProductSkuPriceModel *item in self.detailModel.productSku.priceList) {
        if (item.attrIds == selectItem.attrId) {
            self.moneyLabel.text = item.price;
            self.currentProductPriceModel = item;
            break;
        }
    }
    self.countLabel.text = detailModel.productSku.payCount;
    self.buyCountStr = detailModel.productSku.payCount;
    
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f", [self.detailModel.productSku.payCount integerValue] * [self.moneyLabel.text floatValue]];
}

@end
