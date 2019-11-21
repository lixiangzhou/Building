//
//  HomeChoiceCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "HomeChoiceCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeChoiceCell ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end


@implementation HomeChoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setters
- (void)setCorpModel:(ServiceItemModel *)corpModel{
    _corpModel = corpModel;
    
    NSURL *url = [NSURL URLWithString:corpModel.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.titleLabel.width = ScreenWidth * 220 /375;
    self.titleLabel.height = 21;
    self.titleLabel.text = corpModel.name;
    self.secondLabel.text = corpModel.supplierName;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", corpModel.price];
}
- (void)setBuildModel:(ServiceItemModel *)buildModel{
    _buildModel = buildModel;
    
    NSURL *url = [NSURL URLWithString:buildModel.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.titleLabel.text = buildModel.name;
    self.secondLabel.text = buildModel.supplierName;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", buildModel.price];
    
}
- (void)setHouseModel:(HouseServiceModel *)houseModel{
    _houseModel = houseModel;
    
    NSURL *url = [NSURL URLWithString:houseModel.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.titleLabel.width = ScreenWidth * 220 /375;
    self.titleLabel.height = 21;
    self.titleLabel.text = houseModel.name;
    self.secondLabel.text = [NSString stringWithFormat:@"%@㎡", houseModel.acreage];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", houseModel.price];
}

- (void)setServiceModel:(ServiceItemModel *)serviceModel{
    _serviceModel = serviceModel;
    
    NSURL *url = [NSURL URLWithString:serviceModel.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.titleLabel.width = ScreenWidth * 220 /375;
    self.titleLabel.height = 21;
    self.titleLabel.text = serviceModel.name;
    self.secondLabel.text = [NSString stringWithFormat:@"%@", serviceModel.supplierName];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", serviceModel.price];
}
@end
