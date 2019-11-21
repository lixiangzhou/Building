//
//  proprietorConcelll.h
//  Building
//
//  Created by Mac on 2019/4/15.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^pcCellBlock)( UIView *views );
@interface proprietorConcelll : UITableViewCell
@property(nonatomic,strong) selectedHouseModel *sh;
@property (nonatomic, assign) BOOL isimage;
@property (nonatomic, assign) NSInteger number;
@property(nonatomic,copy)pcCellBlock delectBlock;



@end

NS_ASSUME_NONNULL_END
