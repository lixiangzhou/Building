//
//  CJDropDownMenuView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CJDropDownMenuViewDelegate <NSObject>

- (void)didSelectMenuViewItem:(NSInteger)index;

@optional

@end

@interface CJDropDownMenuView : UIView
@property (nonatomic, strong)NSMutableArray <UILabel *>*titleLabels;
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray <NSString *> *)titleArr;
@property (nonatomic, weak) id<CJDropDownMenuViewDelegate>   delegate;
@end

NS_ASSUME_NONNULL_END
