//
//  SelectLocationCityVC.h
//  Building
//
//  Created by Macbook Pro on 2019/3/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectLocationCityBlock)(FYCityModel *cityModel);

NS_ASSUME_NONNULL_BEGIN

@interface SelectLocationCityVC : BaseViewController
@property (strong, nonatomic) NSMutableDictionary *cityDic;//城市分组
@property(nonatomic,copy) DidSelectLocationCityBlock selectCityBlock;
@end

NS_ASSUME_NONNULL_END


