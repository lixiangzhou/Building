//
//  AddressListFooterView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressListFooterViewAddBlock)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface AddressListFooterView : UIView
@property (nonatomic, copy) AddressListFooterViewAddBlock addAddressBtnBlock;

@end

NS_ASSUME_NONNULL_END
