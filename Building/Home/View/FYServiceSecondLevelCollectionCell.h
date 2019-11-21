//
//  FYServiceSecondLevelCollectionCell.h
//  Building
//
//  Created by Macbook Pro on 2019/2/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYServiceSecondLevelCollectionCell : UICollectionViewCell
@property (nonatomic, strong) FYServiceTwoLevelDetailModel *model;
@property (nonatomic, strong) BuildCropServiceTwoLevelDetailModel *serviceModel;
@end

NS_ASSUME_NONNULL_END
