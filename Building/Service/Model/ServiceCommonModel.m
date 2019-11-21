//
//  ServiceCommonModel.m
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "ServiceCommonModel.h"

@implementation ServiceCommonModel

@end


////商圈数据--商圈
//@implementation FYShangQuanTradingModel
//@end
//
////商圈数据--区
//@implementation FYShangQuanCountryModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"countryId"       : @"countryId",
//             };
//}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"tradingInfoList" : [FYShangQuanTradingModel class]
//             };
//}
//@end
//
//@implementation FYShangQuanMetroModel
//@end
//
////商圈数据--城市
//@implementation FYShangQuanCityModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"cityId"       : @"cityId",
//             };
//}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"countryInfoList" : [FYShangQuanCountryModel class]
//             };
//}
//@end
//
//@implementation FYShangQuanOneLevelModel
//@end
//
////县级
//@implementation FYCountryModel
//@end
//
////市级
//@implementation FYCityModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"cityName"       : @"cityName",
//             };
//}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"countryInfoList" : [FYCountryModel class]
//             };
//}
//@end
//
////省级
//@implementation FYProvinceModel
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//             @"provinceName"       : @"provinceName",
//             };
//}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"cityList" : [FYCityModel class]
//             };
//}
//@end

@implementation ServiceItemModel

@end

@implementation ServiceItemListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ServiceItemModel class]
             };
}
@end
