//
//  GlobalConfigClass.m
//  SmartHealth
//
//  Created by Apple on 15/10/10.
//  Copyright (c) 2015年 certus. All rights reserved.
//

#import "GlobalConfigClass.h"

@interface GlobalConfigClass ()
{
    UserAndTokenModel *_userAndTokenModel;
}
@end

@implementation GlobalConfigClass

static GlobalConfigClass* mysingleClass = nil;

+(GlobalConfigClass *)shareMySingle
{
    static dispatch_once_t onceSingl;
    dispatch_once(&onceSingl, ^{
        
        mysingleClass = [[GlobalConfigClass alloc] init];
        
    });
    return mysingleClass;
    
}

- (FYCityModel *)cityModel {
    if (_cityModel == nil) {
        _cityModel = [[FYCityModel alloc] init] ;
        _cityModel.cityId = @"102";
        _cityModel.cityName = @"南京市";
        _cityModel.pinyin = @"nanjing";
    }
    return _cityModel;
}

- (void)setUserAndTokenModel:(UserAndTokenModel *)userAndTokenModel {
    _userAndTokenModel = userAndTokenModel;
    if (userAndTokenModel) {
        NSString *json = [userAndTokenModel yy_modelToJSONString];
        if (json.length) {
            [[NSUserDefaults standardUserDefaults] setObject:json forKey:@"userAndTokenModel"];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userAndTokenModel"];
    }
}

- (UserAndTokenModel *)userAndTokenModel {
    if (_userAndTokenModel == nil) {
        NSString *json = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAndTokenModel"];
        _userAndTokenModel = [UserAndTokenModel yy_modelWithJSON:json];
    }
    return _userAndTokenModel;
}

@end
