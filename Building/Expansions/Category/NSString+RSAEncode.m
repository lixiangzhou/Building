//
//  NSString+RSAEncode.m
//  SmartHealth
//
//  Created by zhangyuqing on 16/5/19.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "NSString+RSAEncode.h"
#import "RSAEncode.h"
#import "MF_Base64Additions.h"

@implementation NSString (RSAEncode)

- (NSString *)rsaStringWithPublicKey:(NSString *)publicKeyStr {
    NSString * encryptStringResult = [RSAEncode encryptString:self publicKey:publicKeyStr];
    NSData *publickey_data = [NSData dataWithBase64String:encryptStringResult];
    /** BCD start */
    NSUInteger len = [publickey_data length];
    char* temp =  (char*)malloc(len * 2);
    char  val;
    Byte *bytes = (Byte*)malloc(len);
    memcpy(bytes, [publickey_data bytes], len);
    for (int i = 0; i<len; i++) {
        val = (char) (((bytes[i] & 0xf0) >> 4) & 0x0f);
        temp[i * 2] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
        
        val = (char) (bytes[i] & 0x0f);
        temp[i * 2 + 1] = (char) (val > 9 ? val + 'A' - 10 : val + '0');
        
    }
    NSData * b=  [NSData dataWithBytes:temp length:(len * 2)];
    /** BCD end */
    NSString * result =  [[NSString alloc] initWithData:b encoding:NSUTF8StringEncoding];
    return result;
}

@end
