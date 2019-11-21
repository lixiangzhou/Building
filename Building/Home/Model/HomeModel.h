//
//  HomeModel.h
//  Building
//
//  Created by Macbook Pro on 2019/2/2.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

@end

@interface UserAndTokenModel : NSObject
@property(nonatomic, copy) NSString *mobile;//手机号码，登录成功后返回
@property(nonatomic, copy) NSString *token;//登录成功token，登录成功后返回
@property(nonatomic, copy) NSString *memberType;//用户类型，登录成功后返回，1：游客，2：业主，3：住户，4：经纪人
@property(nonatomic, copy) NSString *memberId;//用户id，登录成功后返回
@property(nonatomic, copy) NSString *authStatus;//认证状态    string    0：未认证，1：审核中，9：已认证，-1：未通过

@end

@interface BannerModel : NSObject
@property (nonatomic, copy)  NSString  * title;
@property (nonatomic, copy)  NSString  * image;//广告图URL
@end

//企业服务
//@interface CorpServiceModel : NSObject
//@property (nonatomic, copy)  NSString  * productId;//3,产品id    number    进产品详情，带参过去
//@property (nonatomic, copy)  NSString  * supplierName;//供应商名称,"绿地集团",
//@property (nonatomic, copy)  NSString  * pic;// 图片，绝对路径,"http://39.106.248.109:8089/image/jpg/20190126/MjAxODExMDkxNTM4MzYxNzAuanBn.jpg"
//@property (nonatomic, copy)  NSString  * price;//价格 + 单位,"3501.00元/月"
//@property (nonatomic, copy)  NSString  * name;//"梅之华美家",名称
//@end

//楼宇服务
//@interface BuildServiceModel : NSObject
//@property (nonatomic, copy)  NSString  * productId;//3,产品id    number    进产品详情，带参过去
//@property (nonatomic, copy)  NSString  * supplierName;//供应商名称,"绿地集团",
//@property (nonatomic, copy)  NSString  * pic;// 图片，绝对路径,"http://39.106.248.109:8089/image/jpg/20190126/MjAxODExMDkxNTM4MzYxNzAuanBn.jpg"
//@property (nonatomic, copy)  NSString  * price;//价格 + 单位,"3501.00元/月"
//@property (nonatomic, copy)  NSString  * name;//"梅之华美家",名称
//@end

//房源服务列表
@interface HouseServiceModel : NSObject
@property (nonatomic, copy)  NSString  * houseId;//3,房源id    number    进房间详情，带参过去
@property (nonatomic, copy)  NSString  * acreage;//"58.0"面积
@property (nonatomic, copy)  NSString  * pic;// 图片，绝对路径,"http://39.106.248.109:8089/image/jpg/20190126/MjAxODExMDkxNTM4MzYxNzAuanBn.jpg"
@property (nonatomic, copy)  NSString  * price;//价格 + 单位,"3501.00元/月"
@property (nonatomic, copy)  NSString  * name;//"梅之华美家",名称
@end

//首页服务是否显示
@interface HomeServiceShowModel : NSObject
@property (nonatomic, assign)  BOOL  showHouse;//房源
@property (nonatomic, assign)  BOOL  showBuild;//楼宇
@property (nonatomic, assign)  BOOL  showCorp;// 企业
@end

@class ServiceItemModel;
@interface HomeServiceModel : NSObject
@property (nonatomic, copy) NSMutableArray <HouseServiceModel *> *houseServiceList;//房源
@property (nonatomic, copy) NSMutableArray <ServiceItemModel *> *buildServiceList;//楼宇
@property (nonatomic, copy) NSMutableArray <ServiceItemModel *> *corpServiceList;//企业
@property (nonatomic, strong) HomeServiceShowModel *serviceAuth;

@end


@interface FYServiceTwoLevelDetailModel : NSObject
@property (nonatomic, copy)  NSString  * houseTypeId;//房间类型id
@property (nonatomic, copy)  NSString  * houseTypeName;//
@property (nonatomic, copy)  NSString  * pic;//
@end

//首页房源服务二级页面model
@interface FYServiceTwoLevelModel : NSObject
@property (nonatomic, copy)  NSString  * buildTypeName;
@property (nonatomic, copy) NSMutableArray <FYServiceTwoLevelDetailModel *> *houseTypeList;//
@property (nonatomic, assign)  BOOL isSelect;//非后台返回，前端使用
@end

@interface BuildCropServiceTwoLevelDetailModel : NSObject
@property (nonatomic, copy)  NSString  * productTypeId;//产品类型id
@property (nonatomic, copy)  NSString  * productTypeName;//
@property (nonatomic, copy)  NSString  * pic;//
@end

//首页楼宇、企业服务二级页面model
@interface BuildCropServiceTwoLevelModel : NSObject
@property (nonatomic, copy)  NSString  * buildTypeName;
@property (nonatomic, copy) NSMutableArray <BuildCropServiceTwoLevelDetailModel *> *productTypeList;//
@property (nonatomic, assign)  BOOL isSelect;//非后台返回，前端使用
@end


@interface ServiceProductInfoModel : NSObject
@property (nonatomic, copy)  NSString  * mydescription;//产品描述
@property (nonatomic, copy) NSMutableArray <NSString *> *detailImg;//详情页图片
@property (nonatomic, copy)  NSString  * label;//标签
@property (nonatomic, copy)  NSString  * name;//产品名称
@property (nonatomic, copy)  NSString  * price;//价格
@property (nonatomic, assign)  NSInteger productId;//产品id
@property (nonatomic, assign)  NSInteger saleWay;//售卖方式1购买2预约
@property (nonatomic, copy)  NSString  * supplierName;//供应商名称
@end

@interface ServiceProductSkuPriceModel : NSObject
@property (nonatomic, assign)  NSInteger attrIds;//属性id
@property (nonatomic, copy)  NSString  * price;//该属性的价格
@property (nonatomic, assign)  NSInteger productSaleId;//预约，购买带过来
@end

@interface ServiceProductSkuInfoAttrModel : NSObject
@property (nonatomic, assign)  NSInteger attrId;//属性id    number    匹配价格
@property (nonatomic, copy)  NSString  * attrName;//属性名称
@property (nonatomic, assign)  BOOL isSelect;//非后台返回，前端使用
@end

@interface ServiceProductSkuInfoModel : NSObject
@property (nonatomic, copy) NSMutableArray <ServiceProductSkuInfoAttrModel *> *attrList;//
@property (nonatomic, copy)  NSString  *skuName;//规格名称
@end

@interface ServiceProductSkuModel : NSObject
@property (nonatomic, copy) NSMutableArray <ServiceProductSkuPriceModel *> *priceList;//价格集合
@property (nonatomic, copy) NSMutableArray <ServiceProductSkuInfoModel *> *skuInfo;//shu属性
@property (nonatomic, copy)  NSString  *payCount;//购买数量，前端使用
@end

//首页楼宇/企业服务详情页面model
@interface ServiceDetailModel : NSObject
@property (nonatomic, strong) ServiceProductInfoModel *productInfo;//
@property (nonatomic, strong) ServiceProductSkuModel *productSku;//用于显示预约面板
@end

//首页房源服务详情页面楼盘信息model
@interface FYServiceDetailBuildInfoModel : NSObject
@property (nonatomic, copy)  NSString  * address;//楼盘地址
@property (nonatomic, copy)  NSString  * area;//面积
@property (nonatomic, copy)  NSString  * busInfo;//公交
@property (nonatomic, copy)  NSString  * endTime;//竣工时间
@property (nonatomic, copy)  NSString  * introduction;//楼盘介绍string    富文本
@property (nonatomic, copy)  NSString  * latitude;//维度    number
@property (nonatomic, copy)  NSString  * longitude;//经度    number
@property (nonatomic, copy)  NSString  * metroInfo;//地铁    string
@property (nonatomic, copy)  NSString  * name;//楼盘名称
@property (nonatomic, copy)  NSString  * wyFee;//物业费    string
@property (nonatomic, copy)  NSString  * wyPhone;//物业电话    string
@end

//首页房源服务详情页面房间信息model
@interface FYServiceDetailHouseInfoModel : NSObject
@property (nonatomic, copy)  NSString  * acreage;//面积    string
@property (nonatomic, copy)  NSString  * agencyRemark;//中介操作说明    string
@property (nonatomic, copy)  NSString  * commission;//佣金    string
@property (nonatomic, copy)  NSString  * decoration;//装修情况    string
@property (nonatomic, copy)  NSString  * descriptionIos;//房源介绍
@property (nonatomic, copy)  NSString  * floor;//楼层    string
@property (nonatomic, copy)  NSString  * houseId;//房间id    number
@property (nonatomic, copy)  NSString  * label;//标签    string    多个空格隔开
@property (nonatomic, copy)  NSString  * name;//房间名称    string
@property (nonatomic, copy)  NSArray  * picList;//轮播图片列表    array<string>
@property (nonatomic, copy)  NSString  * price;//价格    string
@end

//首页房源服务详情页面model
@interface FYServiceDetailModel : NSObject
@property (nonatomic, strong) FYServiceDetailBuildInfoModel *buildInfo;//楼盘信息
@property (nonatomic, strong) FYServiceDetailHouseInfoModel *houseInfo;//房间信息
@end


@interface DelegateHouseModel : NSObject
@property (nonatomic, copy)  NSString  *buildingId;//
@property (nonatomic, copy)  NSString  *buildingName;//
@property (nonatomic, copy)  NSString  *houseId;//
@property (nonatomic, copy)  NSString  *houseName;//
@property (nonatomic, assign)  BOOL isSelect;//非后台返回，前端使用
@end

@interface DelegateModel : NSObject
@property (nonatomic, copy) NSMutableArray <DelegateHouseModel *> *houseList;//可选房间列表
@property (nonatomic, copy) NSMutableArray <NSString *> *unitList;//s价格单位列表
@end

@interface WeixinPayModel : NSObject
@property (nonatomic, copy)  NSString  *appid;//
@property (nonatomic, copy)  NSString  *partnerid;//
@property (nonatomic, copy)  NSString  *prepayid;//
@property (nonatomic, copy)  NSString  *packageValue;//
@property (nonatomic, copy)  NSString  *noncestr;//
@property (nonatomic, copy)  NSString  *timestamp;//
@property (nonatomic, copy)  NSString  *sign;//
@end






NS_ASSUME_NONNULL_END
