//
//  MineNetworkService.m
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MineNetworkService.h"

@implementation MineNetworkService

//获取房源类型订单列表
+ (void)gainYuYueBuildOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/houseSubscribe/list",BasicUrl];
    for (int i = 0; i < params.allKeys.count; i++) {
        NSString *keyStr = params.allKeys[i];
        id valueOb = [params objectForKey:keyStr];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@",url, keyStr, valueOb];
        } else {
            url = [NSString stringWithFormat:@"%@&%@=%@",url, keyStr, valueOb];
        }
        
    }
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            YuYueOrderListModel *serviceInfo = [YuYueOrderListModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

//获取房源类型订单详情
+ (void)gainYuYueBuildOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/houseSubscribe/detail",BasicUrl];
    for (int i = 0; i < params.allKeys.count; i++) {
        NSString *keyStr = params.allKeys[i];
        id valueOb = [params objectForKey:keyStr];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@",url, keyStr, valueOb];
        } else {
            url = [NSString stringWithFormat:@"%@&%@=%@",url, keyStr, valueOb];
        }
        
    }
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            YuYueOrderBuildDetailModel *serviceInfo = [YuYueOrderBuildDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

//获取服务类型订单列表
+ (void)gainYuYueServerOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/productSubscribe/list",BasicUrl];
    //NSLog(@"gainYuYueServerOrderListWithParams aurl:%@", url);

    for (int i = 0; i < params.allKeys.count; i++) {
        NSString *keyStr = params.allKeys[i];
        id valueOb = [params objectForKey:keyStr];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@",url, keyStr, valueOb];
        } else {
            url = [NSString stringWithFormat:@"%@&%@=%@",url, keyStr, valueOb];
        }
    }
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        //NSLog(@"gainYuYueServerOrderListWithParams url:%@", url);
        
        //int aa =[[response objectForKey:@"code"] integerValue];
        //NSLog(@"gainYuYueServerOrderListWithParams response:%ld", aa);
        
        if ([[response objectForKey:@"code"] integerValue] == 200){
            //NSLog(@"gainYuYueServerOrderListWithParams");
            YuYueServerListModel *serviceInfo = [YuYueServerListModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

//获取服务类型订单详情
+ (void)gainYuYueServiceOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/productSubscribe/detail",BasicUrl];
    for (int i = 0; i < params.allKeys.count; i++) {
        NSString *keyStr = params.allKeys[i];
        id valueOb = [params objectForKey:keyStr];
        if (i == 0) {
            url = [NSString stringWithFormat:@"%@?%@=%@",url, keyStr, valueOb];
        } else {
            url = [NSString stringWithFormat:@"%@&%@=%@",url, keyStr, valueOb];
        }
        
    }
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            YuYueOrderServiceDetailModel *serviceInfo = [YuYueOrderServiceDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

//取消预约
+ (void)cancelYuYueOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/subscribe/cancel",BasicUrl];
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

//添加地址
+ (void)addAddressWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/memberAddress/add",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
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

//获取收货人地址列表
+ (void)gainAddressListWithHeaderParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSArray *addressArr))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/memberAddress/list",BasicUrl];
    [QSNetworking getWithUrl:url headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
//            NSLog(@"response=%@", response);
            NSArray * articleArr = [NSArray yy_modelArrayWithClass:[AddressModel class] json:[response objectForKey:@"result"]];
            success(articleArr);
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

//更新地址
+ (void)updateAddressWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(NSInteger code))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/memberAddress/update",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
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

//获取我的退款单列表
+ (void)gainMyRefundListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/order/refund/list",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:NO params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200) {
            RefundListModel *refundInfo=[RefundListModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(refundInfo);
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
}

//获取退款单详情
+ (void)gainMyRefundDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    
    NSString *url=[NSString stringWithFormat:@"%@/order/refund/detail",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:NO params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200) {
            RefundDetailModel *refundInfo=[RefundDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(refundInfo);
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
    
}

//退款单撤销申请
+ (void)discharageMyRefundItemWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/order/productBuyRefund/cancel",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        //NSLog(@"response:%@",response);
        if ([[response objectForKey:@"code"] integerValue]==200){
            if (success) {
                success([response objectForKey:@"msg"]);
            }
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

//我的退款-确认收货-申请退款-取消
//+(void)confirmProductWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
//    NSString *url=[NSString stringWithFormat:@"%@/order/productBuy/operate",BasicUrl];
//    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
//        NSLog(@"response:%@",response);
//        if ([[response objectForKey:@"code"] integerValue]==200){
//            if (success) {
//                
//                success(NULL);
//            }
//        }else{
//            if (failure) {
//                failure([response objectForKey:@"msg"]);
//            }
//        }
//    } fail:^(NSError *error) {
//        if (failure) {
//            failure(@"网络错误");
//        }
//    }];
//    
//}

//实名认证-获取信息
+ (void)gainAuthinfoWithSuccess:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    NSMutableDictionary *headerParams=[[NSMutableDictionary alloc]init];
    
    NSString *url=[NSString stringWithFormat:@"%@/member/auth/info",BasicUrl];
    [headerParams setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    [QSNetworking getWithUrl:url refreshCache:YES params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200){
            AuthInfoModel *model=[AuthInfoModel yy_modelWithJSON:[response objectForKey:@"result"]];
            
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

//实名认证-查询可选房源列表
+ (void)gainSelectHouseListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(NSArray *array))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/house/getOnLine",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:NO params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200){
            NSArray *array=[NSArray yy_modelArrayWithClass:[buildingListModel class] json:[response objectForKey:@"result"]];
            success(array);
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


//实名认证-提交
+(void)gainSubmitWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/member/auth/submit",BasicUrl ];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200){
            if (success) {
                success([response objectForKey:@"msg"]);
            }
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

//获取我的订单列表
+ (void)gainMyOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/order/productBuy/list",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:YES params:params headerParams:headerParams success:^(id response) {
        //NSLog(@"response:%@",response);
        if ([[response objectForKey:@"code"] integerValue]==200) {
            MyOrderListModel *orderInfo=[MyOrderListModel yy_modelWithJSON:[response objectForKey:@"result"]];
            //NSLog(@"orderInfo:%@",orderInfo);
            success(orderInfo);
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
}

//我的列表-确认收货-申请退款-取消
+(void)confirmProductWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure;{
    NSString *url=[NSString stringWithFormat:@"%@/order/productBuy/operate",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        if ([[response objectForKey:@"code"] integerValue]==200){
            if (success) {
                success([response objectForKey:@"msg"]);
            }
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

//我的列表-订单详情
+(void)gainMyOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/order/productBuy/detail",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:YES params:params headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            MyOrderDetailModel *serviceInfo = [MyOrderDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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
//个人中心-待付款调用
+ (void)gainMyOrderPayWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure{
    NSString *url = [NSString stringWithFormat:@"%@/order/payByAli",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        //NSDictionary* dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            NSString *payStr = [response objectForKey:@"result"];
            success(payStr);
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
+ (void)gainWeixinOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(WeixinPayModel *weixinInfo))success failure:(void (^)(WeixinPayModel *weixinInfo))failure{
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


//委托出租列表
+ (void)gainRentalOrderListWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/rentalOrder/list",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:YES params:params headerParams:headerParams success:^(id response) {
        //NSLog(@"response:%@",response);
        if ([[response objectForKey:@"code"] integerValue]==200) {
            rentalOrderListMode *roInfo=[rentalOrderListMode yy_modelWithJSON:[response objectForKey:@"result"]];
            //NSLog(@"roInfo:%@",roInfo);
            success(roInfo);
        }
    } fail:^(NSError *error) {
        if (failure) {
            failure(@"网络错误");
        }
    }];
}

//取消委托出租
+ (void)disCancelRentalOrderWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    NSString *url=[NSString stringWithFormat:@"%@/rentalOrder/cancel",BasicUrl];
    [QSNetworking postWithUrl:url params:params headerParams:headerParams success:^(id response) {
        //NSLog(@"response:%@",response);
        if ([[response objectForKey:@"code"] integerValue]==200){
            if (success) {
                success([response objectForKey:@"msg"]);
            }
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
//委托出租详情
+(void)gainRentalOrderDetailWithParams:(NSMutableDictionary *)params headerParams:(NSMutableDictionary *)headerParams Success:(void(^)(id response))success failure:(void(^)(id response))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@/rentalOrder/detail",BasicUrl];
    [QSNetworking getWithUrl:url refreshCache:YES params:params headerParams:headerParams success:^(id response) {
        NSDictionary *dict = (NSDictionary *)response;
        if ([[response objectForKey:@"code"] integerValue] == 200){
            rentalOrderDetailModel *serviceInfo = [rentalOrderDetailModel yy_modelWithJSON:[response objectForKey:@"result"]];
            success(serviceInfo);
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

/* */
@end
