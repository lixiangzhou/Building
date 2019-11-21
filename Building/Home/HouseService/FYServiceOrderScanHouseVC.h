//
//  FYServiceOrderScanHouseVC.h
//  Building
//
//  Created by Macbook Pro on 2019/2/20.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYServiceOrderScanHouseVC : BaseViewController
@property (nonatomic, assign)  NSInteger houseId;//房间id

@property (strong, nonatomic) ServiceDetailModel *model;
@end

NS_ASSUME_NONNULL_END
