//
//  FYCommonModel.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FYCommonModel : NSObject

@end

//商圈数据--商圈
@interface FYShangQuanTradingModel : NSObject
@property (nonatomic, copy)  NSString  * tradingId;//商圈id
@property (nonatomic, copy)  NSString  * tradingName;//商圈名称

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//商圈数据--区
@interface FYShangQuanCountryModel : NSObject
@property (nonatomic, copy)  NSString  * countryId;//
@property (nonatomic, copy)  NSString  * countryName;//
@property (nonatomic, copy) NSMutableArray <FYShangQuanTradingModel *> *tradingInfoList;//

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//商圈数据--地铁
@interface FYShangQuanMetroModel : NSObject
@property (nonatomic, copy)  NSString  * metroName;//
@property (nonatomic, copy) NSMutableArray <FYShangQuanTradingModel *> *tradingInfoList;//

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//楼盘
@interface FYBuildListModel : NSObject
@property (nonatomic, copy)  NSString  * id;//
@property (nonatomic, copy)  NSString  * name;//
@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end


//商圈数据--城市
@interface FYShangQuanCityModel : NSObject
@property (nonatomic, copy)  NSString  * cityId;//城市id
@property (nonatomic, copy)  NSString  * cityName;//城市名称
@property (nonatomic, copy)  NSString  * metro;//地铁线路,多个逗号分隔
@property (nonatomic, copy) NSMutableArray <FYShangQuanCountryModel *> *countryInfoList;//区
@property (nonatomic, copy) NSMutableArray <FYBuildListModel *> *buildList;//楼盘

//@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@property (nonatomic, copy) NSMutableArray <FYShangQuanMetroModel *> *metroList;//地铁,前端转化的数据，非后台返回
@end

//d商圈区域选择固定一级列表的model
@interface FYShangQuanOneLevelModel : NSObject
@property (nonatomic, copy)  NSString  * titleName;//
@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//县级
@interface FYCountryModel : NSObject
@property (nonatomic, copy)  NSString  * countryId;//
@property (nonatomic, copy)  NSString  * countryName;//"东城区"
@property (nonatomic, copy)  NSString  * pinyin;//"DONGCHENGQU"

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//市级
@interface FYCityModel : NSObject
@property (nonatomic, copy)  NSString  * cityId;//北京1，南京102
@property (nonatomic, copy)  NSString  * cityName;//"北京"
@property (nonatomic, copy)  NSString  * pinyin;//"BEIJING"
@property (nonatomic, copy) NSMutableArray <FYCountryModel *> *countryInfoList;//

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

//省级
@interface FYProvinceModel : NSObject
@property (nonatomic, copy)  NSString  * provinceId;//
@property (nonatomic, copy)  NSString  * provinceName;//
@property (nonatomic, copy)  NSString  * pinyin;//
@property (nonatomic, copy) NSMutableArray <FYCityModel *> *cityList;//

@property (nonatomic, assign)  BOOL  isSelect;//cell选择时使用，非后台返回
@end

@interface FYItemModel : NSObject
@property (nonatomic, copy)  NSString  * houseId;//房间id
@property (nonatomic, copy)  NSString  * name;//房间名称"三口之家",
@property (nonatomic, copy)  NSString  * acreage;//面积"88.0",
@property (nonatomic, copy)  NSString  * address;//地址"英才北三街",
@property (nonatomic, copy)  NSString  * floor;//楼层"5"
@property (nonatomic, copy)  NSString  * label;//标签,多个空格分隔,如"都市核心商圈 丰台科技园 精心设计 交通便捷"
@property (nonatomic, copy)  NSString  * pic;//房间图片"http://39.106.248.109:8089/image/jpg/20190126/MjAxODExMDkxNTM4MzYxNzAuanBn.jpg"
@property (nonatomic, copy)  NSString  * price;//价格+单位"550.00"
@end

@interface FYItemListModel : NSObject
@property (nonatomic, assign)  NSInteger page;//当前页
@property (nonatomic, assign)  BOOL  hasNext;//是否有下一页
@property (nonatomic, copy) NSMutableArray <FYItemModel *> *data;//
@end

NS_ASSUME_NONNULL_END
