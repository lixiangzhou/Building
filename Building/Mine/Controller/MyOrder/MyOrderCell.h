//
//  MyOrderCell.h
//  Building
//
//  Created by Mac on 2019/3/4.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderCell : UITableViewCell
@property(nonatomic,strong)MyOrderItemModel *model;
@property (nonatomic, copy) void (^afterSaleBlock)(void);
@end

NS_ASSUME_NONNULL_END
