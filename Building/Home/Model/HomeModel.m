//
//  HomeModel.m
//  Building
//
//  Created by Macbook Pro on 2019/2/2.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
@end

//登录信息
@implementation UserAndTokenModel
@end

@implementation BannerModel
@end

//企业服务
//@implementation CorpServiceModel
//@end

//楼宇服务
//@implementation BuildServiceModel
//@end

//房源服务列表
@implementation HouseServiceModel
@end

//首页服务是否显示
@implementation HomeServiceShowModel
@end

@implementation HomeServiceModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"houseServiceList"       : @"houseServiceList",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"houseServiceList" : [HouseServiceModel class],
             @"buildServiceList" : [ServiceItemModel class],
             @"corpServiceList" : [ServiceItemModel class],
             };
}
@end

@implementation FYServiceTwoLevelDetailModel
@end

//首页房源服务二级页面model
@implementation FYServiceTwoLevelModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"buildTypeName"       : @"buildTypeName",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"houseTypeList" : [FYServiceTwoLevelDetailModel class]
             };
}
@end

@implementation BuildCropServiceTwoLevelDetailModel
@end

//首页楼宇、企业服务二级页面model
@implementation BuildCropServiceTwoLevelModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"buildTypeName"       : @"buildTypeName",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"productTypeList" : [BuildCropServiceTwoLevelDetailModel class]
             };
}
@end

@implementation ServiceProductInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"mydescription"       : @"description",
             };
}
@end

@implementation ServiceProductSkuPriceModel
@end

@implementation ServiceProductSkuInfoAttrModel
@end

@implementation ServiceProductSkuInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"skuName"       : @"skuName",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"attrList" : [ServiceProductSkuInfoAttrModel class]
             };
}
@end

@implementation ServiceProductSkuModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"priceList" : [ServiceProductSkuPriceModel class],
             @"skuInfo" : [ServiceProductSkuInfoModel class]
             };
}
@end

//首页楼宇/企业服务详情页面model
@implementation ServiceDetailModel 
@end

//首页房源服务详情页面楼盘信息model
@implementation FYServiceDetailBuildInfoModel
@end

//首页房源服务详情页面房间信息model
@implementation FYServiceDetailHouseInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"descriptionIos"       : @"description",
             };
}
@end

//首页房源服务详情页面model
@implementation FYServiceDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"buildInfo"       : @"buildInfo",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buildInfo" : [FYServiceDetailBuildInfoModel class],
             @"houseInfo" : [FYServiceDetailHouseInfoModel class]
             };
}
@end

@implementation DelegateHouseModel
@end

@implementation DelegateModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"houseList" : [DelegateHouseModel class]
             };
}
@end

@implementation WeixinPayModel
@end
