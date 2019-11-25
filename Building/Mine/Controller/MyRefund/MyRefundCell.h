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
//@property(nonatomic,copy)MyRefundCellBlock cannelBlock;
//@property(nonatomic,copy)MyRefundCellBlock confirmBlock;

@property(nonatomic, copy) void (^cancelBlock)(void);
@property(nonatomic, copy) void (^changeBlock)(void);
@property(nonatomic, copy) void (^serviceBlock)(void);
@property(nonatomic, copy) void (^returnBlock)(void);

@end

NS_ASSUME_NONNULL_END
