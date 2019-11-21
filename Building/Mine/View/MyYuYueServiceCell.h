//
//  MyYuYueServiceCell.h
//  Building
//
//  Created by Mac on 2019/3/27.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyYuYueServiceCancelBlock)(UIButton *button);

@interface MyYuYueServiceCell : UITableViewCell
@property (nonatomic, strong) YuYueServerItemModel *serverModel;
@property (nonatomic, copy) MyYuYueServiceCancelBlock cancelBlock;

@end

NS_ASSUME_NONNULL_END

