//
//  NSString+RSAEncode.h
//  SmartHealth
//
//  Created by zhangyuqing on 16/5/19.
//  Copyright © 2016年 certus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSAEncode)

/** 注意：该编码中包含了 BCD解码的过程，并非单纯的RSA加密。 */
- (NSString *) rsaStringWithPublicKey:(NSString *)publicKeyStr;

@end
