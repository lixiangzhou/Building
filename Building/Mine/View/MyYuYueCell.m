//
//  MyYuYueCell.m
//  Building
//
//  Created by Macbook Pro on 2019/3/1.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MyYuYueCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyYuYueCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;//订单号
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;//订单状态
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeAndFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLabel;//佣金
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@end

@implementation MyYuYueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Actions
//取消订单按钮
- (IBAction)optionButtonAction:(id)sender {
    if (self.cancelBlock)
    {
        self.cancelBlock(sender);
    }
}

#pragma mark - setters
- (void)setOrderModel:(YuYueOrderItemModel *)orderModel{
    _orderModel = orderModel;
    
    NSURL *url = [NSURL URLWithString:orderModel.houseListImg];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.orderLabel.text = orderModel.orderSn;

    self.optionButton.layer.borderWidth = 1;
    self.optionButton.layer.borderColor = ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
    self.optionButton.layer.cornerRadius = 3;
    
    //订单状态  0：待受理，1：已受理，2：已取消
    if ([orderModel.orderStatus integerValue] == 0) {
        self.orderStatusLabel.text = @"待受理";
    } else if ([orderModel.orderStatus integerValue] == 1) {
        self.orderStatusLabel.text = @"已受理";
        self.optionButton.alpha = 0;
    } else {
        self.orderStatusLabel.text = @"已取消";
        self.optionButton.alpha = 0;
    }
    
    self.nameLabel.text = orderModel.houseName;
    self.sizeAndFloorLabel.text = [NSString stringWithFormat:@"%@㎡ | %@层", orderModel.acreage, orderModel.floor];////平米/楼层
    self.addressLabel.text = orderModel.buildingAddress;
    self.moneyLabel.text = orderModel.amount;
    self.serviceMoneyLabel.text = orderModel.commission;
    self.serviceMoneyLabel.alpha = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
