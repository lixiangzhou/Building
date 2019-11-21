//
//  HomeChoiceCell.h
//  Building
//
//  Created by Macbook Pro on 2019/2/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeChoiceCell : UITableViewCell
@property (nonatomic, strong) HouseServiceModel *houseModel;//房源服务
@property (nonatomic, strong) ServiceItemModel *buildModel;//楼宇服务
@property (nonatomic, strong) ServiceItemModel *corpModel;//企业服务
@property (nonatomic, strong) ServiceItemModel *serviceModel;//服务

@end

NS_ASSUME_NONNULL_END
