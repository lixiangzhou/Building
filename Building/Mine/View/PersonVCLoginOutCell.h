//
//  PersonVCLoginOutCell.h
//  Building
//
//  Created by Macbook Pro on 2019/2/26.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PersonVCLogOutCellBlock)(UIButton *btn);
NS_ASSUME_NONNULL_BEGIN

@interface PersonVCLoginOutCell : UITableViewCell
@property (nonatomic, copy) PersonVCLogOutCellBlock logOutBlock;
@end

NS_ASSUME_NONNULL_END
