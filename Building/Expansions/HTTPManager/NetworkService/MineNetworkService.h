//
//  MineNetworkService.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineNetworkService : NSObject
//获取房源类型订单列表
+ (void)gainYuYueBuildOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//获取房源类型订单详情
+ (void)gainYuYueBuildOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//获取服务类型订单列表
+ (void)gainYuYueServerOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//获取服务类型订单详情
+ (void)gainYuYueServiceOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//取消预约
+ (void)cancelYuYueOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure;

//添加地址
+ (void)addAddressWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure;

//获取收货人地址列表
+ (void)gainAddressListWithHeaderParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSArray *addressArr))success failure:(void(^)(id response))failure;

//更新地址
+ (void)updateAddressWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure;

//获取我的退款列表
+(void)gainMyRefundListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//获取退款详情
+(void)gainMyRefundDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//退款单撤销申请
+(void)discharageMyRefundItemWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//我的退款-确认收货-申请退款-取消
+(void)confirmProductWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//实名认证-获取信息
+(void)gainAuthinfoWithSuccess:(void(^)(id response))success failure:(void(^)(id response))failure;


//实名认证-查询可选房源列表
+(void)gainSelectHouseListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSArray *array))success failure:(void(^)(id response))failure;


//实名认证-提交
+(void)gainSubmitWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//获取我的订单列表
+(void)gainMyOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//我的列表-确认收货-申请退款-取消
//+(void)confirmProductWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//我的列表-订单详情
+ (void)gainMyOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;

//个人中心-待付款调用
+ (void)gainMyOrderPayWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;
+ (void)gainWeixinOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(WeixinPayModel *weixinInfo))success failure:(void(^)(id response))failure;

//获取我的订单列表
+(void)gainRentalOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;
//取消委托申请
+(void)disCancelRentalOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;
+ (void)gainRentalOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;


@end

NS_ASSUME_NONNULL_END
