//
//  OrderProductBaseInfoView.h
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderProductBaseInfoView : UIView
@property(nonatomic,strong)MyOrderItemModel *model;
@property(nonatomic,strong)RefundItemModel *refundModel; 
@end

NS_ASSUME_NONNULL_END
