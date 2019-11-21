//
//  PayManager.m
//  Building
//
//  Created by Macbook Pro on 2019/4/25.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "PayManager.h"
#import <UIKit/UIKit.h>

@implementation PayManager
+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PayManager new];
    });
    return instance;
}
    
- (void)showAlert:(NSString *)msg isOK:(BOOL)isOK {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"支付结果" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.completion) {
            self.completion(isOK);
            self.completion = nil;
        }
        [[PayManager shared].fromController.navigationController popViewControllerAnimated:YES];
    }]];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
}
@end
