//
//  GlobalConfigClass.h
//  SmartHealth
//
//  Created by Apple on 15/10/10.
//  Copyright (c) 2015年 certus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYCommonModel.h"
#import "HomeModel.h"

@interface GlobalConfigClass : NSObject

+(GlobalConfigClass *)shareMySingle;
@property (nonatomic, strong) FYCityModel *cityModel;
@property (nonatomic, strong) UserAndTokenModel *userAndTokenModel;//登录成功后返回
@property (nonatomic, assign) BOOL LoginStatus;
@property (nonatomic, copy)  NSString  * serviceType;//楼宇服务：buildService;企业服务：corpService

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *realName;//真实姓名
@property (nonatomic, copy) NSString *imgUrl;//头像
@property (nonatomic, copy) NSString *userStatus;//'USR_S_EN','USR_S_DIS'
@property (nonatomic, assign) NSInteger duid;
@property (nonatomic, assign) NSInteger addressId;//行政区表id
@property (nonatomic, assign) NSInteger isUploadCase;//病历 true 上传过 false没有上传过
@property (nonatomic, copy) NSString *isPushMsg;


//============下面的待验证，不一定要

/**
 *  注册时生成的用户的UID 在后台中 是用户的唯一标识
 */
//@property (nonatomic, strong) NSString *userUIDFromRegister;

/**
 *  注册时的token
 */
@property (nonatomic, copy) NSString *tokenOfRegister;


/**
 *  医生是否认证，目前是工作台请求之后写入
 0未认证；1已认证；2认证中；3认证失败
 */
@property (nonatomic)   NSInteger status;
@end
