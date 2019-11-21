//
//  NSString+CalcWidthAndHeight.h
//  WGSForm
//
//  Created by wugensan on 15/8/31.
//  Copyright (c) 2015年 certus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CalcWidthAndHeight)
/**
 *  计算字符串所占空间大小
 *
 *  @param font    该字符串所用的字体
 *  @param maxSize 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 *
 *  @return 字符串宽高
 */
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+(NSDate*)dateFromString:(NSString*)string;

- (BOOL)isContainOfString:(NSString *)aString;

// 计算字符串所占空间大小 font 默认为13
- (CGSize)sizeWithConstrainedToWidth:(float)width;


- (CGSize)sizeWithConstrainedToWidth:(float)width fromFont:(UIFont *)font1 lineSpace:(float)lineSpace;


@end
