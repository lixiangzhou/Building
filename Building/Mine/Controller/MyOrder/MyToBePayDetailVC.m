//
//  MyToBePayDetailVC.m
//  Building
//
//  Created by Mac on 2019/3/17.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyToBePayDetailVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "paySelectControl.h"

@interface MyToBePayDetailVC ()
@property(nonatomic,copy)NSString *token;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic,strong) MyOrderDetailModel *model;

@property (nonatomic, strong) paySelectControl *ps;//委托视图


@end

@implementation MyToBePayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
    self.cancelBtn.layer.borderWidth=1;
    self.cancelBtn.layer.cornerRadius=3;
    self.cancelBtn.layer.borderColor=([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
    self.payBtn.layer.borderWidth=1;
    self.payBtn.layer.cornerRadius=3;
    self.payBtn.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    [self.addressLabel setNumberOfLines:0];
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
    self.addressLabel.minimumScaleFactor = 0.5;

    [self gainData];
    
    [self configPaySelect];

}

-(void)gainData{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    if (self.orderId!=nil) {
        [params setObject:self.orderId forKey:@"orderId"];
    }
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainMyOrderDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
       self.model=response;
        self.receiverLabel.text=self.model.receiver;
        self.phoneLabel.text=self.model.contact;
        self.addressLabel.text=self.model.address;
        NSURL *url = [NSURL URLWithString:self.model.productDetailImg];
        [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.nameLabel.text=self.model.productName;
        self.skuLabel.text=self.model.productSku;
        self.skuLabel.numberOfLines=0;
        self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //设置一个行高上限
        CGSize size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
        CGSize expect = [self.skuLabel sizeThatFits:size];
        self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
        self.companyLabel.text=self.model.supplierName;
        self.priceLabel.text=[NSString stringWithFormat:@"%@%@",self.model.price,self.model.priceUnit];
        self.countLabel.text=self.model.quantity;
        self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",self.model.amount ];
        self.orderSnLabel.text=self.model.orderSn;
        
        self.createTimeLabel.text=self.model.createTime;
        
        NSString *str = [NSString stringWithFormat:@"留言: %@",self.model.message ];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
      
        
        NSUInteger firstLoc = 0;
        // 需要改变的最后一个文字的位置
        NSUInteger secondLoc = [[noteStr string] rangeOfString:@":"].location;
        // 需要改变的区间
        NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);

      
        [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        // 改变字体大小及类型

        // 为label添加Attributed
        [self.messageLabel setAttributedText:noteStr];
        
        //self.messageLabel.text=[NSString stringWithFormat:@"留言: %@",self.model.message ];

        //设置一个行高上限
        size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
        expect = [self.addressLabel sizeThatFits:size];
        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
   
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    
    
}
- (IBAction)cancelClick:(id)sender {
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //取消参数
    NSMutableDictionary* cancelParams = [[NSMutableDictionary alloc] init];
    [cancelParams setObject:@"CANCEL" forKey:@"operate"];
    [cancelParams setObject:self.orderId forKey:@"orderId"];
    __weak __typeof__ (self) wself = self;
    [MineNetworkService confirmProductWithParams:cancelParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
        [wself showHint:response];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    

}

- (IBAction)payClick:(id)sender {
    self.ps.orderSn = self.model.orderSn;
    self.ps.paymode = 2;
    [self.ps showFrom:nil completion:^(BOOL isOK) {
        if (isOK) {
            [self gainData];
        }
    }];

/*
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //待支付参数
    NSMutableDictionary* payParams = [[NSMutableDictionary alloc] init];
    [payParams setObject:self.model.orderSn forKey:@"orderSn"];
    __weak __typeof__ (self) wself = self;
    //向后台获取支付宝拉起的字符串
    [MineNetworkService gainMyOrderPayWithParams:payParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
        //调阿里支付接口
        [[AlipaySDK defaultService] payOrder:response fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
            //            NSLog(@"payreslut : %@",resultDic);
            [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^{}];
        }];
        
        } failure:^(id  _Nonnull response) {
            [wself showHint:response];
        }];
*/

}

- (void)configPaySelect{
    //委托视图
    self.ps = [[paySelectControl alloc] init];
    self.ps.pscd = self;
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



@end
