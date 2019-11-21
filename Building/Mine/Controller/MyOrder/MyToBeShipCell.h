//
//  MyToBeShipCell.h
//  Building
//
//  Created by Mac on 2019/3/17.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyToBeShipCellBlock)(UIButton *btn);

@interface MyToBeShipCell : UITableViewCell
@property(nonatomic,strong)MyOrderItemModel *model;
@property(nonatomic,copy)MyToBeShipCellBlock refundBlock;
@end

NS_ASSUME_NONNULL_END
