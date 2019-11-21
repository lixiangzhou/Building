//
//  MyYuYueServiceCell.m
//  Building
//
//  Created by Mac on 2019/3/27.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyYuYueServiceCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyYuYueServiceCell()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplierNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSkuLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;



@end


@implementation MyYuYueServiceCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setters
- (void)setServerModel:(YuYueServerItemModel *)model{
    _serverModel = model;
    //NSLog(@"orderSn:%@", model.orderSn );
    //NSLog(@"model.productDetailImg:%@", model.productDetailImg );
    //NSLog(@"productName:%@", model.productName );
    NSURL *url = [NSURL URLWithString:model.productDetailImg];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];

    self.orderLabel.text = [NSString stringWithFormat:@"订单编号:%@", model.orderSn];
    
    self.optionButton.layer.borderWidth = 1;
    self.optionButton.layer.borderColor = ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
    self.optionButton.layer.cornerRadius = 3;

    //订单状态  0：待受理，1：已受理，2：已取消
    if ([model.orderStatus integerValue] == 0) {
        self.orderStatusLabel.text = @"待受理";
    } else if ([model.orderStatus integerValue] == 1) {
        self.orderStatusLabel.text = @"已受理";
        self.optionButton.alpha = 0;
    } else {
        self.orderStatusLabel.text = @"已取消";
        self.optionButton.alpha = 0;
    }
    
    self.productNameLabel.text = model.productName;
    self.supplierNameLabel.text = model.supplierName;
    self.productSkuLabel.text = model.productSku;
    self.amoutLabel.text = [NSString stringWithFormat:@"%@%@", model.amount, model.amountUnit];
}
@end
