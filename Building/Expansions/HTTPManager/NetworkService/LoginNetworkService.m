//
//  LoginNetworkService.m
//  dimadoctor
//
//  Created by scj on 16/6/13.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "LoginNetworkService.h"
//#import "MedicalTeamViewModel.h"

// 是否允许推送
static const NSString *kUserNsnotifi = @"/msg/ser/is";

/** 患者团队列表 */
static NSString * const kPatientTeam = @"/patientTeam/getPatientTeamMsg";


//static LoginNetworkService *_loginService = nil;//单例对象
@interface LoginNetworkService ()

@end

@implementation LoginNetworkService

#pragma mark 创建单例

//获取短信验证码，不加密
//usrType : 1、医生；2患者;3医助 termType: ADR\IOS   smsType   1、注册，2、忘记密码、3用户登录
+ (void)gainLoginSMSWithMobile:(NSString*)mobile
                       success:(void(^)(NSString *user))success
                       failure:(void(^)(id response))failure {
    //组装数据，不加密
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:mobile forKey:@"mobile"];
    
    //请求接口
    NSString *url = [NSString stringWithFormat:@"%@/sms/code/send",BasicUrl];
    [QSNetworking postWithUrl:url params:params success:^(id response) {
        NSDictionary* dict = (NSDictionary *)response;
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            if (success) {
                success(nil);
            }
        }else{
            if (failure) {
                failure([dict objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
}

//登录
+ (void)requestLogin:(NSString*)mobile
                code:(NSString*)code
                       success:(void(^)(UserAndTokenModel *model))success
                       failure:(void(^)(id response))failure {
    //组装数据，不加密
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:code forKey:@"code"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:@"ios" forKey:@"source"];
    
    NSMutableDictionary* headerParams = [[NSMutableDictionary alloc] init];
    [headerParams setObject:@"123456" forKey:@"deviceToken"];
    
    //请求接口
    NSString *url = [NSString stringWithFormat:@"%@/user/login",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
//        NSLog(@"%@", response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            UserAndTokenModel *model=[UserAndTokenModel yy_modelWithJSON: [response objectForKey:@"result"]];
            success(model);
        }else{
            if (failure) {
                failure([response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
}

@end
