//
//  WMDragViewManager.h
//  Building
//
//  Created by lixiangzhou on 2020/1/6.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMDragView.h"//拖拽视图
#import "DelegateToSaleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMDragViewManager : NSObject
@property(nonatomic, strong, nullable) WMDragView *dragView;//拖拽视图
@property (nonatomic, strong, nullable) DelegateToSaleView *delegateView;//委托视图

- (void)showDragViewFrom:(UIViewController *)controller;
@end

NS_ASSUME_NONNULL_END
