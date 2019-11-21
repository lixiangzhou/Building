/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint delegate:(id<MBProgressHUDDelegate>)delegate;

- (void)showHudInView:(UIView *)view hint:(NSString *)hint dimBackground:(BOOL)dim delegate:(id<MBProgressHUDDelegate>)delegate;

- (void)setCustomHudView:(UIView *)view hint:(NSString *)hint;

- (void)setHint:(NSString *)hint;

- (void)hideHud;

- (void)hideAfterDelay:(float)delay;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint afterDelay:(NSTimeInterval)delay;

- (void) showHint:(UIView *) view text:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
