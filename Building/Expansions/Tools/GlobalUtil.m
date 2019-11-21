//
//  GlobalUtil.m
//  DimaPatient
//
//  Created by qingsong on 16/6/16.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "GlobalUtil.h"
#import "NSString+RSAEncode.h"

static NSString * kFontName = @"Heiti SC";
static CGFloat  kFontSize = 13.f;

@implementation GlobalUtil

+ (CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str {

   return [self getSizeWithWidth:width content:str font:kFontSize];
}

+ (CGSize)getSizeWithMaxWidth:(CGFloat)width
                   content:(NSString *)content {
    
    return [self getSizeWithMaxWidth:width
                             content:content
                         lineSpacing:5
                                font:14.0f];
}

+ (CGSize)getSizeWithWidth:(CGFloat)width
                   content:(NSString *)content
               lineSpacing:(CGFloat)lineSpacing
                  fontSize:(CGFloat)fontSize {
    
    return [self getSizeWithMaxWidth:width
                             content:content
                         lineSpacing:lineSpacing
                                font:fontSize];
}

+ (CGSize)getSizeWithWidth:(CGFloat)width content:(NSString *)str font:(CGFloat)fontSize
{
    if (!str || ![str isKindOfClass:[NSString class]] || str.length == 0 || str == (id)kCFNull || [str isEqualToString:@""]) {
        
        return CGSizeZero;
    }
    NSMutableDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}.mutableCopy;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;

    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    return [str boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:attrs
                              context:nil].size;
}

+ (CGSize)getSizeWithMaxWidth:(CGFloat)width
                      content:(NSString *)str
                  lineSpacing:(CGFloat)lineSpacing
                         font:(CGFloat)fontSize
{
    if (!str || ![str isKindOfClass:[NSString class]] || str.length == 0 || str == (id)kCFNull || [str isEqualToString:@""]) {
        
        return CGSizeZero;
    }
    NSMutableDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]}.mutableCopy;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
    paragraphStyle.lineSpacing = lineSpacing;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    return [str boundingRectWithSize:maxSize
                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:attrs
                             context:nil].size;
}

// 获取 AttributedString
+ (NSMutableAttributedString *)getAttributedString:(NSString *)content
                                       lineSpacing:(CGFloat)lineSpacing
                                          fontSize:(CGFloat)fontSize {
    
    if (!content
       || ![content isKindOfClass:[NSString class]]
       || content.length == 0
       || content == (id)kCFNull
       || [content isEqualToString:@""]) {
        
        return nil;
    }
    
    if (lineSpacing <= 0.0f) {
        lineSpacing = 5;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    
    [attributedString addAttribute:NSFontAttributeName value:UIFontWithSize(fontSize) range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

+ (NSString *)stringWithJSONObject:(NSDictionary *)dict{
    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

//校验输入是否为手机号码，并获取验证码
+ (BOOL)checkMobileNumberTrue:(NSString *)mobileStr{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,184,187,188，1705
     * 联通：130,131,132,145,152,155,156,176,185,186,1709,
     * 电信：133,1349,153,177,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|7[0-9]|8[025-9])\\d{8}$";

    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,178,182,184,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[23478])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,152,155,156,176,185,186,1709,
     17         */
    NSString * CU = @"^1((3[0-2]|45|5[256]|76|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|77|8[019])\\d|349|700)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    //手机号码正则校验成功
    if (([regextestmobile evaluateWithObject:mobileStr] == YES)
        || ([regextestcm evaluateWithObject:mobileStr] == YES)
        || ([regextestct evaluateWithObject:mobileStr] == YES)
        || ([regextestcu evaluateWithObject:mobileStr] == YES)
        || ([regextestphs evaluateWithObject:mobileStr] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)dateStrForTime:(long long)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)dateStrForTime:(long long)time format:(NSString*)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (format) {
        [formatter setDateFormat:format];
    }
    else
    {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)dateStrForDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)dateStrForDate:(NSDate*)date  formatter:(NSString*)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (formatterStr) {
        [formatter setDateFormat:formatterStr];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+(NSString *)getTimeWithStr:(NSString *)str needSeconds:(BOOL)need{
    // 时间戳
    NSTimeInterval timeInterval = [str doubleValue] / 1000.0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (need) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return timeStr;
}

+ (CGSize)sizeWithString:(NSString*)str font:(UIFont *)font
{
    CGSize wsize = [str sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, 40)];
    CGSize hsize = [str sizeWithFont:font maxSize:CGSizeMake(320, MAXFLOAT)];
    return CGSizeMake(wsize.width, hsize.height);
}

+ (NSString *)customedNilObject:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"null"]) {
        return @"";
    }
    if (!obj) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@", obj];
}

+ (NSString*)uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
+ (NSString *)openUDID {
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierForVendor;
}

//将字典参数通过rsa加密
+ (NSString *)stringByRSAEncodeWithParams:(NSDictionary *)params publickey:(NSString *)token{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted  error:&error];
    if (! jsonData) {
        DLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString * publickey_token = token;
    return [jsonString rsaStringWithPublicKey:publickey_token];
}

@end
