//
//  YuYueServiceOrderDetailVC.h
//  Building
//
//  Created by Macbook Pro on 2019/3/3.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YuYueServiceOrderDetailVC : UIViewController
@property (nonatomic, copy)  NSString *orderId;//订单ID
@end

NS_ASSUME_NONNULL_END


@interface UILabel (LeftTopAlign)
- (void) textLeftTopAlign;
@end
