//
//  MyRefundCell.m
//  Building
//
//  Created by Mac on 2019/3/11.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyRefundCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyRefundCell()
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
//@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
//@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIView *actionsView;

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

@implementation MyRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(RefundItemModel *)model{
    _model=model;
    self.orderSnLabel.text=[NSString stringWithFormat:@"订单编号：%@",model.orderSn];
    //订单状态  0：待审核，1：已同意，2：已拒绝 3：待打款 4：已打款
    //refundStatus 退款单状态，0：待审核，2：已拒绝，3：待打款，4：已打款，5：待退货，6：待卖家收货（待收货），7：确认收货并退款（待打款），8：确认收货拒绝退款（已拒绝）
    
    // refundType 退款类型，1：售中退款；2：售后退款；3：售后退货退款
    [self.btns enumerateObjectsUsingBlock:^(UIButton  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    
    self.orderStatuLabel.textColor = UIColorFromHEX(0x515C6F);
    switch (model.refundStatus.integerValue) {
        case 0:
            self.orderStatuLabel.text = @"待审核";
            
            [self addActions:@[self.changeApplyBtn, self.cancelApplyBtn]];
            break;
        case 1:
            self.orderStatuLabel.text = @"已同意";
            break;
        case 2:
            self.orderStatuLabel.text = @"已拒绝";
            if (model.refundType == 1) {
                [self addActions:@[self.serviceBtn, self.cancelApplyBtn]];
            } else if (model.refundType == 2 || model.refundType == 3) {
                [self addActions:@[self.serviceBtn, self.changeApplyBtn, self.cancelApplyBtn]];
            }
            break;
        case 3:
            self.orderStatuLabel.text = @"待打款";
            break;
        case 4:
            self.orderStatuLabel.text = @"已退款";
            break;
        case 5:
            self.orderStatuLabel.textColor = UIColorFromHEX(0xE88719);
            self.orderStatuLabel.text = @"待退货";
            [self addActions:@[self.returnBtn]];
            break;
        case 6:
            self.orderStatuLabel.text = @"待卖家收货";
            break;
        case 7:
            self.orderStatuLabel.text = @"待打款";
            break;
        case 8:
            self.orderStatuLabel.text = @"已拒绝";
            if (model.refundType == 2) {
                [self addActions:@[self.serviceBtn]];
            }
            break;
    }

    NSURL *url = [NSURL URLWithString:model.productDetailImg];
    [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.nameLabel.text=model.productName;
    self.skuLabel.text=model.productSku;
    self.skuLabel.numberOfLines=0;
    self.companyLabel.text=model.supplierName;
    self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
    self.countLabel.text=model.quantity;
    self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
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

- (void)cancelApplyAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)changeApplyAction {
    if (self.changeBlock) {
        self.changeBlock();
    }
}

- (void)serviceAction {
    if (self.serviceBlock) {
        self.serviceBlock();
    }
}

- (void)returnAction {
    if (self.returnBlock) {
        self.returnBlock();
    }
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
