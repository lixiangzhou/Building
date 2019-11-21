//
//  AddressListVC.h
//  Building
//
//  Created by Macbook Pro on 2019/3/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressListVCSelectBlock)(AddressModel *addressModel);

NS_ASSUME_NONNULL_BEGIN

@interface AddressListVC : BaseViewController
@property (nonatomic, copy) AddressListVCSelectBlock selectAddressBlock;//通过该界面选择地址时调用
@end

NS_ASSUME_NONNULL_END
