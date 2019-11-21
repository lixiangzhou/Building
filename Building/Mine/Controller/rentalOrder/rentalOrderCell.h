//
//  rentalOrderCell.h
//  Building
//
//  Created by Mac on 2019/3/25.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^rentalOrderCellBlock)(UIButton *btn);

@interface rentalOrderCell : UITableViewCell
@property(nonatomic,strong)rentalOrderItemModel *model;
@property(nonatomic,copy)rentalOrderCellBlock cancelBlock;
@end
#define CELL_HIGHT     166

NS_ASSUME_NONNULL_END
