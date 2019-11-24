//
//  ApplyRefundController.h
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApplyRefundController : BaseViewController
@property(nonatomic,strong)MyOrderItemModel *model;
/// 1 退款 ； 2 退货退款
@property(nonatomic,assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
