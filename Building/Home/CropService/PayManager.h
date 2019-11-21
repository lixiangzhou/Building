//
//  PayManager.h
//  Building
//
//  Created by Macbook Pro on 2019/4/25.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayManager : NSObject
@property (nonatomic, weak) UIViewController *fromController;
@property (nonatomic, copy) void (^completion)(BOOL);
    
- (void)showAlert:(NSString *)msg isOK:(BOOL)isOK;

+ (instancetype)shared;
@end

NS_ASSUME_NONNULL_END
