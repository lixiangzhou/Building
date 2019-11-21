//
//  CJMenuCommonCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CJMenuCommonCell.h"

@interface CJMenuCommonCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CJMenuCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setters
- (void)setProvinceModel:(FYProvinceModel *)provinceModel{
    _provinceModel = provinceModel;
    
    self.titleLabel.text = provinceModel.provinceName;
    self.titleLabel.textColor = provinceModel.isSelect ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6E6E6E);
    if (provinceModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        self.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
}

- (void)setCityModel:(FYCityModel *)cityModel{
    _cityModel = cityModel;
    
    self.titleLabel.text = cityModel.cityName;
    BOOL selected = cityModel.isSelect;
    self.backgroundColor = selected ? [UIColor whiteColor] : UIColorFromHEX(0xF9F9F9);
    self.titleLabel.textColor = selected ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6E6E6E);
}

- (void)setShangQuanOneLevelModel:(FYShangQuanOneLevelModel *)shangQuanOneLevelModel{
    _shangQuanOneLevelModel = shangQuanOneLevelModel;
    
    self.titleLabel.text = shangQuanOneLevelModel.titleName;
    self.titleLabel.textColor = shangQuanOneLevelModel.isSelect ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6e6e6e);
    if (shangQuanOneLevelModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        self.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
}

-(void)setShangQuanCountryModel:(FYShangQuanCountryModel *)shangQuanCountryModel{
    _shangQuanCountryModel = shangQuanCountryModel;
    
    self.titleLabel.text = shangQuanCountryModel.countryName;
    self.titleLabel.textColor = shangQuanCountryModel.isSelect ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6e6e6e);
    if (shangQuanCountryModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        self.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
}

- (void)setShangQuanMetroModel:(FYShangQuanMetroModel *)shangQuanMetroModel {
    _shangQuanMetroModel = shangQuanMetroModel;
    
    self.titleLabel.text = shangQuanMetroModel.metroName;
    self.titleLabel.textColor = shangQuanMetroModel.isSelect ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6e6e6e);
    if (shangQuanMetroModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        self.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
}

- (void)setShangQuanTradingModel:(FYShangQuanTradingModel *)shangQuanTradingModel{
    _shangQuanTradingModel = shangQuanTradingModel;
    
    self.titleLabel.text = shangQuanTradingModel.tradingName;
    self.titleLabel.textColor = shangQuanTradingModel.isSelect ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6e6e6e);
    if (shangQuanTradingModel.isSelect) {
        self.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        self.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
