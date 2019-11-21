//
//  GlobalUtil.h
//  DimaPatient
//
//  Created by qingsong on 16/6/16.
//  Copyright © 2016年 certus. All rights reserved.
// 用于存放公用的方法，在确定有必要的时候才去添加，慎重啊，么么哒

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalUtil : NSObject

/**
 *  计算文字的CGSize
 *
 *  @param width 文字的宽度区域
 *  @param str   文字内容
 *
 *  @return CGSize
 */
+ (CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str;
// 多一个fontSize
+ (CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str font:(CGFloat)fontSize;


/**
 计算文字的Size

 @param width 最大宽度
 @param content 内容
 @param lineSpacing 行间距
 @param fontSize 字体大小
 @return CGSize
 */
+ (CGSize)getSizeWithWidth:(CGFloat)width
                   content:(NSString *)content
               lineSpacing:(CGFloat)lineSpacing
                  fontSize:(CGFloat)fontSize;


/**
 计算MutableAttributedString Size  默认行间距为5  字体大小为14

 @param width width
 @param content content
 @return CGSize
 */
+ (CGSize)getSizeWithMaxWidth:(CGFloat)width
                      content:(NSString *)content;


/**
 获取MutableAttributedString

 @param content 内容
 @param lineSpacing 行间距
 @param fontSize 字体大小
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttributedString:(NSString *)content
                                       lineSpacing:(CGFloat)lineSpacing
                                          fontSize:(CGFloat)fontSize;

//字典转化为json字符串
+ (NSString *)stringWithJSONObject:(NSDictionary *)dict;
+ (CGSize)sizeWithString:(NSString*)str font:(UIFont *)font;
//校验输入是否为手机号码，并获取验证码
+ (BOOL)checkMobileNumberTrue:(NSString *)mobileStr;

+ (NSString *)dateStrForTime:(long long)time;
+ (NSString *)dateStrForTime:(long long)time format:(NSString*)format;
+ (NSString *)dateStrForDate:(NSDate*)date;
+ (NSString *)dateStrForDate:(NSDate*)date  formatter:(NSString*)formatterStr;
+(NSString *)getTimeWithStr:(NSString *)str needSeconds:(BOOL)need;

+ (NSString *)customedNilObject:(id)obj;
// 获取用户设备的UUID
+ (NSString*)uuid;
+ (NSString *)openUDID;

//将字典参数通过rsa加密
+ (NSString *)stringByRSAEncodeWithParams:(NSDictionary *)params publickey:(NSString *)token;

@end
