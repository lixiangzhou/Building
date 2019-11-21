//
//  AuthHeaderView.h
//  Building
//
//  Created by Mac on 2019/3/10.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^AuthHeaderViewBlock)(UIButton *btn);

@interface AuthHeaderView : UIView
@property (nonatomic, copy) AuthHeaderViewBlock proBlock;
@property (nonatomic, copy) AuthHeaderViewBlock houseBlock;
@property (nonatomic, copy) AuthHeaderViewBlock agentBlock;
@end

NS_ASSUME_NONNULL_END
