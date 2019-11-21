//
//  CJMenuCommonCell.h
//  Building
//
//  Created by Macbook Pro on 2019/2/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CJMenuCommonCell : UITableViewCell
@property (nonatomic, strong) FYProvinceModel *provinceModel;//
@property (nonatomic, strong) FYCityModel *cityModel;//
@property (nonatomic, strong) FYShangQuanOneLevelModel *shangQuanOneLevelModel;//
@property (nonatomic, strong) FYShangQuanCountryModel *shangQuanCountryModel;//
@property (nonatomic, strong) FYShangQuanTradingModel *shangQuanTradingModel;//
@property (nonatomic, strong) FYShangQuanMetroModel *shangQuanMetroModel;

@end

NS_ASSUME_NONNULL_END
