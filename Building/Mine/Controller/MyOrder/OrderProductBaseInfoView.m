//
//  OrderProductBaseInfoView.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "OrderProductBaseInfoView.h"

@interface OrderProductBaseInfoView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *skuLabel;
@property (nonatomic, strong) UILabel *supplierLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLabel;
@end

@implementation OrderProductBaseInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconView = [UIImageView new];
        [self addSubview:self.iconView];
        
        self.nameLabel = [UILabel title:nil txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(15)];
        [self addSubview:self.nameLabel];
        
        self.skuLabel = [UILabel title:nil txtColor:UIColorFromHEX(0x999999) font:UIFontWithSize(12)];
        [self addSubview:self.skuLabel];
        
        self.supplierLabel = [UILabel title:nil txtColor:UIColorFromHEX(0x999999) font:UIFontWithSize(12)];
        [self addSubview:self.supplierLabel];
        
        self.priceLabel = [UILabel title:nil txtColor:UIColorFromHEX(0xFF9300) font:UIFontWithSize(16)];
        [self addSubview:self.priceLabel];
        
        self.numLabel = [UILabel title:nil txtColor:UIColorFromHEX(0x999999) font:UIFontWithSize(13)];
        [self addSubview:self.numLabel];
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@17);
            make.left.equalTo(@12);
            make.bottom.equalTo(@-17);
            make.width.equalTo(@120);
        }];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView);
            make.left.equalTo(self.iconView.mas_right).offset(10);
        }];
        
        [self.skuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        }];
        
        [self.supplierLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.skuLabel.mas_bottom).offset(3);
            make.left.equalTo(self.nameLabel);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconView);
            make.left.equalTo(self.nameLabel);
        }];
        
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(self.iconView);
        }];
    }
    return self;
}

- (void)setModel:(MyOrderItemModel *)model {
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.productDetailImg] placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    
    self.nameLabel.text = model.productName;
    self.skuLabel.text = model.productSku;
    
    self.supplierLabel.text = model.supplierName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", model.price, model.priceUnit];
    
    self.numLabel.text = [NSString stringWithFormat:@"x %@", model.quantity];
}

- (void)setRefundModel:(RefundItemModel *)refundModel {
    _refundModel = refundModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:refundModel.productDetailImg] placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    
    self.nameLabel.text = refundModel.productName;
    self.skuLabel.text = refundModel.productSku;
    
    self.supplierLabel.text = refundModel.supplierName;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", refundModel.price, refundModel.priceUnit];
    
    self.numLabel.text = [NSString stringWithFormat:@"x %@", refundModel.quantity];
}

@end
