//
//  ApplyRefundStateView.h
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyRefundStateView : UIView
@property (nonatomic, copy) void (^stateBlock) (NSInteger);
/// 1 未收到货； 2 已收到货
@property (nonatomic, assign) NSInteger state;

- (void)show;

- (void)hide;
@end

NS_ASSUME_NONNULL_END
