//
//  CYLTabBarControllerConfig.h
//  DimaPatient
//
//  Created by qingsong on 16/6/15.
//  Copyright © 2016年 certus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface CYLTabBarControllerConfig : NSObject

@property (nonatomic, readonly, strong) NSDictionary *homeResource;
@property (nonatomic, readonly, strong) NSDictionary *houseResource;
@property (nonatomic, readonly, strong) NSDictionary *serviceResource;
@property (nonatomic, readonly, strong) NSDictionary *mineResource;

+ (instancetype)shared;

- (void)setRootControllerWithChildResources:(NSArray *)childResources;
- (CYLTabBarController *)getTabBarControllerWithChildResources:(NSArray *)childResources;
//@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;

@end

