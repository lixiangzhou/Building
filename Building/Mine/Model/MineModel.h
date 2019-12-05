//
//  MineModel.h
//  Building
//
//  Created by Macbook Pro on 2019/2/2.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineModel : NSObject

@end

@interface YuYueOrderItemModel : NSObject
@property (nonatomic, copy)  NSString  * acreage;//面积
@property (nonatomic, copy)  NSString  * amount;//租金 + 价格单位
@property (nonatomic, copy)  NSString  * buildingAddress;//楼盘地址
@property (nonatomic, copy)  NSString  * commission;//佣金 + 价格单位
@property (nonatomic, copy)  NSString  * floor;//楼层
@property (nonatomic, copy)  NSString  * houseListImg;//列表de图片
@property (nonatomic, copy)  NSString  * houseName;//房源名称
@property (nonatomic, copy)  NSString  * idStr;//订单ID
@property (nonatomic, copy)  NSString  * orderSn;//订单编号
@property (nonatomic, copy)  NSString  * orderStatus;//订单状态    number    0：待受理，1：已受理，2：已取消
@property (nonatomic, copy)  NSString  * subscribeTime;//预约时间
@end
@interface YuYueOrderListModel : NSObject
@property (nonatomic, assign)  NSInteger page;//当前页
@property (nonatomic, assign)  BOOL  hasNext;//是否有下一页
@property (nonatomic, copy) NSMutableArray <YuYueOrderItemModel *> *data;//
@end

//服务类列表
@interface YuYueServerItemModel : NSObject
@property (nonatomic, copy)  NSString  * amount;//租金 + 价格单位
@property (nonatomic, copy)  NSString  * amountUnit;
@property (nonatomic, copy)  NSString  * idStr;//订单ID
@property (nonatomic, copy)  NSString  * orderSn;//订单编号
@property (nonatomic, copy)  NSString  * orderStatus;//订单状态    number    0：待受理，1：已受理，2：已取消
@property (nonatomic, copy)  NSString  * productDetailImg;//列表de图片
@property (nonatomic, copy)  NSString  * productName;//产品名称
@property (nonatomic, copy)  NSString  * productSku;//产品规格
@property (nonatomic, copy)  NSString  * subscribeTime;//预约时间
@property (nonatomic, copy)  NSString  * supplierName;//供应商
@end

@interface YuYueServerListModel : NSObject
@property (nonatomic, assign)  NSInteger page;//当前页
@property (nonatomic, assign)  BOOL  hasNext;//是否有下一页
@property (nonatomic, copy) NSMutableArray <YuYueServerItemModel *> *data;//
@end


//我的预约--房源详情
@interface YuYueOrderBuildDetailModel : NSObject
@property (nonatomic, copy)  NSString  * amount;//租金 + 价格单位
@property (nonatomic, copy)  NSString  * buildingAddress;//楼盘地址
@property (nonatomic, copy)  NSString  * cancelTime;//取消时间
@property (nonatomic, copy)  NSString  * commission;//佣金 + 价格单位
@property (nonatomic, copy)  NSString  * contact;//联系人
@property (nonatomic, copy)  NSString  * contactNumber;//联系电话
@property (nonatomic, copy)  NSString  * createTime;//下单时间
@property (nonatomic, copy)  NSString  * houseListImg;//房源图片
@property (nonatomic, copy)  NSString  * houseName;//房源名称
@property (nonatomic, copy)  NSString  * idStr;//订单ID
@property (nonatomic, copy)  NSString  * message;//留言信息
@property (nonatomic, copy)  NSString  * orderSn;//订单编号
@property (nonatomic, copy)  NSString  * orderStatus;//订单状态    number    0：待受理，1：已受理，2：已取消
@property (nonatomic, copy)  NSString  * processTime;//受理时间
@property (nonatomic, copy)  NSString  * subscribeTime;//预约时间
@property (nonatomic, copy)  NSString  * acreage;//面积
@property (nonatomic, copy)  NSString  * floor;//楼层
@end

//我的预约--服务详情
@interface YuYueOrderServiceDetailModel : NSObject
@property (nonatomic, copy)  NSString  * amount;//价格
@property (nonatomic, copy)  NSString  * amountUnit;//价格单位
@property (nonatomic, copy)  NSString  * cancelTime;//取消时间
@property (nonatomic, copy)  NSString  * contact;//联系人
@property (nonatomic, copy)  NSString  * contactNumber;//联系电话
@property (nonatomic, copy)  NSString  * createTime;//下单时间
@property (nonatomic, copy)  NSString  * id;//订单ID
@property (nonatomic, copy)  NSString  * message;//留言信息
@property (nonatomic, copy)  NSString  * orderSn;//订单编号
@property (nonatomic, copy)  NSString  * orderStatus;//订单状态    number    0：待受理，1：已受理，2：已取消
@property (nonatomic, copy)  NSString  * processTime;//受理时间
@property (nonatomic, copy)  NSString  * productDetailImg;//产品图片
@property (nonatomic, copy)  NSString  * productName;//产品名称
@property (nonatomic, copy)  NSString  * productSku;//产品规格
@property (nonatomic, copy)  NSString  * subscribeTime;
@property (nonatomic, copy)  NSString  * supplierName;//供应商
@end

@interface AddressModel : NSObject
@property (nonatomic, copy)  NSString  * address;//详细地址
@property (nonatomic, copy)  NSString  * cityId;//城市ID
@property (nonatomic, copy)  NSString  * cityName;//城市名称
@property (nonatomic, copy)  NSString  * contact;//联系方式
@property (nonatomic, copy)  NSString  * countyId;//区县ID
@property (nonatomic, copy)  NSString  * countyName;//区名称
@property (nonatomic, assign)  BOOL   defaultBool;//是否默认地址
@property (nonatomic, copy)  NSString  * idStr;//地址ID
@property (nonatomic, copy)  NSString  * provinceId;//省份ID
@property (nonatomic, copy)  NSString  * provinceName;//身份名称
@property (nonatomic, copy)  NSString  * receiver;//收货人
@end


//退款详情
@interface RefundDetailModel : NSObject
@property(nonatomic,copy)NSString *address;//收货地址
@property(nonatomic,copy)NSString *amount;//总价
@property(nonatomic,copy)NSString *auditMsg;//审核不通过原因
@property(nonatomic,copy)NSString *auditResult;//审核结果
@property(nonatomic,copy)NSString *auditTime;//审核（通过或拒绝）时间
@property(nonatomic,copy)NSString *contact;//联系电话
@property(nonatomic,copy)NSString *createTime;//下单时间
@property(nonatomic,copy)NSString *idStr;//退款单id
@property(nonatomic,copy)NSString *message;//留言信息
@property(nonatomic,copy)NSString *orderId;//订单id
@property(nonatomic,copy)NSString *orderSn;//订单编号
@property(nonatomic,copy)NSString *payTime;//支付时间
@property(nonatomic,copy)NSString *price;//单价
@property(nonatomic,copy)NSString *priceUnit;//价格单位
@property(nonatomic,copy)NSString *productDetailImg;//产品图片
@property(nonatomic,copy)NSString *productName;//产品名称
@property(nonatomic,copy)NSString *productSku;//产品规格
@property(nonatomic,copy)NSString *quantity;//购买数量
@property(nonatomic,copy)NSString *receiver;//收货人
@property(nonatomic,copy)NSString *refundApplyTime;//申请退款时间
@property(nonatomic,copy)NSString *refundPayTime;//退款时间
@property(nonatomic,copy)NSString *refundStatus;//退款状态
@property(nonatomic,copy)NSString *supplierName;//供应商
@property(nonatomic,copy)NSString *refundAmount;//退款金额
@property(nonatomic,assign) NSInteger refundType;//退款类型，1：售中退款；2：售后退款；3：售后退货退款
@property(nonatomic,copy)NSString *goodsStatus;//售后退款 货物状态，1：未收到货；2：已收到货
@property(nonatomic,copy)NSString *refundReason;//退款原因
@property(nonatomic,copy)NSString *refundRemark;//退款说明
@property(nonatomic,strong)NSArray *refundProof;//退款凭证
@property(nonatomic,copy)NSString *auditSellerInfo;//退货退款 退货信息,卖家收货地址
@property(nonatomic,copy)NSString *auditSellerMsg;//卖家留言退货退款 卖家留言

@property(nonatomic,copy)NSString *returnLogisticsCompany;//退货物流
@property(nonatomic,copy)NSString *returnLogisticsDocument;//退货物流
@property(nonatomic,strong)NSArray *returnLogisticsProof;//退款凭证


@end

//退款行记录
@interface RefundItemModel : NSObject
@property(nonatomic,copy)NSString *amount;//总价
@property(nonatomic,copy)NSString *idStr;//退款单id
@property(nonatomic,copy)NSString *orderId;//订单id
@property(nonatomic,copy)NSString *orderSn;//订单编号
@property(nonatomic,copy)NSString *price;//单价
@property(nonatomic,copy)NSString *priceUnit;//价格单位
@property(nonatomic,copy)NSString *productDetailImg;//产品图片
@property(nonatomic,copy)NSString *productName;//产品名称
@property(nonatomic,copy)NSString *productSku;//产品规格
@property(nonatomic,copy)NSString *quantity;//购买数量
@property(nonatomic,copy)NSString *refundStatus;//退款状态
@property(nonatomic,copy)NSString *supplierName;//供应商
@property(nonatomic,assign) NSInteger refundType;//退款类型，1：售中退款；2：售后退款；3：售后退货退款
@property(nonatomic,copy)NSString *refundAmount;//退款金额
@end

//退款单列表
@interface RefundListModel : NSObject
@property (nonatomic, assign)  NSInteger page;//当前页
@property (nonatomic, assign)  BOOL  hasNext;//是否有下一页
@property (nonatomic, copy) NSMutableArray <RefundItemModel *> *data;//
@end

//实名认证选择房间列表
@interface selectedHouseModel : NSObject
@property(nonatomic,copy)NSString *houseId;//房源id
@property(nonatomic,copy)NSString *title;//房源名称
@end

//实名认证获取信息
@interface AuthInfoModel : NSObject
@property(nonatomic,assign)BOOL agentCompany;//是否有经济公司
@property(nonatomic,copy)NSString *authRemark;//认证不通过原因
@property(nonatomic,copy)NSString *authStatus;//认证状态
@property(nonatomic,copy)NSString *companyName;//公司名称
@property(nonatomic,copy)NSString *companyPost;//公司职位
@property(nonatomic,copy)NSString *memberType;//身份类型
@property(nonatomic,copy)NSString *mobile;//手机号码
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSMutableArray <selectedHouseModel *> *selectedHouse;
@property(nonatomic,copy)NSString *serviceArea;//经纪人管辖区域
@property(nonatomic,copy)NSString *serviceAreaName;//区域名称
@end

//实名认证-查询可选房源列表
@interface roomNoListModel : NSObject
@property(nonatomic,copy)NSString *houseId;
@property(nonatomic,copy)NSString *roomName;
@property(nonatomic,copy)NSString *roomNo;
@end

//实名认证-查询可选房源列表
@interface floorNoListModel : NSObject
@property(nonatomic,copy)NSString *floorNo;
@property(nonatomic,copy)NSMutableArray <roomNoListModel *>*roomNoList;
@end

//实名认证-查询可选房源列表
@interface unitNoListModel : NSObject
@property(nonatomic,copy)NSString *unitNo;
@property(nonatomic,copy)NSMutableArray <floorNoListModel *>*floorNoList;
@end

//实名认证-查询可选房源列表
@interface buildingNoListModel : NSObject
@property(nonatomic,copy)NSString *buildingNo;
@property(nonatomic,copy)NSMutableArray <unitNoListModel *>*unitNoList;
@end

//实名认证-查询可选房源列表
@interface buildingListModel : NSObject
@property(nonatomic,copy)NSString *buildingId;
@property(nonatomic,copy)NSString *buildingName;
@property(nonatomic,copy)NSMutableArray <buildingNoListModel *>*buildingNoList;
@end

//订单简介
@interface MyOrderItemModel : NSObject
@property(nonatomic,copy)NSString *amount;//总价
@property(nonatomic,copy)NSString *idStr;//订单id
@property(nonatomic,copy)NSString *orderSn;//订单编号
@property(nonatomic,copy)NSString *orderStatus;//订单状态 0:待支付 1：待发货 2：待收货 3：已收货 4:已取消
@property(nonatomic,copy)NSString *price;//单价
@property(nonatomic,copy)NSString *priceUnit;//价格单位
@property(nonatomic,copy)NSString *productDetailImg;//产品图片
@property(nonatomic,copy)NSString *productName;//产品名称
@property(nonatomic,copy)NSString *productSku;//产品规格
@property(nonatomic,copy)NSString *quantity;//产品数量
@property(nonatomic,copy)NSString *supplierName;//供应商

@end
//我的订单列表
@interface MyOrderListModel : NSObject
@property(nonatomic,assign)NSInteger page;//当前页
@property(nonatomic,assign)BOOL hasNext;//是否有下一页
@property(nonatomic,copy) NSMutableArray <MyOrderItemModel *> *data;
@end
//我的订单详情
@interface MyOrderDetailModel : NSObject
@property(nonatomic,copy)NSString *address;//收货地址
@property(nonatomic,copy)NSString *amount;//总价
@property(nonatomic,copy)NSString *cancelTime;//取消时间
@property(nonatomic,copy)NSString *contact;//联系电话
@property(nonatomic,copy)NSString *createTime;//下单时间
@property(nonatomic,copy)NSString *deliveryTime;//发货时间
@property(nonatomic,copy)NSString *idStr;//订单id
@property(nonatomic,copy)NSString *message;//留言
@property(nonatomic,copy)NSString *orderSn;//订单编号
@property(nonatomic,copy)NSString *orderStatus;//订单状态 0:待支付 1：待发货 2：待收货 3：已收货 4:已取消
@property(nonatomic,copy)NSString *payTime;//支付时间
@property(nonatomic,copy)NSString *price;//单价
@property(nonatomic,copy)NSString *priceUnit;//价格单位
@property(nonatomic,copy)NSString *productDetailImg;//产品图片
@property(nonatomic,copy)NSString *productName;//产品名称
@property(nonatomic,copy)NSString *productSku;//产品规格
@property(nonatomic,copy)NSString *quantity;//数量
@property(nonatomic,copy)NSString *receiveTime;//收货时间
@property(nonatomic,copy)NSString *receiver;//收货人
@property(nonatomic,copy)NSString *supplierName;//供应商
@end

//委托出租列表
@interface rentalOrderItemModel : NSObject
@property(nonatomic,copy)NSString *amount;//出租价格
@property(nonatomic,copy)NSString *amountUnit;//出租价格单位
@property(nonatomic,copy)NSString *buildingName;//楼盘名称
@property(nonatomic,copy)NSString *commission;//佣金价格
@property(nonatomic,copy)NSString *commissionUnit;//佣金价格单位
@property(nonatomic,copy)NSString *houseName;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,copy)NSString *orderStatus;
@end

@interface rentalOrderListMode : NSObject
@property(nonatomic,assign)NSInteger page;//当前页
@property(nonatomic,assign)BOOL hasNext;//是否有下一页
@property(nonatomic,copy) NSMutableArray <rentalOrderItemModel *> *data;
@end

//委托出租详情
@interface rentalOrderDetailModel : NSObject
@property(nonatomic,copy)NSString *acceptTime;//收货地址
@property(nonatomic,copy)NSString *amount;//总价
@property(nonatomic,copy)NSString *amountUnit;//出租价格单位
@property(nonatomic,copy)NSString *buildingName;//楼盘名称
@property(nonatomic,copy)NSString *cancelTime;
@property(nonatomic,copy)NSString *commission;//佣金价格
@property(nonatomic,copy)NSString *commissionUnit;//佣金价格单位
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *houseName;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *orderSn;
@property(nonatomic,copy)NSString *orderStatus;
@end

NS_ASSUME_NONNULL_END
