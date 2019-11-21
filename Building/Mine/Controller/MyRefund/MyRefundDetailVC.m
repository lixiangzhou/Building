//
//  MyRefundDetailVC.m
//  Building
//
//  Created by Mac on 2019/3/12.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyRefundDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyRefundDetailVC ()
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
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *successOrFail;
@property (weak, nonatomic) IBOutlet UILabel *successOrFailTime;
@property (weak, nonatomic) IBOutlet UILabel *timeOrReson;
@property (weak, nonatomic) IBOutlet UILabel *timeOrResonLabel;

@property (weak, nonatomic) IBOutlet UIButton *chexiaoshenqingButon;

@property(nonatomic,copy)NSString *token;

@end

@implementation MyRefundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarTitle:@"订单详情"];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }

    [self.addressLabel setNumberOfLines:0];
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;

    

    [self gainRefundDetail];
   
}



-(void)gainRefundDetail{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    if (self.refundId!=nil) {
        [params setObject:self.refundId forKey:@"refundId"];
    }
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
     __weak __typeof__ (self) wself = self;
    [MineNetworkService gainMyRefundDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        
        RefundDetailModel *model=response;
        //NSLog(@"message:%@",model.message);
        self.receiverLabel.text=model.receiver;
        self.phoneLabel.text=model.contact;
        self.addressLabel.text=model.address;
        
        //设置一个行高上限
        CGSize size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
        CGSize expect = [self.addressLabel sizeThatFits:size];
        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
        
        NSURL *url = [NSURL URLWithString:model.productDetailImg];
        [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.nameLabel.text=model.productName;
        self.skuLabel.text=model.productSku;
        self.skuLabel.numberOfLines=0;
        self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //设置一个行高上限
        size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
        expect = [self.skuLabel sizeThatFits:size];
        self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
        self.companyLabel.text=model.supplierName;
        self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
        self.countLabel.text=model.quantity;
        self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
        self.orderSnLabel.text=model.orderSn;
        self.chexiaoshenqingButon.layer.cornerRadius = 3;

        if ([model.refundStatus integerValue] == 0) {
            self.statuLabel.text = @"待审核";
        } else if ([model.refundStatus integerValue] == 1) {
            self.statuLabel.text = @"已退款";
            self.successOrFail.text=@"审核通过时间:";
            self.timeOrReson.text=@"退款时间:";
            self.timeOrResonLabel.text=model.refundPayTime;
            self.successOrFailTime.text=model.auditTime;
            self.chexiaoshenqingButon.alpha = 1;
            
        } else if([model.refundStatus integerValue] ==2){
            self.statuLabel.text = @"已拒绝";
            self.successOrFail.text=@"审核失败时间:";
            self.successOrFailTime.text=model.auditTime;
            self.timeOrReson.text=@"审核失败原因:";
            self.timeOrResonLabel.text=model.auditMsg;
            self.chexiaoshenqingButon.alpha = 0;

        }else if([model.refundStatus integerValue] ==3){
            self.statuLabel.text = @"待打款";
            self.successOrFail.text=@"审核通过时间:";
            self.successOrFailTime.text=model.auditTime;
            self.chexiaoshenqingButon.alpha = 0;

        }else{
            self.statuLabel.text = @"已打款";
            self.successOrFail.text=@"审核通过时间:";
            self.timeOrReson.text=@"退款时间:";
            self.timeOrResonLabel.text=model.refundPayTime;
            self.successOrFailTime.text=model.auditTime;
            self.chexiaoshenqingButon.alpha = 0;

        }
        self.createTimeLabel.text=model.createTime;
        self.payTimeLabel.text=model.payTime;
        self.refundTimeLabel.text=model.refundApplyTime;
        self.messageLabel.text=model.message;
        
        //设置一个行高上限
        size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
        expect = [self.addressLabel sizeThatFits:size];
        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
        
    } failure:^(id  _Nonnull response) {
        NSLog(@"网络错误");
        
    }];
    
}
- (IBAction)chexiaoshenqingAction:(id)sender {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:self.refundId forKey:@"refundId"];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    __weak __typeof__ (self) wself = self;
    [MineNetworkService discharageMyRefundItemWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        [wself showHint:response];
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:@"撤销申请失败"];
    }];

    
}

@end
