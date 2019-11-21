//
//  FangYuanNetworkService.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FangYuanNetworkService : NSObject
//城市、商圈基础数据查询
+ (void)getHomeCityShangQuanListSuccess:(void(^)(NSArray *citys))success failure:(void(^)(id response))failure;
// 楼盘
+ (void)getLouPanList:(NSDictionary *)param Success:(void(^)(NSArray<FYBuildListModel*> *loupanList))success failure:(void(^)(id response))failure;
//城市列表
+ (void)getHomeCityListSuccess:(void(^)(NSArray *citys))success failure:(void(^)(id response))failure;
//获取房源列表
+ (void)gainHouseResourceListWithParams:(NSMutableDictionary *)params Success:(void(^)(id response))success failure:(void(^)(id response))failure;
//获取服务列表
+ (void)gainServiceListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;
@end

NS_ASSUME_NONNULL_END
