//
//  ServiceCommonModel.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServiceCommonModel : NSObject

@end


@interface ServiceItemModel : NSObject
@property (nonatomic, copy)  NSString  * productId;//产品id
@property (nonatomic, copy)  NSString  * name;//产品名称
@property (nonatomic, copy)  NSString  * supplierName;//供应商名称
@property (nonatomic, copy)  NSString  * pic;//产品图片"http://39.106.248.109:8089/image/jpg/20190126/MjAxODExMDkxNTM4MzYxNzAuanBn.jpg"
@property (nonatomic, copy)  NSString  * price;//价格+单位"550.00"

@end

@interface ServiceItemListModel : NSObject
@property (nonatomic, assign)  NSInteger page;//当前页
@property (nonatomic, assign)  BOOL  hasNext;//是否有下一页
@property (nonatomic, copy) NSMutableArray <ServiceItemModel *> *data;//
@end
NS_ASSUME_NONNULL_END
