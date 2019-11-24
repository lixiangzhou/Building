//
//  ApplyRefundStateView.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "ApplyRefundStateView.h"

@interface ApplyRefundStateView ()
@property (nonatomic, weak) UIButton *btn1;
@property (nonatomic, weak) UIButton *btn2;
@end

@implementation ApplyRefundStateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        UIView *contentView = [UIView new];
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.cornerRadius = 5;
        contentView.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [UILabel title:@"请选择货物状态" txtColor:UIColorFromHEX(0x515C6F) font:UIFontWithSize(12)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = UIColorFromHEX(0xF9F9F9);
        
        UIButton *btn = [UIButton title:@"未收到货" titleColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12) target:self action:@selector(stateAction:)];
        btn.tag = 1;
        self.btn1 = btn;
        UIButton *btn2 = [UIButton title:@"已收到货" titleColor:UIColorFromHEX(0x333333) font:UIFontWithSize(12) target:self action:@selector(stateAction:)];
        btn2.tag = 2;
        self.btn2 = btn2;
        
        [self addSubview:contentView];
        [contentView addSubview:titleLabel];
        [contentView addSubview:btn];
        [contentView addSubview:btn2];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(contentView);
            make.height.equalTo(@45);
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom);
            make.left.right.equalTo(contentView);
            make.height.equalTo(@50);
        }];
        
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom);
            make.left.right.bottom.equalTo(contentView);
            make.height.equalTo(@50);
        }];
    }
    return self;
}

- (void)stateAction:(UIButton *)btn {
    self.state = btn.tag;
    [self hide];
    if (self.stateBlock) {
        self.stateBlock(btn.tag);
    }
}

- (void)setState:(NSInteger)state {
    _state = state;
    [self.btn1 setTitleColor:state == 1 ? UIColorFromHEX(0x0383FB) : UIColorFromHEX(0x333333) forState:UIControlStateNormal];
    [self.btn2 setTitleColor:state == 2 ? UIColorFromHEX(0x0383FB) : UIColorFromHEX(0x333333) forState:UIControlStateNormal];
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    self.alpha = 0;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)hide {
    self.alpha = 1;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self removeFromSuperview];
    }];
}

@end
