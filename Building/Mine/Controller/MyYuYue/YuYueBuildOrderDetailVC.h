//
//  YuYueBuildOrderDetailVC.h
//  Building
//
//  Created by Macbook Pro on 2019/3/3.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyYuYueCell.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyYuYueCellCancelBlock)(UIButton *button);

@interface YuYueBuildOrderDetailVC : BaseViewController
@property (nonatomic, copy)  NSString *orderId;//订单ID
@property (nonatomic, copy) MyYuYueCellCancelBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
