//
//  UIButton+Extensions.h
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Extensions)
+ (instancetype)title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
