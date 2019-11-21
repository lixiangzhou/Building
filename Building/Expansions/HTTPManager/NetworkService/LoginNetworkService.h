//
//  LoginNetworkService.h
//  dimadoctor
//
//  Created by scj on 16/6/13.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "HomeModel.h"

/**
 *  登陆注册部分的网络请求服务
 */
//@class MedicalTeamModel;
@interface LoginNetworkService : NSObject
////获取token
//+ (void)gainTokenSuccess:(void(^)(NSString *token))success
//                 failure:(void(^)(id response))failure;

//获取短信验证码，不加密
+ (void)gainLoginSMSWithMobile:(NSString*)mobile
                  success:(void(^)(NSString *user))success
                  failure:(void(^)(id response))failure;

//登录
+ (void)requestLogin:(NSString*)mobile
                code:(NSString*)code
             success:(void(^)(UserAndTokenModel *model))success
             failure:(void(^)(id response))failure;

@end
