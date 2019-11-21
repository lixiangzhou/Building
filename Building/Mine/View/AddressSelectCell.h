//
//  AddressSelectCell.h
//  Building
//
//  Created by Macbook Pro on 2019/3/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressSelectCellDefaultBlock)(id sender);
typedef void(^AddressSelectCellEditBlock)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface AddressSelectCell : UITableViewCell
@property (strong, nonatomic) AddressModel *addressModel;
@property (nonatomic, copy) AddressSelectCellDefaultBlock defaultBtnBlock;
@property (nonatomic, copy) AddressSelectCellEditBlock editBtnBlock;
@end

NS_ASSUME_NONNULL_END
