//
//  MonthTimePicker.h
//  Building
//
//  Created by Macbook Pro on 2019/4/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonthTimePicker : UIView
@property (nonatomic, copy) void (^confirmBlock)(NSDate *date, NSString *dateString);
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
