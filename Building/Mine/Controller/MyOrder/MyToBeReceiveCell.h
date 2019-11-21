//
//  MyToBeReceiveCell.h
//  Building
//
//  Created by Mac on 2019/3/17.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyToBeReceiveCellBlock)(UIButton *btn);

@interface MyToBeReceiveCell : UITableViewCell
@property(nonatomic,strong)MyOrderItemModel *model;
@property(nonatomic,copy)MyToBeReceiveCellBlock refundBlock;
@property(nonatomic,copy)MyToBeReceiveCellBlock confirmBlock;
@end

NS_ASSUME_NONNULL_END
