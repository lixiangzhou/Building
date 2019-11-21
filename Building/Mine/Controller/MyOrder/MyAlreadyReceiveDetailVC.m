//
//  MyAlreadyReceiveDetailVC.m
//  Building
//
//  Created by Mac on 2019/3/18.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyAlreadyReceiveDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyAlreadyReceiveDetailVC ()
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
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property(nonatomic,copy)NSString *token;
@end

@implementation MyAlreadyReceiveDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"订单详情"];
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
        MyOrderDetailModel *model=response;
        self.receiverLabel.text=model.receiver;
        self.phoneLabel.text=model.contact;
        self.addressLabel.text=model.address;
        NSURL *url = [NSURL URLWithString:model.productDetailImg];
        [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.nameLabel.text=model.productName;
        self.skuLabel.text=model.productSku;
        self.skuLabel.numberOfLines=0;
        self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //设置一个行高上限
        CGSize size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
        CGSize expect = [self.skuLabel sizeThatFits:size];
        self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
        self.companyLabel.text=model.supplierName;
        self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
        self.countLabel.text=model.quantity;
        self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
        self.orderSnLabel.text=model.orderSn;
        self.payTimeLabel.text=model.payTime;
        self.createTimeLabel.text=model.createTime;
        self.payTimeLabel.text=model.payTime;
        self.deliveryTimeLabel.text=model.deliveryTime;
        self.receiveTimeLabel.text=model.receiveTime;
        self.messageLabel.text=[NSString stringWithFormat:@"留言: %@",model.message ];

        //设置一个行高上限
        size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
        expect = [self.addressLabel sizeThatFits:size];
        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
        
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    
    
}

@end
