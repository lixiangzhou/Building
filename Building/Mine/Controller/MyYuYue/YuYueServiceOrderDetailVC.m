//
//  YuYueServiceOrderDetailVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/3.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "YuYueServiceOrderDetailVC.h"
#import "RRTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface YuYueServiceOrderDetailVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *lianXiRenLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//预约时间
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeAndFloorLabel;//产品规格
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//供应商
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLabel;//佣金
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createOrderTimeLabel;//下单时间
@property (weak, nonatomic) IBOutlet RRTextView *myTextView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *canncelButton;


@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, strong)  YuYueOrderServiceDetailModel  *detailModel;

@property (nonatomic, copy)  NSString  *idstr;//header传参,登录后有

@end

@implementation YuYueServiceOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"预约详情"];
    //数据初始化
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    self.canncelButton.alpha = 1;
    self.canncelButton.layer.borderWidth = 1;
    self.canncelButton.layer.borderColor = ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
    self.canncelButton.layer.cornerRadius = 3;

    [_myTextView setBackgroundColor:UIColorFromHEX(0xf7f7f7)];
    [_myTextView setUserInteractionEnabled:YES];
    _myTextView.delegate = self;
    [_myTextView setFont:UIFontWithSize(13)];
    [_myTextView setPlaceholderOriginY:7 andOriginX:2];
//    _myTextView.placeholder = @"留言信息（最多300字）";
    
    [self.nameLabel setNumberOfLines:0];
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.nameLabel.adjustsFontSizeToFitWidth = YES;
//    self.nameLabel.minimumScaleFactor = 0.5;
    [self gainYuYueServiceOrderDetail];
}


-(void)viewDidLayoutSubviews{
    [self.messageLabel sizeToFit];
}


#pragma mark - requests
//获取服务类型订单详情
- (void)gainYuYueServiceOrderDetail
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (self.orderId != nil) {
        [params setObject:self.orderId forKey:@"orderId"];
    }
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) weakSelf = self;
    [MineNetworkService gainYuYueServiceOrderDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        YuYueOrderServiceDetailModel *detailModel = response;
        weakSelf.detailModel = response;
        
        self.lianXiRenLabel.text = detailModel.contact;
        self.telLabel.text = detailModel.contactNumber;
        self.timeLabel.text = detailModel.subscribeTime;//预约时间
        
        NSURL *url = [NSURL URLWithString:detailModel.productDetailImg];
        [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.orderLabel.text = detailModel.orderSn;
        self.nameLabel.text = detailModel.productName;
        //设置一个行高上限
        CGSize size = CGSizeMake(self.nameLabel.frame.size.width, self.nameLabel.frame.size.height*2);
        CGSize expect = [self.nameLabel sizeThatFits:size];
        self.nameLabel.frame = CGRectMake( self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, expect.width, expect.height );

//        self.sizeAndFloorLabel.text = detailModel.productSku;//产品规格
//        self.addressLabel.text = detailModel.supplierName;//供应商
        self.sizeAndFloorLabel.text = detailModel.supplierName;//供应商名称
        self.addressLabel.text = detailModel.productSku;//产品规格
        self.moneyLabel.text = [NSString stringWithFormat:@"%@%@", detailModel.amount, detailModel.amountUnit];
        
        self.orderLabel.text = detailModel.orderSn;
        //订单状态  0：待受理，1：已受理，2：已取消
        if ([detailModel.orderStatus integerValue] == 0) {
            self.orderStatusLabel.text = @"待受理";
            self.canncelButton.alpha = 1;

        } else if ([detailModel.orderStatus integerValue] == 1) {
            self.orderStatusLabel.text = @"已受理";
            self.canncelButton.alpha = 0;

        } else {
            self.orderStatusLabel.text = @"已取消";
            self.canncelButton.alpha = 1;

        }
        self.createOrderTimeLabel.text = detailModel.createTime;//下单时间
        self.messageLabel.text = detailModel.message;//
    } failure:^(id  _Nonnull response) {
        [weakSelf showHint:response];
    }];
    
}


//取消预约:orderId    订单ID;type 订单类型    HOUSE：房源，PRODUCT：产品
- (void)cancelYuYueOrderType:(NSString *)type orderId:(NSString *)orderId
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    [params setObject:orderId forKey:@"orderId"];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService cancelYuYueOrderWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
}
- (IBAction)canncelButtonClick:(id)sender {
    [self cancelYuYueOrderType:@"PRODUCT" orderId:self.detailModel.id];

}


@end
