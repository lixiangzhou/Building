//
//  MyRefundDetailVC.m
//  Building
//
//  Created by Mac on 2019/3/12.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyRefundDetailVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderProductBaseInfoView.h"

@interface MyRefundDetailVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) OrderProductBaseInfoView *productView;
@property (nonatomic, strong) UIView *actionsView;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation MyRefundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"订单详情"];
//    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
//        self.token = nil;
//    } else {
//        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
//    }
//
//    [self.addressLabel setNumberOfLines:0];
//    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
//
//
//
//    [self gainRefundDetail];
//
//    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperview];
//    }];

    [self setUI];
    [self getData];
}

- (void)setUI {
    [self setMainView];
    [self addAddressView];
    [self addProductView];
}

- (void)setMainView {
    self.view.backgroundColor = BackGroundColor;
    
    self.scrollView = [UIScrollView new];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.scrollView];
    
    self.contentView = [UIView new];
    self.contentView.backgroundColor = BackGroundColor;
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.scrollView);
        make.width.equalTo(@(ScreenWidth));
        make.height.equalTo(@(ScreenHeight));
    }];
}

- (void)addProductView {
    self.productView = [OrderProductBaseInfoView new];
    [self.contentView addSubview:self.productView];
    
    self.actionsView = [UIView new];
    self.priceLabel = [UILabel title:@"总价：￥0" txtColor:UIColorFromHEX(0x515C6F) font:UIFontWithSize(12)];
    [self.actionsView addSubview:self.priceLabel];
    self.actionsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.actionsView];
    
    [self.productView addBottomLineLeft:12 right:12];
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@124);
    }];
    
    [self.actionsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@30);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@17);
        make.centerY.equalTo(self.actionsView);
    }];
}

- (void)addAddressView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    self.addressView = view;
    
    self.contactLabel = [UILabel title:@"联系人：" txtColor:UIColorFromHEX(0x6e6e6e) font:UIFontWithSize(13)];
    [view addSubview:self.contactLabel];
    
    self.mobileLabel = [UILabel title:@"电话：" txtColor:UIColorFromHEX(0x6e6e6e) font:UIFontWithSize(13)];
    [view addSubview:self.mobileLabel];
    
    self.addressLabel = [UILabel title:@"收货地址：" txtColor:UIColorFromHEX(0x6e6e6e) font:UIFontWithSize(13)];
    self.addressLabel.numberOfLines = 0;
    [view addSubview:self.addressLabel];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
    }];
    
    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@14);
        make.left.equalTo(@19);
        make.right.equalTo(view.mas_centerX).offset(-5);
    }];
    
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contactLabel);
        make.left.equalTo(view.mas_centerX).offset(5);
        make.right.equalTo(@-19);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19);
        make.right.equalTo(@-19);
        make.top.equalTo(self.contactLabel.mas_bottom).offset(10);
        make.bottom.equalTo(@-17);
    }];
}

- (void)getData {
    MJWeakSelf
    [MineNetworkService gainMyRefundDetailWithParams:@{@"refundId": self.refundId} headerParams:@{} Success:^(id  _Nonnull response) {
        RefundDetailModel *model=response;
        //NSLog(@"message:%@",model.message);
        weakSelf.contactLabel.text = [NSString stringWithFormat:@"联系人：%@", model.receiver];
        weakSelf.mobileLabel.text = [NSString stringWithFormat:@"电话：%@", model.contact];
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@", model.address];
        
        weakSelf.productView.model = response;
        
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"总价：￥%@", model.amount];
        
        [weakSelf addRefundView:model];
        [weakSelf addSellerInfoView:model];
        
        [weakSelf addRefundSellerView:model];
        

        [weakSelf.contentView layoutIfNeeded];
        CGFloat maxY = CGRectGetMaxY(weakSelf.contentView.subviews.lastObject.frame);
        [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(maxY));
        }];
        weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, maxY + NAV_HEIGHT);
        //设置一个行高上限
//        CGSize size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
//        CGSize expect = [self.addressLabel sizeThatFits:size];
//        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
//
//        NSURL *url = [NSURL URLWithString:model.productDetailImg];
//        [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
//        self.nameLabel.text=model.productName;
//        self.skuLabel.text=model.productSku;
//        self.skuLabel.numberOfLines=0;
//        self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        //设置一个行高上限
//        size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
//        expect = [self.skuLabel sizeThatFits:size];
//        self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
//        self.companyLabel.text=model.supplierName;
//        self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
//        self.countLabel.text=model.quantity;
//        self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
//        self.orderSnLabel.text=model.orderSn;
//        self.chexiaoshenqingButon.layer.cornerRadius = 3;
//
//        if ([model.refundStatus integerValue] == 0) {
//            self.statuLabel.text = @"待审核";
//        } else if ([model.refundStatus integerValue] == 1) {
//            self.statuLabel.text = @"已退款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.timeOrReson.text=@"退款时间:";
//            self.timeOrResonLabel.text=model.refundPayTime;
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 1;
//
//        } else if([model.refundStatus integerValue] ==2){
//            self.statuLabel.text = @"已拒绝";
//            self.successOrFail.text=@"审核失败时间:";
//            self.successOrFailTime.text=model.auditTime;
//            self.timeOrReson.text=@"审核失败原因:";
//            self.timeOrResonLabel.text=model.auditMsg;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }else if([model.refundStatus integerValue] ==3){
//            self.statuLabel.text = @"待打款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }else{
//            self.statuLabel.text = @"已打款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.timeOrReson.text=@"退款时间:";
//            self.timeOrResonLabel.text=model.refundPayTime;
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }
//        self.createTimeLabel.text=model.createTime;
//        self.payTimeLabel.text=model.payTime;
//        self.refundTimeLabel.text=model.refundApplyTime;
//        self.messageLabel.text=model.message;
//
//        //设置一个行高上限
//        size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
//        expect = [self.addressLabel sizeThatFits:size];
//        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );

    } failure:^(id  _Nonnull response) {
        NSLog(@"网络错误");

    }];
}

// MARK: - 退货给卖家
- (void)addRefundSellerView:(RefundDetailModel *)model {
    if (model.returnLogisticsProof.count || model.returnLogisticsDocument.length || model.returnLogisticsCompany.length) {
        UIView *lastView = self.contentView.subviews.lastObject;
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        UIView *titleView = [UIView new];
        [view addSubview:titleView];
        [titleView addBottomLineLeft:12 right:12];
        
        UILabel *refundTitle = [UILabel title:@"退货给卖家" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        [titleView addSubview:refundTitle];
        
        UILabel *sallerAddressLabel = [UILabel title:[NSString stringWithFormat:@"物流公司：%@", model.returnLogisticsCompany] txtColor:UIColorFromHEX(0xe6e6e6) font:UIFontWithSize(13)];
        UILabel *sallerMsgLabel = [UILabel title:[NSString stringWithFormat:@"运单号：%@", model.returnLogisticsDocument] txtColor:UIColorFromHEX(0xe6e6e6) font:UIFontWithSize(13)];
        
        UILabel *pzLabel = [UILabel title:@"凭证：" txtColor:UIColorFromHEX(0xe6e6e6) font:UIFontWithSize(13)];
        
        [view addSubview:sallerAddressLabel];
        [view addSubview:sallerMsgLabel];
        [view addSubview:pzLabel];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
        }];
        
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(view);
            make.height.equalTo(@36);
        }];
        
        [refundTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@19);
            make.centerY.equalTo(titleView);
        }];
        
        [sallerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.mas_bottom).offset(13);
            make.left.equalTo(@19);
            make.right.equalTo(@-19);
        }];
        
        [sallerMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sallerAddressLabel.mas_bottom).offset(15);
            make.left.right.equalTo(sallerAddressLabel);
            make.right.equalTo(@-19);
        }];
        
        if (model.returnLogisticsProof.count) {
            [pzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sallerMsgLabel.mas_bottom).offset(15);
                make.left.right.equalTo(sallerAddressLabel);
            }];

            UIView *picView = [UIView new];
            [view addSubview:picView];
            
            CGFloat x = 0;
            for (NSInteger i = 0; i < model.returnLogisticsProof.count; i++) {
                UIImageView *pv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 60, 60)];
                [pv sd_setImageWithURL:[NSURL URLWithString:model.returnLogisticsProof[i]]];
                [picView addSubview:pv];
                x = CGRectGetMaxX(pv.frame) + 20;
            }
            
            [picView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.left.equalTo(@19);
                make.height.equalTo(@60);
                make.width.equalTo(@280);
                make.bottom.equalTo(@-18);
            }];
        } else {
            [pzLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(sallerMsgLabel.mas_bottom).offset(15);
                make.left.right.equalTo(sallerAddressLabel);
                make.bottom.equalTo(@-20);
            }];
        }
    }
}

// MARK: - 退货信息
- (void)addSellerInfoView:(RefundDetailModel *)model {
    if (model.auditSellerMsg.length || model.auditSellerInfo.length) {
        UIView *lastView = self.contentView.subviews.lastObject;
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        UIView *titleView = [UIView new];
        [view addSubview:titleView];
        [titleView addBottomLineLeft:12 right:12];
        
        UILabel *refundTitle = [UILabel title:@"退货信息" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        [titleView addSubview:refundTitle];
        
        UILabel *sallerAddressLabel = [UILabel title:[NSString stringWithFormat:@"卖家收货地址：%@", model.auditSellerInfo] txtColor:UIColorFromHEX(0xe6e6e6) font:UIFontWithSize(13)];
        sallerAddressLabel.numberOfLines = 0;
        UILabel *sallerMsgLabel = [UILabel title:[NSString stringWithFormat:@"卖家留言：%@", model.auditSellerMsg] txtColor:UIColorFromHEX(0xe6e6e6) font:UIFontWithSize(13)];
        sallerMsgLabel.numberOfLines = 0;
        
        [view addSubview:sallerAddressLabel];
        [view addSubview:sallerMsgLabel];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
        }];
        
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(view);
            make.height.equalTo(@36);
        }];
        
        [refundTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@19);
            make.centerY.equalTo(titleView);
        }];
        
        [sallerAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.mas_bottom).offset(13);
            make.left.equalTo(@19);
            make.right.equalTo(@-19);
        }];
        
        [sallerMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(sallerAddressLabel.mas_bottom).offset(15);
            make.left.right.equalTo(sallerAddressLabel);
            make.bottom.equalTo(@-20);
        }];
    }
}

// MARK: - 退款信息
- (UIView *)addRefundView:(RefundDetailModel *)model {
    UIView *refundInfoView = [UIView new];
    refundInfoView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:refundInfoView];
    
    UIView *titleView = [UIView new];
    [refundInfoView addSubview:titleView];
    [titleView addBottomLineLeft:12 right:12];
    
    UILabel *refundTitle = [UILabel title:@"退款信息" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
    [titleView addSubview:refundTitle];
    
    UIView *contentView = [UIView new];
    [refundInfoView addSubview:contentView];
    
    //refundStatus 退款单状态，0：待审核，2：已拒绝，3：待打款，4：已打款，5：待退货，6：待卖家收货（待收货），7：确认收货并退款（待打款），8：确认收货拒绝退款（已拒绝）
    
    // refundType 退款类型，1：售中退款；2：售后退款；3：售后退货退款
    
    if (model.refundType == 1) {
        UIView *typeView = [self addRowToView:contentView title:@"退款类型：" value:@"售中退款" isFirst:YES];
        UIView *amountView = [self addRowToView:contentView title:@"退款金额：" value:[NSString stringWithFormat:@"￥%@", model.refundAmount] isFirst:NO];
        [amountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeView.mas_bottom);
            make.right.left.equalTo(contentView);
            make.bottom.equalTo(@-5);
        }];
    } else if (model.refundType == 2) {
        [self addRowToView:contentView title:@"退款类型：" value:@"售后退款" isFirst:YES];
        NSString *status = @"";
        if ([model.goodsStatus isEqualToString:@"1"]) {
            status = @"未收到货";
        } else if ([model.goodsStatus isEqualToString:@"2"]) {
            status = @"已收到货";
        }
        [self addRowToView:contentView title:@"货物状态：" value:status isFirst:NO];
        [self addRowToView:contentView title:@"退款原因：" value:model.refundReason isFirst:NO];
        [self addRowToView:contentView title:@"退款金额：" value:[NSString stringWithFormat:@"￥%@", model.refundAmount ?: @""] isFirst:NO];
        UIView *remarkView = [self addRowToView:contentView title:@"退款说明：" value:model.refundRemark isFirst:NO];
        UIView *pzView = [self addRowToView:contentView title:@"凭证：" value:@"" isFirst:NO];
                if (model.refundProof.count) {
            [self addPicViewToView:contentView pics:model.refundProof];
        } else {
            [pzView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remarkView.mas_bottom);
                make.left.right.equalTo(contentView);
                make.bottom.equalTo(@-8);
            }];
        }
    } else {
        [self addRowToView:contentView title:@"退款类型：" value:@"售后退货退款" isFirst:YES];
        [self addRowToView:contentView title:@"退款原因：" value:model.refundReason isFirst:NO];
        [self addRowToView:contentView title:@"退款金额：" value:[NSString stringWithFormat:@"￥%@", model.refundAmount ?: @""] isFirst:NO];
        UIView *remarkView = [self addRowToView:contentView title:@"退款说明：" value:model.refundRemark isFirst:NO];
        UIView *pzView = [self addRowToView:contentView title:@"凭证：" value:@"" isFirst:NO];
                if (model.refundProof.count) {
            [self addPicViewToView:contentView pics:model.refundProof];
        } else {
            [pzView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(remarkView.mas_bottom);
                make.left.right.equalTo(contentView);
                make.bottom.equalTo(@-8);
            }];
        }
    }
    
    [refundInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionsView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
    }];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(refundInfoView);
        make.height.equalTo(@36);
    }];
    
    [refundTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19);
        make.centerY.equalTo(titleView);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.right.bottom.equalTo(refundInfoView);
    }];
    
    return refundInfoView;
}

- (void)addPicViewToView:(UIView *)toView pics:(NSArray *)pics {
    UIView *lastView = toView.subviews.lastObject;
    
    UIView *picView = [UIView new];
    [toView addSubview:picView];
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < pics.count; i++) {
        UIImageView *pv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 60, 60)];
        [pv sd_setImageWithURL:[NSURL URLWithString:pics[i]]];
        [picView addSubview:pv];
        x = CGRectGetMaxX(pv.frame) + 20;
    }
    
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(5);
        make.left.equalTo(@19);
        make.height.equalTo(@60);
        make.width.equalTo(@280);
        make.bottom.equalTo(@-10);
    }];
}

- (UIView *)addRowToView:(UIView *)toView title:(NSString *)title value:(NSString *)value isFirst:(BOOL)isFirst {
    UIView *lastView = toView.subviews.lastObject;
    
    UIView *view = [UIView new];
    [toView addSubview:view];
    
    UILabel *leftLabel = [UILabel title:title txtColor:UIColorFromHEX(0x6e6e6e) font:UIFontWithSize(13)];
    [view addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel title:value ?: @"" txtColor:UIColorFromHEX(0x6e6e6e) font:UIFontWithSize(13)];
    [view addSubview:rightLabel];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isFirst) {
            make.top.equalTo(@8);
        } else {
            make.top.equalTo(lastView.mas_bottom);
        }
        
        make.left.right.equalTo(toView);
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19);
        make.top.equalTo(@5);
        make.bottom.lessThanOrEqualTo(@-5);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@90);
        make.right.equalTo(@-19);
        make.top.equalTo(@5);
        make.bottom.lessThanOrEqualTo(@-5);
    }];
    
    return view;
}


-(void)gainRefundDetail{
//    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
//    if (self.refundId!=nil) {
//        [params setObject:self.refundId forKey:@"refundId"];
//    }
//    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
//    if (self.token != nil) {
//        [paramsHeader setObject:self.token forKey:@"token"];
//    }
//     __weak __typeof__ (self) wself = self;
//    [MineNetworkService gainMyRefundDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
//
//        RefundDetailModel *model=response;
//        //NSLog(@"message:%@",model.message);
//        self.receiverLabel.text=model.receiver;
//        self.phoneLabel.text=model.contact;
//        self.addressLabel.text=model.address;
//
//        //设置一个行高上限
//        CGSize size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
//        CGSize expect = [self.addressLabel sizeThatFits:size];
//        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
//
//        NSURL *url = [NSURL URLWithString:model.productDetailImg];
//        [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
//        self.nameLabel.text=model.productName;
//        self.skuLabel.text=model.productSku;
//        self.skuLabel.numberOfLines=0;
//        self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        //设置一个行高上限
//        size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
//        expect = [self.skuLabel sizeThatFits:size];
//        self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
//        self.companyLabel.text=model.supplierName;
//        self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
//        self.countLabel.text=model.quantity;
//        self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
//        self.orderSnLabel.text=model.orderSn;
//        self.chexiaoshenqingButon.layer.cornerRadius = 3;
//
//        if ([model.refundStatus integerValue] == 0) {
//            self.statuLabel.text = @"待审核";
//        } else if ([model.refundStatus integerValue] == 1) {
//            self.statuLabel.text = @"已退款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.timeOrReson.text=@"退款时间:";
//            self.timeOrResonLabel.text=model.refundPayTime;
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 1;
//
//        } else if([model.refundStatus integerValue] ==2){
//            self.statuLabel.text = @"已拒绝";
//            self.successOrFail.text=@"审核失败时间:";
//            self.successOrFailTime.text=model.auditTime;
//            self.timeOrReson.text=@"审核失败原因:";
//            self.timeOrResonLabel.text=model.auditMsg;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }else if([model.refundStatus integerValue] ==3){
//            self.statuLabel.text = @"待打款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }else{
//            self.statuLabel.text = @"已打款";
//            self.successOrFail.text=@"审核通过时间:";
//            self.timeOrReson.text=@"退款时间:";
//            self.timeOrResonLabel.text=model.refundPayTime;
//            self.successOrFailTime.text=model.auditTime;
//            self.chexiaoshenqingButon.alpha = 0;
//
//        }
//        self.createTimeLabel.text=model.createTime;
//        self.payTimeLabel.text=model.payTime;
//        self.refundTimeLabel.text=model.refundApplyTime;
//        self.messageLabel.text=model.message;
//
//        //设置一个行高上限
//        size = CGSizeMake(self.addressLabel.frame.size.width, self.addressLabel.frame.size.height*2);
//        expect = [self.addressLabel sizeThatFits:size];
//        self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
//
//    } failure:^(id  _Nonnull response) {
//        NSLog(@"网络错误");
//
//    }];
    
}
- (void)chexiaoshenqingAction:(id)sender {
//    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
//
//    [params setObject:self.refundId forKey:@"refundId"];
//
//    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
//    if (self.token != nil) {
//        [paramsHeader setObject:self.token forKey:@"token"];
//    }
//    __weak __typeof__ (self) wself = self;
//    [MineNetworkService discharageMyRefundItemWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
//        [wself showHint:response];
//        [wself.navigationController popViewControllerAnimated:YES];
//    } failure:^(id  _Nonnull response) {
//        [wself showHint:@"撤销申请失败"];
//    }];

    
}

@end
