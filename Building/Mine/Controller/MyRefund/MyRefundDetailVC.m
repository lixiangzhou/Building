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
#import "MyAfterSaleController.h"
#import "RefundController.h"

@interface MyRefundDetailVC ()
@property(nonatomic,strong)RefundDetailModel *model;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *mobileLabel;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) OrderProductBaseInfoView *productView;
@property (nonatomic, strong) UIView *actionsView;
@property (nonatomic, strong) UILabel *priceLabel;

/// 联系客服
@property (strong, nonatomic) UIButton *serviceBtn;
/// 取消申请
@property (strong, nonatomic) UIButton *cancelApplyBtn;
/// 修改申请
@property (strong, nonatomic) UIButton *changeApplyBtn;
/// 退货
@property (strong, nonatomic) UIButton *returnBtn;
@property (strong, nonatomic) NSArray *btns;
@end

@implementation MyRefundDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"订单详情"];
    [self setUI];
    [self getData];
}

- (void)setUI {
    [self setMainView];
    [self addAddressView];
    [self addProductView];
    [self prepareActions];
}

- (void)getData {
    MJWeakSelf
    [MineNetworkService gainMyRefundDetailWithParams:[@{@"refundId": self.refundId} mutableCopy] headerParams:[@{} mutableCopy] Success:^(id  _Nonnull response) {
        RefundDetailModel *model=response;
        
        weakSelf.contactLabel.text = [NSString stringWithFormat:@"联系人：%@", model.receiver];
        weakSelf.mobileLabel.text = [NSString stringWithFormat:@"电话：%@", model.contact];
        weakSelf.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@", model.address];
        weakSelf.productView.model = response;
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"总价：￥%@", model.amount];
        [weakSelf addActionsView:model];
        [weakSelf addRefundView:model];
        [weakSelf addSellerInfoView:model];
        [weakSelf addRefundSellerView:model];
        [weakSelf addRefundSellerGoodsView:model];
        [weakSelf addOrderView:model];
        [weakSelf addMessageView:model];
        
        [weakSelf.contentView layoutIfNeeded];
        CGFloat maxY = CGRectGetMaxY(weakSelf.contentView.subviews.lastObject.frame);
        [weakSelf.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(maxY));
        }];
        weakSelf.scrollView.contentSize = CGSizeMake(ScreenWidth, maxY);
    } failure:^(id  _Nonnull response) {
        NSLog(@"网络错误");
    }];
}

// MARK: - 留言
- (void)addMessageView:(RefundDetailModel *)model {
    if (model.message) {
        UIView *lastView = self.contentView.subviews.lastObject;
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view];
        
        UIView *msgView = [self addRowToView:view title:@"留言：" value:model.message isFirst:YES];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_bottom).offset(10);
            make.left.right.equalTo(self.contentView);
        }];
        
        [msgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.right.equalTo(view);
            make.bottom.equalTo(@-20);
        }];
    }
}

// MARK: - 订单信息
- (void)addOrderView:(RefundDetailModel *)model {
    UIView *lastView = self.contentView.subviews.lastObject;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    UIView *titleView = [UIView new];
    [view addSubview:titleView];
    [titleView addBottomLineLeft:12 right:12];
    
    UILabel *orderTitle = [UILabel title:@"订单信息" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
    [titleView addSubview:orderTitle];
    
    UIView *contentView = [UIView new];
    [view addSubview:contentView];
    
    [self addRowToView:contentView title:@"订单编号：" value:model.orderSn isFirst:YES];
    [self addRowToView:contentView title:@"订单状态：" value:[self getStatus:model] isFirst:NO];
    [self addRowToView:contentView title:@"下单时间：" value:model.createTime isFirst:NO];
    [self addRowToView:contentView title:@"支付时间：" value:model.payTime isFirst:NO];
    [self addRowToView:contentView title:@"申请退款时间：" value:model.refundApplyTime isFirst:NO];
    
    if (model.auditTime) {
        [self addRowToView:contentView title:@"审核通过时间：" value:model.auditTime isFirst:NO];
    }
    
    if (model.refundPayTime) {
        [self addRowToView:contentView title:@"退款时间：" value:model.refundPayTime isFirst:NO];
    }
    
    [contentView.subviews.lastObject mas_remakeConstraints:^(MASConstraintMaker *make) {
        UIView *v = contentView.subviews[contentView.subviews.count - 2];
        make.top.equalTo(v.mas_bottom);
        make.left.right.equalTo(contentView);
        make.bottom.equalTo(@-20);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
    }];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(view);
        make.height.equalTo(@36);
    }];
    
    [orderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19);
        make.centerY.equalTo(titleView);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.left.right.bottom.equalTo(view);
    }];
}

// MARK: - 退货给卖家
- (void)addRefundSellerGoodsView:(RefundDetailModel *)model {
    UIView *lastView = self.contentView.subviews.lastObject;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    UIView *titleView = [UIView new];
    [view addSubview:titleView];
    [titleView addBottomLineLeft:12 right:12];
    
    UILabel *refundTitle = [UILabel title:@"退货退款状态" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
    [titleView addSubview:refundTitle];
    
    UILabel *sallerAddressLabel = [UILabel title:[NSString stringWithFormat:@"退货退款状态：%@", [self getStatus:model]] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
    UILabel *sallerMsgLabel = [UILabel title:[NSString stringWithFormat:@"原因：%@", model.refundReason ?: @""] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
    
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
        make.right.equalTo(@-19);
        make.bottom.equalTo(@-20);
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
        
        UILabel *sallerAddressLabel = [UILabel title:[NSString stringWithFormat:@"物流公司：%@", model.returnLogisticsCompany] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        UILabel *sallerMsgLabel = [UILabel title:[NSString stringWithFormat:@"运单号：%@", model.returnLogisticsDocument] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        
        UILabel *pzLabel = [UILabel title:@"凭证：" txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        
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
                make.top.equalTo(pzLabel.mas_bottom).offset(10);
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
        
        UILabel *sallerAddressLabel = [UILabel title:[NSString stringWithFormat:@"卖家收货地址：%@", model.auditSellerInfo] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
        sallerAddressLabel.numberOfLines = 0;
        UILabel *sallerMsgLabel = [UILabel title:[NSString stringWithFormat:@"卖家留言：%@", model.auditSellerMsg] txtColor:UIColorFromHEX(0x6E6E6E) font:UIFontWithSize(13)];
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
        make.left.equalTo(leftLabel.mas_right).offset(5);
        make.right.lessThanOrEqualTo(@-19);
        make.top.equalTo(@5);
        make.bottom.lessThanOrEqualTo(@-5);
    }];
    
    return view;
}

- (void)setMainView {
    self.view.backgroundColor = BackGroundColor;
    
    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = BackGroundColor;
    self.scrollView.alwaysBounceVertical = YES;
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
        make.top.equalTo(self.scrollView);
        make.left.right.equalTo(self.view);
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
        make.left.right.equalTo(self.contentView);
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
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
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

- (NSString *)getStatus:(RefundDetailModel *)model {
    NSString *status = @"";
    switch (model.refundStatus.integerValue) {
        case 0:
            status = @"待审核";
            break;
        case 1:
            status = @"已同意";
            break;
        case 2:
            status = @"已拒绝";
            break;
        case 3:
            status = @"待打款";
            break;
        case 4:
            status = @"已退款";
            break;
        case 5:
            status = @"待退货";
            break;
        case 6:
            status = @"待卖家收货";
            break;
        case 7:
            status = @"待打款";
            break;
        case 8:
            status = @"已拒绝";
            break;
    }
    return status;
}

- (void)addActionsView:(RefundDetailModel *)model {
    switch (model.refundStatus.integerValue) {
        case 0:
            [self addActions:@[self.changeApplyBtn, self.cancelApplyBtn]];
            break;
        case 1:
            break;
        case 2:
            if (model.refundType == 1) {
                [self addActions:@[self.serviceBtn, self.cancelApplyBtn]];
            } else if (model.refundType == 2 || model.refundType == 3) {
                [self addActions:@[self.serviceBtn, self.changeApplyBtn, self.cancelApplyBtn]];
            }
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            [self addActions:@[self.returnBtn]];
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            if (model.refundType == 2) {
                [self addActions:@[self.serviceBtn]];
            }
            break;
    }
}

- (void)addActions:(NSArray *)btns {
    CGFloat maxX = ScreenWidth - 16;
    for (NSInteger i = btns.count - 1; i >= 0; i--) {
        UIButton *btn = btns[i];
        btn.mj_x = maxX - btn.mj_w;
        maxX = btn.mj_x - 10;
        btn.hidden = NO;
    }
}

- (void)prepareActions {
    self.returnBtn.hidden = YES;
    self.serviceBtn.hidden = YES;
    self.cancelApplyBtn.hidden = YES;
    self.changeApplyBtn.hidden = YES;
    
    [self.actionsView addSubview:self.returnBtn];
    [self.actionsView addSubview:self.serviceBtn];
    [self.actionsView addSubview:self.cancelApplyBtn];
    [self.actionsView addSubview:self.changeApplyBtn];
    
    self.btns = @[self.returnBtn, self.serviceBtn, self.cancelApplyBtn, self.changeApplyBtn];
}

- (void)cancelApplyAction {
    MJWeakSelf
    [MineNetworkService discharageMyRefundItemWithParams: [@{@"refundId": self.refundId} mutableCopy] headerParams:[@{} mutableCopy] Success:^(id  _Nonnull response) {
        [weakSelf showHint:response];
    } failure:^(id  _Nonnull response) {
        [weakSelf showHint:@"撤销申请失败"];
    }];
}

- (void)changeApplyAction {
    MyAfterSaleController *vc = [MyAfterSaleController new];
    vc.refundModel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)serviceAction {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15900594090"] options:@{} completionHandler:nil];
}

- (void)returnAction {
    RefundController *vc = [RefundController new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)cancelApplyBtn {
    if (_cancelApplyBtn == nil) {
        _cancelApplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 68, 20)];
        [_cancelApplyBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
        [_cancelApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelApplyBtn.backgroundColor = UIColorFromHEX(0x9ACCFF);
        _cancelApplyBtn.titleLabel.font = UIFontWithSize(13);
        _cancelApplyBtn.layer.cornerRadius = 3;
        _cancelApplyBtn.layer.masksToBounds = YES;
        [_cancelApplyBtn addTarget:self action:@selector(cancelApplyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelApplyBtn;
}

- (UIButton *)changeApplyBtn {
    if (_changeApplyBtn == nil) {
        _changeApplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 68, 20)];
        [_changeApplyBtn setTitle:@"修改申请" forState:UIControlStateNormal];
        [_changeApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeApplyBtn.backgroundColor = UIColorFromHEX(0x9ACCFF);
        _changeApplyBtn.titleLabel.font = UIFontWithSize(13);
        _changeApplyBtn.layer.cornerRadius = 3;
        _changeApplyBtn.layer.masksToBounds = YES;
        [_changeApplyBtn addTarget:self action:@selector(changeApplyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeApplyBtn;
}

- (UIButton *)serviceBtn {
    if (_serviceBtn == nil) {
        _serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 68, 20)];
        [_serviceBtn setTitle:@"联系客服" forState:UIControlStateNormal];
        [_serviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _serviceBtn.backgroundColor = UIColorFromHEX(0x9ACCFF);
        _serviceBtn.titleLabel.font = UIFontWithSize(13);
        _serviceBtn.layer.cornerRadius = 3;
        _serviceBtn.layer.masksToBounds = YES;
        [_serviceBtn addTarget:self action:@selector(serviceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBtn;
}

- (UIButton *)returnBtn {
    if (_returnBtn == nil) {
        _returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, 68, 20)];
        [_returnBtn setTitle:@"退货" forState:UIControlStateNormal];
        [_returnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _returnBtn.backgroundColor = UIColorFromHEX(0x9ACCFF);
        _returnBtn.titleLabel.font = UIFontWithSize(13);
        _returnBtn.layer.cornerRadius = 3;
        _returnBtn.layer.masksToBounds = YES;
        [_returnBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBtn;
}


@end
