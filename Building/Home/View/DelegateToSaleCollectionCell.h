//
//  DelegateToSaleCollectionCell.h
//  Building
//
//  Created by Macbook Pro on 2019/2/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DelegateToSaleCollectionCell : UICollectionViewCell
@property (nonatomic, strong) FYServiceTwoLevelDetailModel *model;
@property (nonatomic, strong) DelegateHouseModel *houseModel;
@end

NS_ASSUME_NONNULL_END
