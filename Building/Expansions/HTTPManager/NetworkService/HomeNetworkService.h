//
//  HomeNetworkService.h
//  DimaPatient
//
//  Created by zhangyuqing on 16/7/21.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "HomeModel.h"

//@class InspectReportModel;
@interface HomeNetworkService : NSObject

//获取轮播图信息
+ (void)getBannerInfoWithType:(NSString *)typeStr Success:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure;

//首页服务列表
+ (void)getHomeServiceListSuccess:(void(^)(HomeServiceModel *serviceInfo))success failure:(void(^)(id response))failure;

//获取房源服务二级页面数据
+ (void)gainFYServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure;

//获取房源服务房间详情
+ (void)gainFYServiceHouseDetailHouseId:(NSInteger)houseId success:(void(^)(FYServiceDetailModel *detail))success failure:(void(^)(id response))failure;

//预约房间
//houseId,房间id,number;contact,联系人,string;contactNumber,联系电话,string;message,留言,string;
//subscribeTime,预约时间,string,格式：2018-11-20 10:30;
+ (void)orderFYServiceHouse:(NSInteger)houseId
                    contact:(NSString*)contact
              contactNumber:(NSString*)contactNumber
                    message:(NSString*)message
              subscribeTime:(NSString*)subscribeTime
                    success:(void(^)(NSInteger code))success
                    failure:(void(^)(id response))failure;

//获取楼宇、企业服务二级页面数据
+ (void)gainBuildServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure;

//获取企业服务二级页面数据
+ (void)gainCropServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure;

//获取楼宇/企业服务房间详情
+ (void)gainServiceDetailProductIda:(NSInteger)productId success:(void(^)(ServiceDetailModel *detail))success failure:(void(^)(id response))failure;

//支付信息获取接口，用于从后台获取支付所需信息
+ (void)gainAliPayInfoWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(NSString *payStr))success failure:(void (^)(NSString *response))failure;

+ (void)gainWeixinInfoWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(WeixinPayModel *weixinInfo))success failure:(void (^)(NSString *response))failure;

//预约服务
+ (void)orderBuildAndCropServiceWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure;

//支付宝客户端支付的回调方法
+ (void)analysisAlipayWithCallBackResult:(NSDictionary *)resultDic
                                 success:(void (^)(NSString *, BOOL))completionBlock;

//获取委托房源时的房源信息
+ (void)gainDelegateHouseDataSuccess:(void (^)(DelegateModel *response))success failure:(void (^)(NSString *response))failure;

//增加新的委托
+ (void)requestCreateDelegateHouseData:(NSMutableDictionary *)params Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure;
@end
