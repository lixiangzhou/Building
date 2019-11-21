//
//  MyRefundCell.h
//  Building
//
//  Created by Mac on 2019/3/11.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyRefundCellBlock)(UIButton *btn);

@interface MyRefundCell : UITableViewCell
@property(nonatomic,strong)RefundItemModel *model;
@property(nonatomic,copy)MyRefundCellBlock cannelBlock;
@property(nonatomic,copy)MyRefundCellBlock confirmBlock;

@end

NS_ASSUME_NONNULL_END
