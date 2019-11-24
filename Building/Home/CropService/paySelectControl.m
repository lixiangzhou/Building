//
//  paySelectControl.m
//  Building
//
//  Created by Mac on 2019/4/8.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "paySelectControl.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WxApi.h"
#import "PayManager.h"

@interface paySelectControl()<UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *paySelectView;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIImageView *cancelImg;

@property (nonatomic, copy)  NSString  *token;//header传参,登录了传，没有不传，不影响数据的获取W
@property (strong, nonatomic) WeixinPayModel *wxInfo;

@end

@implementation paySelectControl


- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([paySelectControl class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }

    //self.paySelectView = [[UIView alloc] init];
    self.paySelectView.alpha = 1;
    self.paySelectView.backgroundColor = [UIColor whiteColor];
    self.paySelectView.layer.cornerRadius = 4;
    
    
    [self.cancelImg setImage:[UIImage imageNamed:@"guanbi"]];
    [self.cancelImg bringSubviewToFront:self.cancelImg];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClickImage)];
    [self.cancelImg addGestureRecognizer:tapGesture];
    self.cancelImg.userInteractionEnabled = YES;

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackCoverViewTapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
        
    self.zhifubaoBtn.layer.shadowRadius = 6;
    self.zhifubaoBtn.layer.shadowOpacity = 1;
    self.zhifubaoBtn.layer.cornerRadius = 6;
    self.zhifubaoBtn.layer.shadowColor = [UIColor colorWithRed:0 green:74/255 blue:240/255 alpha:0.16].CGColor;
    self.zhifubaoBtn.layer.shadowOffset = CGSizeMake(0, 3);
    self.weixinBtn.layer.shadowRadius = 6;
    self.weixinBtn.layer.shadowOpacity = 1;
    self.weixinBtn.layer.cornerRadius = 6;
    self.weixinBtn.layer.shadowColor = [UIColor colorWithRed:0 green:186/255 blue:29/255 alpha:0.16].CGColor;
    self.weixinBtn.layer.shadowOffset = CGSizeMake(0, 3);
//    if ([WXApi isWXAppInstalled])
//    {
//        NSLog(@"isWXAppInstalled");
//    }else{
//        self.weixinBtn.alpha = 0;
//        NSLog(@"isWXAppInstalled no");
//    }
}

-(void)cancelClickImage{
    [self.pscd coverViewTapActionOfpsView];
}

-(void) zhifubaoPayModel1{
    NSLog(@"zhifubaoPayModel1");
    
    NSLog(@"idStr:%@", self.idStr);
    NSLog(@"message:%@", self.message);
    NSLog(@"number:%@", self.number);
    NSLog(@"productId:%@", self.productId);
    NSLog(@"productSaleId:%@", self.productSaleId);
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.idStr forKey:@"addressId" ];
    [params setObject:self.message forKey:@"message" ];
    [params setObject:self.number forKey:@"number" ];
    //    [params setObject:@"" forKey:@"orderSn" ];
    [params setObject:self.productId forKey:@"productId" ];
    [params setObject:self.productSaleId forKey:@"productSaleId" ];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //NSLog(@"paramsHeader:%@", self.token);
    
    //__weak __typeof__ (self) weakSelf = self;
    [HomeNetworkService gainAliPayInfoWithParams:params headerParams:paramsHeader Success:^(NSString *payStr) {
        [[AlipaySDK defaultService] payOrder:payStr fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"payreslut : %@",resultDic);
            [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^(NSString *msg, BOOL isOK) {
                [[PayManager shared] showAlert:msg isOK:isOK];
            }];

            [self.pscd coverViewTapActionOfpsOkView];
            
        }];
    } failure:^(NSString *response) {
        //[weakSelf showHint:response];
        NSLog(@"支付失败");
    }];
    
    //[self.pscd coverViewTapActionOfpsView];
}

-(void) zhifubaoPayModel2{
    NSLog(@"zhifubaoPayModel2");
    
    NSLog(@"self.orderSn:%@", self.orderSn);

    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //待支付参数
    NSMutableDictionary* payParams = [[NSMutableDictionary alloc] init];
    [payParams setObject:self.orderSn forKey:@"orderSn"];
    //__weak __typeof__ (self) wself = self;
    //向后台获取支付宝拉起的字符串
    [MineNetworkService gainMyOrderPayWithParams:payParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
        //调阿里支付接口
        [[AlipaySDK defaultService] payOrder:response fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
            //            NSLog(@"payreslut : %@",resultDic);
            [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^(NSString *msg, BOOL isOK) {
                [[PayManager shared] showAlert:msg isOK:isOK];
            }];
        }];
        
        [self.pscd coverViewTapActionOfpsView];
    } failure:^(id  _Nonnull response) {
        //[wself showHint:response];
        NSLog(@"支付失败");
    }];
    
}

- (IBAction)zhifubaoClick:(id)sender {
    if( self.paymode == 1 ){
        [self zhifubaoPayModel1];
    }else if( self.paymode == 2 ){
        [self zhifubaoPayModel2];
    }
}

//微信支付
#pragma mark 微信支付方法
- (void)WechatPay{
    
    //需要创建这个支付对象
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = self.wxInfo.appid;
    NSLog(@"openID:%@", req.openID);
    // 商家id，在注册的时候给的
    req.partnerId = self.wxInfo.partnerid;
    NSLog(@"req.partnerId:%@", req.partnerId);
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = self.wxInfo.prepayid;
    NSLog(@"req.prepayId:%@", req.prepayId);
    // 根据财付通文档填写的数据和签名
    req.package  = self.wxInfo.packageValue;
    NSLog(@"req.package:%@", req.package);
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = self.wxInfo.noncestr;
    NSLog(@"req.nonceStr:%@", req.nonceStr);
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = self.wxInfo.timestamp;
    req.timeStamp = stamp.intValue;
    NSLog(@"req.timeStamp:%u", req.timeStamp);
    // 这个签名也是后台做的
    req.sign = self.wxInfo.sign;
    NSLog(@"req.sign:%@", req.sign);
    //发送请求到微信，等待微信返回onResp
    //NSLog(@"WechatPay");

    [WXApi sendReq:req];
}

-(void) weixinPayModel1{
    NSLog(@"weixinPayModel1");
    NSLog(@"idStr:%@", self.idStr);
    NSLog(@"message:%@", self.message);
    NSLog(@"number:%@", self.number);
    NSLog(@"productId:%@", self.productId);
    NSLog(@"productSaleId:%@", self.productSaleId);
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.idStr forKey:@"addressId" ];
    [params setObject:self.message ?: @"" forKey:@"message"];
    [params setObject:self.number forKey:@"number" ];
    //    [params setObject:@"" forKey:@"orderSn" ];
    [params setObject:self.productId forKey:@"productId" ];
    [params setObject:self.productSaleId forKey:@"productSaleId" ];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    [HomeNetworkService gainWeixinInfoWithParams:params headerParams:paramsHeader Success:^(WeixinPayModel *weixinInfo) {
        self.wxInfo = weixinInfo;
        [self WechatPay];
        [self.pscd coverViewTapActionOfpsOkView];
    } failure:^(NSString *response) {
        //[weakSelf showHint:response];
        NSLog(@"支付失败");
    }];
}
-(void) weixinPayModel2{
    NSLog(@"weixinPayModel2");
    NSLog(@"self.orderSn:%@", self.orderSn);

    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //待支付参数
    NSMutableDictionary* payParams = [[NSMutableDictionary alloc] init];
    [payParams setObject:self.orderSn forKey:@"orderSn"];
    //__weak __typeof__ (self) wself = self;
    //向后台获取支付宝拉起的字符串
    [MineNetworkService gainWeixinOrderWithParams:payParams headerParams:paramsHeader Success:^(WeixinPayModel *weixinInfo) {
        self.wxInfo = weixinInfo;
        [self WechatPay];
        [self.pscd coverViewTapActionOfpsView];
        
    } failure:^(id  _Nonnull response) {
        //[wself showHint:response];
        NSLog(@"支付失败");
    }];
}

- (IBAction)weixinClick:(id)sender {

    if( self.paymode == 1 ){
        [self weixinPayModel1];
    }else if( self.paymode == 2 ){
        [self weixinPayModel2];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self endEditing:YES];
    if ([touch.view isDescendantOfView:self.paySelectView]) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Actions
//cover视图tap响应函数
- (void)blackCoverViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    //    UIView *itemView = tapGesture.view;
    //    NSLog(@"%ld", (long)itemView.tag);
    [self endEditing:YES];
    if (self.pscd && [self.pscd respondsToSelector:@selector(coverViewTapActionOfpsView)]) {
        [self.pscd coverViewTapActionOfpsView];
    }
}

- (void)delegateGestureTapAction:(UITapGestureRecognizer *)tapGesture
{
    [self endEditing:YES];
}

- (void)showFrom:(UIViewController *)controller completion:(void (^)(BOOL))completion{
    [PayManager shared].fromController = controller;
    [PayManager shared].completion = completion;
    self.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
    
- (void)hide {
    [self removeFromSuperview];
}
    
@end
