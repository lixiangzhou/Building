//
//  MineModel.m
//  Building
//
//  Created by Macbook Pro on 2019/2/2.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel
@end

@implementation YuYueOrderItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

@implementation YuYueOrderListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [YuYueOrderItemModel class]
             };
}
@end

@implementation YuYueServerItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

@implementation YuYueServerListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [YuYueServerItemModel class]
             };
}
@end

//我的预约--房源详情
@implementation YuYueOrderBuildDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

//我的预约--服务详情
@implementation YuYueOrderServiceDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end


@implementation AddressModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id",
             @"defaultBool":@"defalut"
             };
}
@end


//退款单列表
@implementation RefundListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [RefundItemModel class]
             };
}
@end

//退款行记录
@implementation RefundItemModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

//退款详情
@implementation RefundDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

//实名认证选择房间列表
@implementation selectedHouseModel
@end

//实名认证获取信息
@implementation AuthInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"name"       : @"name",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"selectedHouse" : [selectedHouseModel class]
             };
}
@end

@implementation roomNoListModel
@end

@implementation floorNoListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"floorNo"       : @"floorNo",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"roomNoList" : [roomNoListModel class]
             };
}
@end


@implementation unitNoListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"unitNo"       : @"unitNo",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"floorNoList" : [floorNoListModel class]
             };
}
@end


@implementation buildingNoListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"buildingNo"       : @"buildingNo",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"unitNoList" : [unitNoListModel class]
             };
}
@end

@implementation buildingListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"buildingName"       : @"buildingName",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"buildingNoList" : [buildingNoListModel class]
             };
}
@end
//订单列表
@implementation MyOrderListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MyOrderItemModel class]
             };
}

@end

//订单简介
@implementation MyOrderItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}

@end

//我的订单详情
@implementation MyOrderDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"idStr":@"id"
             };
}
@end

//委托出租列表
@implementation rentalOrderListMode
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"page"       : @"page",
             };
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [rentalOrderItemModel class]
             };
}
@end

@implementation rentalOrderItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderId":@"orderId"
             };
}
@end
//委托出租详情
@implementation rentalOrderDetailModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderId":@"orderId"
             };
}
@end
