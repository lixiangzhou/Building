//
//  FYServiceSecondLevelCollectionCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceSecondLevelCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FYServiceSecondLevelCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation FYServiceSecondLevelCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLabel.numberOfLines = 2;
}
#pragma mark - setters
- (void)setModel:(FYServiceTwoLevelDetailModel *)model{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    //self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = model.houseTypeName;
}

- (void)setServiceModel:(BuildCropServiceTwoLevelDetailModel *)serviceModel{
    _serviceModel = serviceModel;
    
    NSURL *url = [NSURL URLWithString:serviceModel.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    //self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.text = serviceModel.productTypeName;
}
@end
