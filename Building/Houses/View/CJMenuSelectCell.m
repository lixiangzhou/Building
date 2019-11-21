//
//  CJMenuSelectCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CJMenuSelectCell.h"

@interface CJMenuSelectCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *chooseImage;

@end

@implementation CJMenuSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setters
- (void)setCityModel:(FYCityModel *)cityModel{
    _cityModel = cityModel;
    
    self.titleLabel.text = cityModel.cityName;
    self.titleLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.titleLabel.highlightedTextColor = UIColorFromHEX(0x6e6e6e);
    if (cityModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
        self.titleLabel.tintColor = UIColorFromHEX(0x73B8FD);
        self.chooseImage.hidden = NO;
    } else {
        self.backgroundColor = UIColorFromHEX(0xf9f9f9);
        self.titleLabel.tintColor = UIColorFromHEX(0x6e6e6e);
        self.chooseImage.hidden = YES;
    }
}

- (void)setCountryModel:(FYCountryModel *)countryModel{
    _countryModel = countryModel;
    
    self.titleLabel.text = countryModel.countryName;
    if (countryModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
        self.titleLabel.tintColor = UIColorFromHEX(0x73B8FD);
        self.titleLabel.textColor = UIColorFromHEX(0x73B8FD);
        self.titleLabel.highlightedTextColor = UIColorFromHEX(0x73B8FD);
        self.chooseImage.hidden = NO;
    } else {
        self.backgroundColor = UIColorFromHEX(0xf9f9f9);
        self.titleLabel.textColor = UIColorFromHEX(0x6e6e6e);
        self.titleLabel.highlightedTextColor = UIColorFromHEX(0x6e6e6e);
        self.titleLabel.tintColor = UIColorFromHEX(0x6e6e6e);
        self.chooseImage.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
