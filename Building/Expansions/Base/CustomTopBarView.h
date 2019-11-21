//
//  CustomTopBarView.h
//  CustomTopBar
//
//  Created by qingsong on 16/8/31.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopBarCustomButton;

typedef void(^CustomBarBtnBlock)(TopBarCustomButton *button);

@interface CustomTopBarView : UIView

@property (nonatomic, copy) CustomBarBtnBlock topButtonBlock;

// 选中的标示
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) CGFloat progress;
    
@property (nonatomic, strong) UIFont *font;

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray;
@end

@interface TopBarCustomButton : UIButton

@property (nonatomic, strong) UILabel * titleLab;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
