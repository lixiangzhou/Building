//
//  UIButton+Extensions.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)
+ (instancetype)title:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton new];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
