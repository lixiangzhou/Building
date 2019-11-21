//
//  HomeNetworkService.m
//  DimaPatient
//
//  Created by zhangyuqing on 16/7/21.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "HomeNetworkService.h"
//#import "HomeCommonModel.h"
//#import "ProductDetailModel.h"
//#import "InspectReportModel.h"


@implementation HomeNetworkService

//获取轮播图信息
+ (void)getBannerInfoWithType:(NSString *)typeStr Success:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/carousel/list",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?position=%@",url,typeStr];
    [QSNetworking getWithUrl:urlPra success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray * articleArr = [NSArray yy_modelArrayWithClass:[BannerModel class] json:[response objectForKey:@"result"]];
            success(articleArr);
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

//首页服务列表
+ (void)getHomeServiceListSuccess:(void(^)(HomeServiceModel *serviceInfo))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/home/servcieList",BasicUrl];
    NSString *cityId = @"0";
    if ([GlobalConfigClass shareMySingle].cityModel.cityId) {
        cityId = [GlobalConfigClass shareMySingle].cityModel.cityId;
    }
    NSString *urlPra = [NSString stringWithFormat:@"%@?cityId=%@",url, cityId];
    NSMutableDictionary* headerParams = [[NSMutableDictionary alloc] init];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token) {
        [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    }
    //NSLog( @"getHomeServiceListSuccess:%@", urlPra );
    [QSNetworking getWithUrl:urlPra headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            //            NSLog(@"%@", response);
            HomeServiceModel *serviceInfo = [HomeServiceModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

//获取企业服务二级页面数据
+ (void)gainCropServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/home/productType",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?cityId=%@&serviceType=%@",url, [GlobalConfigClass shareMySingle].cityModel.cityId, @"corpService"];
    [QSNetworking getWithUrl:urlPra success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray * articleArr = [NSArray yy_modelArrayWithClass:[BuildCropServiceTwoLevelModel class] json:[response objectForKey:@"result"]];
            success(articleArr);
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

//获取楼宇服务二级页面数据
+ (void)gainBuildServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/home/productType",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?cityId=%@&serviceType=%@",url, [GlobalConfigClass shareMySingle].cityModel.cityId, @"buildService"];
    [QSNetworking getWithUrl:urlPra success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray * articleArr = [NSArray yy_modelArrayWithClass:[BuildCropServiceTwoLevelModel class] json:[response objectForKey:@"result"]];
            success(articleArr);
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

//获取房源服务二级页面数据
+ (void)gainFYServiceSecondLevelVCDataSuccess:(void(^)(NSArray *banners))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/home/houseType",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?cityId=%@",url, [GlobalConfigClass shareMySingle].cityModel.cityId];
    [QSNetworking getWithUrl:urlPra success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            NSArray * articleArr = [NSArray yy_modelArrayWithClass:[FYServiceTwoLevelModel class] json:[response objectForKey:@"result"]];
            success(articleArr);
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

//获取房源服务房间详情
+ (void)gainFYServiceHouseDetailHouseId:(NSInteger)houseId success:(void(^)(FYServiceDetailModel *detail))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/house/detail",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?houseId=%ld",url, (long)houseId];
    
    NSMutableDictionary* headerParams = [[NSMutableDictionary alloc] init];
    if( [GlobalConfigClass shareMySingle].userAndTokenModel.token != nil )
    {
        [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    }
    [QSNetworking getWithUrl:urlPra headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            //NSLog(@"%@", [response objectForKey:@"result"]);
            FYServiceDetailModel *detailInfo = [FYServiceDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(detailInfo);
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

//获取楼宇/企业服务房间详情
+ (void)gainServiceDetailProductIda:(NSInteger)productId success:(void(^)(ServiceDetailModel *detail))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/product/detail",BasicUrl];
    NSString *urlPra = [NSString stringWithFormat:@"%@?productId=%ld",url, (long)productId];
    [QSNetworking getWithUrl:urlPra refreshCache:YES success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
//            NSLog(@"%@", [response objectForKey:@"result"]);
            ServiceDetailModel *detailInfo = [ServiceDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(detailInfo);
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

//预约房间
//houseId,房间id,number;contact,联系人,string;contactNumber,联系电话,string;message,留言,string;
//subscribeTime,预约时间,string,格式：2018-11-20 10:30;
+ (void)orderFYServiceHouse:(NSInteger)houseId
                    contact:(NSString*)contact
              contactNumber:(NSString*)contactNumber
                    message:(NSString*)message
              subscribeTime:(NSString*)subscribeTime
             success:(void(^)(NSInteger code))success
             failure:(void(^)(id response))failure {
    //组装数据，不加密
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@(houseId) forKey:@"houseId"];
    [params setObject:contact forKey:@"contact"];
    [params setObject:contactNumber forKey:@"contactNumber"];
    [params setObject:message forKey:@"message"];
    [params setObject:subscribeTime forKey:@"subscribeTime"];
    
    NSMutableDictionary* headerParams = [[NSMutableDictionary alloc] init];
    [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    
    //请求接口
    NSString *url = [NSString stringWithFormat:@"%@/order/createHouseBooking",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        DLog(@"%@", response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            success([[response objectForKey:@"code"] integerValue]);
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

//支付信息获取接口，用于从后台获取支付所需信息
+ (void)gainAliPayInfoWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(NSString *payStr))success failure:(void (^)(NSString *response))failure{
    NSString *url = [NSString stringWithFormat:@"%@/order/payByAli",BasicUrl];
    
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        NSDictionary* dict = (NSDictionary *)response;
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            NSString *str = dict[@"result"];
            success(str);
        }else{
            if (failure) {
                failure([response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        failure(@"网络错误");
    }];
}

+ (void)gainWeixinInfoWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(WeixinPayModel *weixinInfo))success failure:(void (^)(NSString *response))failure{
    NSString *url = [NSString stringWithFormat:@"%@/order/payByWeixin",BasicUrl];
    
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        NSDictionary* dict = (NSDictionary *)response;
        if ([[dict objectForKey:@"code"] integerValue] == 200) {
            WeixinPayModel *weixinInfo = [WeixinPayModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(weixinInfo);
        }else{
            if (failure) {
                failure([response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        failure(@"网络错误");
    }];
}


//预约服务
+ (void)orderBuildAndCropServiceWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure {
    //请求接口
    NSString *url = [NSString stringWithFormat:@"%@/order/createProductBooking",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        DLog(@"%@", response);
        if ([[response objectForKey:@"code"] integerValue] == 200) {
            success([[response objectForKey:@"code"] integerValue]);
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

#pragma makr - 支付宝客户端支付的回调方法(通知页面支付完成且成功了)
+ (void)analysisAlipayWithCallBackResult:(NSDictionary *)resultDic
                                 success:(void (^)(NSString *, BOOL))completionBlock {
    NSString *hintStr = @"";
    NSInteger resultStatus = [resultDic[@"resultStatus"] intValue];
    if (resultStatus == 4000) {
        hintStr = @"订单支付失败";
//        SVPHUD_ShowError(hintStr);
    } else if (resultStatus == 9000) {
        hintStr = @"订单支付成功";
//        SVPHUD_ShowSuccess(hintStr);
        
        NSString * resultStr = resultDic[@"result"];
        NSArray * resultArray = [resultStr componentsSeparatedByString:@"&"];
        NSString * out_trade_no = @"";
        for (int i = 0; i< resultArray.count; i++) {
            NSString * kindStr = resultArray[i];
            NSArray * kindArray = [kindStr componentsSeparatedByString:@"="];
            if (kindArray.count > 0) {
                if ([kindArray[0] isEqualToString:@"out_trade_no"]) {
                    out_trade_no = kindArray[1];
                    // success
                    if (out_trade_no.length > 0) {
                    }
                    break;
                }
            }
        }
    } else if (resultStatus == 8000) {
        hintStr = @"正在处理中";
//        SVPHUD_ShowInfo(hintStr);
    } else if (resultStatus == 6001) {
        hintStr = @"支付已被中途取消";
//        SVPHUD_ShowError(hintStr);
    } else if (resultStatus == 6002) {
        hintStr = @"网络连接出错";
//        SVPHUD_ShowError(hintStr);
    } else {
        hintStr = @"支付异常，请联系客服";
//        SVPHUD_ShowError(hintStr);
    }
    completionBlock(hintStr, 9000 == resultStatus);
    
    //通知页面支付完成，且成功了
    if (resultStatus != 9000) {
        NSNumber *number = [NSNumber numberWithInteger:resultStatus];
        [[NSNotificationCenter defaultCenter] postNotificationName:PayServiceDidCompleNotification object:number];
    }
}

//获取委托房源时的房源信息
+ (void)gainDelegateHouseDataSuccess:(void (^)(DelegateModel *response))success failure:(void (^)(NSString *response))failure{
    NSString *url = [NSString stringWithFormat:@"%@/member/myHouse",BasicUrl];
    
    NSMutableDictionary* headerParams = nil;
    if ([GlobalConfigClass shareMySingle].userAndTokenModel != nil) {//登录
        headerParams = [[NSMutableDictionary alloc] init];
        [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    }
    
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == 200) {
//            NSLog(@"%@", [response objectForKey:@"result"]);
            DelegateModel *detailInfo = [DelegateModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(detailInfo);
        }else{
            if (failure) {
                failure([response objectForKey:@"msg"]);
            }
        }
    } fail:^(NSError *error) {
        failure(@"网络错误");
    }];
}

//增加新的委托
+ (void)requestCreateDelegateHouseData:(NSMutableDictionary *)params Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure {
    NSString *url = [NSString stringWithFormat:@"%@/rentalOrder/add",BasicUrl];
    
    NSMutableDictionary* headerParams = nil;
    if ([GlobalConfigClass shareMySingle].userAndTokenModel != nil) {//登录
        headerParams = [[NSMutableDictionary alloc] init];
        [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    }
    //NSLog(@"requestCreateDelegateHouseData-headerParams:%@", headerParams);
    //NSLog(@"requestCreateDelegateHouseData-params:%@", params);

    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            //            YuYueOrderServiceDetailModel *serviceInfo = [YuYueOrderServiceDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(200);
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

@end
