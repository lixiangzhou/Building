//
//  MyToBePayCell.h
//  Building
//
//  Created by Mac on 2019/3/17.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyToBePayCellBlock)(UIButton *btn);

@interface MyToBePayCell : UITableViewCell
@property(nonatomic,strong)MyOrderItemModel *model;
@property(nonatomic,copy)MyToBePayCellBlock cannelBlock;
@property(nonatomic,copy)MyToBePayCellBlock payBlock;

@end

NS_ASSUME_NONNULL_END
