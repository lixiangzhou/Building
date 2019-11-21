//
//  AddAddressVC.h
//  Building
//
//  Created by Macbook Pro on 2019/3/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAddressVC : UIViewController
@property (strong, nonatomic) AddressModel *addressModel;//有则代表是修改地址
@property (nonatomic, assign)  NSInteger editMode;
@end

NS_ASSUME_NONNULL_END
