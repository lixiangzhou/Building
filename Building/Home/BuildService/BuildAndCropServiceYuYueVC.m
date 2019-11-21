//
//  BuildAndCropServiceYuYueVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/11.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "BuildAndCropServiceYuYueVC.h"
#import "RRTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AlipaySDK/AlipaySDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MonthTimePicker.h"

@interface BuildAndCropServiceYuYueVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UILabel *countLiuYanLabel;
@property (weak, nonatomic) IBOutlet RRTextView *myTextView;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic, copy)  NSString  *token;//header传参,登录了传，没有不传，不影响数据的获取
@property (strong, nonatomic) ServiceProductSkuPriceModel *currentProductPriceModel;
@property (nonatomic, strong)MonthTimePicker *pickDateview;
@property (nonatomic, strong)NSDate *selectDate;
@end

@implementation BuildAndCropServiceYuYueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据初始化
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    [_myTextView setFont:UIFontWithSize(13)];
    [_myTextView setPlaceholderOriginY:6 andOriginX:2.5];
    _myTextView.placeholder = @"留言信息（最多300字）";
    _myTextView.backgroundColor = UIColorFromHEX(0xf7f7f7);
    [_myTextView setPlaceholderColor:UIColorFromHEX(0xbababa)];
    _myTextView.contentInset = UIEdgeInsetsMake(15, 18, 15, 18);

//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
//                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
//    tapRecognizer.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tapRecognizer];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapAction:)];
    //gesture.delegate = self;
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];

    self.pickDateview = [MonthTimePicker new];
    MJWeakSelf
    self.pickDateview.confirmBlock = ^(NSDate * _Nonnull date, NSString *dateString) {
        [weakSelf.view endEditing:YES];
        weakSelf.selectDate = date;
        weakSelf.timeField.text = dateString;
    };

    self.detailModel = self.detailModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self gainAddressList];

    //[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.myTextView resignFirstResponder];
}

//tap响应函数
- (void)selfViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    //    UIView *itemView = tapGesture.view;
    //    NSLog(@"%ld", (long)itemView.tag);
    
    [self.view endEditing:YES];
}

//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];

}
#pragma mark - requests
//获取地址列表
- (void)gainAddressList
{
//    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
//    if (self.token != nil) {
//        [paramsHeader setObject:self.token forKey:@"token"];
//    }
//
//    __weak __typeof__ (self) wself = self;
//    [MineNetworkService gainAddressListWithHeaderParams:paramsHeader Success:^(NSArray *addressArr) {
//        wself.addressList = addressArr;
//        for (AddressModel* item in addressArr) {
//            if (item.defaultBool == true) {
//
//                break;
//            }
//        }
//    } failure:^(id  _Nonnull response) {
//        [wself showHint:response];
//    }];
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
#pragma mark - Actions
//选择预约时间
- (IBAction)timeViewTap:(id)sender {
    [self.view endEditing:YES];
    [_pickDateview show];
}
//支付
- (IBAction)buyButtonAction:(id)sender {
    [self.view endEditing:YES];

    if ([self.nameField.text isEqualToString:@""] ) {
        [self showHint:self.view text:@"请填写您的姓名"];
        return;
    } else if  ([self.phoneField.text isEqualToString:@""]) {
        [self showHint:self.view text:@"请填写您的手机号"];
        return;
    } else if  ([self.timeField.text isEqualToString:@""]) {
        [self showHint:self.view text:@"请选择您要预约的时间"];
        return;
    }
    if  (self.token == nil) {
        [self showHint:self.view text:@"请登录"];
        return;
    }
    
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    //组装数据
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.nameField.text forKey:@"contact"];
    [params setObject:self.phoneField.text forKey:@"contactNumber"];
    [params setObject:self.myTextView.text forKey:@"message"];
    [params setObject:[format stringFromDate:self.selectDate] forKey:@"subscribeTime"];
    //NSLog(@"timeLabel:%@", self.timeField.text);
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.detailModel.productInfo.productId] forKey:@"productId" ];
    [params setObject:[NSString stringWithFormat:@"%ld", self.currentProductPriceModel.productSaleId] forKey:@"productSaleId" ];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService orderBuildAndCropServiceWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [weakSelf showHint:@"预约成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id response) {
        [weakSelf showHint:response];
    }];
}


#pragma mark - setters
- (void)setDetailModel:(ServiceDetailModel *)detailModel{
    _detailModel = detailModel;

    NSURL *url = [NSURL URLWithString:@""];
    if (detailModel.productInfo.detailImg.count > 0) {
        url = [NSURL URLWithString:detailModel.productInfo.detailImg[0]];
    }
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];

    self.navigationItem.title = detailModel.productInfo.name;

    self.oneLabel.text = detailModel.productInfo.name;//产品名称
    self.twoLabel.text = detailModel.productInfo.supplierName;
    
    ServiceProductSkuInfoAttrModel *selectItem = nil;
    for (ServiceProductSkuInfoAttrModel *item in detailModel.productSku.skuInfo[0].attrList) {
        if (item.isSelect == true) {
            self.threeLabel.text = item.attrName;
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
    
    self.totalMoneyLabel.text = self.moneyLabel.text;
    
    self.phoneField.text = [GlobalConfigClass shareMySingle].userAndTokenModel.mobile;
}

@end
