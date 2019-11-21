//
//  YuYueBuildOrderDetailVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/3.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "YuYueBuildOrderDetailVC.h"
#import "RRTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YuYueBuildOrderDetailVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *myContentView;
@property (weak, nonatomic) IBOutlet UILabel *lianXiRenLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//预约时间
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeAndFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLabel;//佣金
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *createOrderTimeLabel;//下单时间
@property (weak, nonatomic) IBOutlet UITextField *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UILabel *canncelTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *canncelButton;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, strong)  YuYueOrderBuildDetailModel  *detailModel;

@end

@implementation YuYueBuildOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"预约详情"];
    
    //数据初始化
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    [_myTextView setBackgroundColor:UIColorFromHEX(0xf7f7f7)];
    [_myTextView setUserInteractionEnabled:YES];
    _myTextView.delegate = self;
    [_myTextView setFont:UIFontWithSize(13)];
    _myTextView.enabled = NO;
    
    
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.messageLabel setNumberOfLines:0];
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.messageLabel.textAlignment = NSTextAlignmentLeft;
    //[_myTextView setPlaceholderOriginY:7 andOriginX:2];
//    _myTextView.placeholder = @"留言信息（最多300字）";
    
    [self gainYuYueBuildOrderDetail];
}

-(void)viewDidLayoutSubviews{
    [self.messageLabel sizeToFit];
}

#pragma mark - requests
//获取房源类型订单详情
- (void)gainYuYueBuildOrderDetail
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
    [MineNetworkService gainYuYueBuildOrderDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        YuYueOrderBuildDetailModel *detailModel = response;
        weakSelf.detailModel = response;
        
        //NSLog(@"contact:%@",detailModel.contact);
        
        self.lianXiRenLabel.text = detailModel.contact;
        self.telLabel.text = detailModel.contactNumber;
        self.timeLabel.text = detailModel.subscribeTime;//预约时间
        //NSLog(@"timeLabel:%@, %@", self.timeLabel.text, detailModel.subscribeTime );
        
        //self.timeLabel.text = @"aaaaaaa";
        
        NSURL *url = [NSURL URLWithString:detailModel.houseListImg];
        [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.orderLabel.text = detailModel.orderSn;
        self.nameLabel.text = detailModel.houseName;
        //NSLog(@"nameLabel:%@",self.nameLabel.text);
        self.sizeAndFloorLabel.text = [NSString stringWithFormat:@"%@㎡ | %@层", detailModel.acreage, detailModel.floor];////平米/楼层
        self.addressLabel.text = detailModel.buildingAddress;
        self.moneyLabel.text = detailModel.amount;
        //self.timeLabel.text =detailModel.subscribeTime;
        //self.timeLabel.alpha = 1;
        
        self.optionButton.alpha = 1;
        self.optionButton.layer.borderWidth = 1;
        self.optionButton.layer.borderColor = ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
        self.optionButton.layer.cornerRadius = 3;
        self.optionButton.backgroundColor = [UIColor redColor];

        self.canncelButton.alpha = 1;
        self.canncelButton.layer.borderWidth = 1;
        self.canncelButton.layer.borderColor = ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
        self.canncelButton.layer.cornerRadius = 3;
        
        
        //self.orderLabel.text = [NSString stringWithFormat:@"订单编号:  %@", detailModel.orderSn];
        NSLog(@"commission:%@",detailModel.commission);
        if (detailModel.commission.length > 0) {
            self.serviceMoneyLabel.hidden = NO;
            self.serviceMoneyLabel.text = [NSString stringWithFormat:@"佣金:         %@", detailModel.commission];
        } else {
            self.serviceMoneyLabel.hidden = YES;
        }
        //订单状态  0：待受理，1：已受理，2：已取消
        if ([detailModel.orderStatus integerValue] == 0) {
            self.orderLabel.text = [NSString stringWithFormat:@"订单编号:  %@", detailModel.orderSn];
            self.orderStatusLabel.text = @"订单状态:  待受理";
            self.createOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", detailModel.createTime];//下单时间
            self.canncelTimeLabel.alpha = 0;
            self.optionButton.alpha = 0;
            self.canncelButton.alpha = 1;
        } else if ([detailModel.orderStatus integerValue] == 1) {
            
            self.orderLabel.text = [NSString stringWithFormat:@"订单编号:  %@", detailModel.orderSn];
            self.orderStatusLabel.text = @"订单状态:  已受理";
            self.createOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", detailModel.createTime];//下单时间
            self.canncelTimeLabel.text = [NSString stringWithFormat:@"受理时间:  %@", detailModel.processTime];//受理时间

            self.optionButton.alpha = 0;
            self.canncelButton.alpha = 0;
        } else {
            self.orderLabel.text = [NSString stringWithFormat:@"订单编号:  %@", detailModel.orderSn];
            self.orderStatusLabel.text = @"订单状态:  已取消";
            self.createOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", detailModel.createTime];//下单时间
            self.canncelTimeLabel.text = [NSString stringWithFormat:@"取消时间:  %@", detailModel.cancelTime];//取消时间

            self.optionButton.alpha = 0;
            self.canncelButton.alpha = 0;
       }
        //self.createOrderTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", detailModel.createTime];//下单时间
        //self.myTextView.text = detailModel.message;//
        self.messageLabel.text = detailModel.message;//
        
        //设置一个行高上限
        CGSize size = CGSizeMake(self.nameLabel.frame.size.width, self.nameLabel.frame.size.height*2);
        CGSize expect = [self.nameLabel sizeThatFits:size];
        self.nameLabel.frame = CGRectMake( self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y, expect.width, expect.height );
        //设置一个行高上限
        size = CGSizeMake(self.messageLabel.frame.size.width, self.messageLabel.frame.size.height*2);
        expect = [self.messageLabel sizeThatFits:size];
        self.messageLabel.frame = CGRectMake( self.messageLabel.frame.origin.x, self.messageLabel.frame.origin.y, expect.width, expect.height );
        
    } failure:^(id  _Nonnull response) {
        [weakSelf showHint:response];
    }];
    
}
- (IBAction)optionButtonClick:(id)sender {
    if (self.cancelBlock)
    {
        self.cancelBlock(sender);
    }
}
- (IBAction)canncelButtonClick:(id)sender {
    [self cancelYuYueOrderType:@"HOUSE" orderId:self.detailModel.idStr];
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

@end
