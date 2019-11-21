//
//  MyYuYueCell.h
//  Building
//
//  Created by Macbook Pro on 2019/3/1.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyYuYueCellCancelBlock)(UIButton *button);


@interface MyYuYueCell : UITableViewCell
@property (nonatomic, strong) YuYueOrderItemModel *orderModel;//
@property (nonatomic, copy) MyYuYueCellCancelBlock cancelBlock;
@end

NS_ASSUME_NONNULL_END
