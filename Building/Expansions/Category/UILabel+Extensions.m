//
//  UILabel+Extensions.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)
+ (instancetype)title:(NSString *)title txtColor:(UIColor *)color font:(UIFont *)font {
    UILabel *label = [UILabel new];
    label.text = title;
    label.textColor = color;
    label.font = font;
    return label;
}
@end
