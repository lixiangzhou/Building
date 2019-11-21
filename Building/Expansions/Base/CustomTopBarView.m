//
//  CustomTopBarView.m
//  CustomTopBar
//
//  Created by qingsong on 16/8/31.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "CustomTopBarView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CustomTopBarView ()

@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) TopBarCustomButton * selectedBtn;
@property (nonatomic, strong) NSMutableArray * btns;
@end

@implementation CustomTopBarView

- (instancetype)initWithFrame:(CGRect)frame titlesArray:(NSArray *)titlesArray {

    if (self = [super init]) {
        self.btns = [NSMutableArray new];
        [self createCustomBarViewWithFrame:frame titles:titlesArray];
        
    }
    return self;
}

- (void)createCustomBarViewWithFrame:(CGRect)rect titles:(NSArray *)titles {

    self.backgroundColor = UIColorFromHEX(0xffffff);
    
    self.titleArray = [NSMutableArray arrayWithArray:titles];
    
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    if (!CGRectEqualToRect(rect, CGRectZero)) {
        self.frame = rect;
    } else {
        rect = self.frame;
    }
    
    if (titles.count == 0) {
        return;
    }
    
    NSInteger count = [titles count];
    
    CGFloat W = (rect.size.width-count+1)/count;
    CGFloat H = rect.size.height;
    
    for (NSInteger i = 0; i < count; i++) {
        CGFloat offX = i == 0 ? 0 : 1;// CGFloat offX = i == 0 ? 0 : 1;
        //标题button
        TopBarCustomButton * button = [[TopBarCustomButton alloc] initWithFrame:CGRectMake(i*W+offX, 0, W, H) title:titles[i]];
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.btns addObject:button];
        //设置垂直分割线
//        if (i > 0) {
//
//            UILabel *verticalLabel = [[UILabel alloc] init];
//            verticalLabel.frame = CGRectMake(W*i, 5, 1, H-10);
//            verticalLabel.backgroundColor = UIColorFromHEX(0xDDDDDD);
//            [self addSubview:verticalLabel];
//        }
    }
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, H-.5,ScreenWidth, .5)];//(0, H-.5,ScreenWidth, .5)
    bottomLine.backgroundColor = UIColorFromHEX(0xDDDDDD);
    [self addSubview:bottomLine];
    
    self.selectedIndex = 0;

    self.progressImageView = [[UIImageView alloc] init];
    CGFloat W1, H1=4.0;
    if( W > ScreenWidth * 44.0/375 )
        W1 = ScreenWidth * 44.0/375;
    [self.progressImageView setFrame:CGRectMake(0, H-H1, W1, H1)];//(0, H-1.5f, W, 1.5)
    [self.progressImageView setBackgroundColor:UIColorFromHEX(0x9accff)];
    self.progressImageView.centerX = self.selectedBtn.centerX;
    [self addSubview:self.progressImageView];
    
}

-(void)setSelectedBtn:(TopBarCustomButton *)selectedBtn
{
    if (_selectedBtn != selectedBtn)
    {
        _selectedBtn.titleLab.textColor = UIColorFromHEX(0x333333);
        _selectedBtn = (TopBarCustomButton *)selectedBtn;
        _selectedBtn.titleLab.textColor = UIColorFromHEX(0x9accff);

    }
}
// Button点击事件
- (void)buttonClick:(TopBarCustomButton *)sender {

    self.selectedIndex = sender.tag - 1;

    if (self.topButtonBlock)
    {
        self.topButtonBlock(sender);
    }
//    self.progressImageView.centerX = sender.centerX;
}

// 设置索引
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
    }
    self.selectedBtn = (TopBarCustomButton *)[self viewWithTag:self.selectedIndex+1];
}

- (void)setProgress:(CGFloat)progress {
    
    if (_progress != progress) {
        
        _progress = progress;
        
        NSInteger count = self.titleArray.count;
        CGFloat half_W = (ScreenWidth-count+1)/count/2;
        self.progressImageView.centerX = _progress * (ScreenWidth - ScreenWidth/count)/(count - 1) + half_W;
        self.selectedIndex = roundf(_progress);
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self.btns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = font;
    }];
}

@end

@implementation TopBarCustomButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.height-10)];
        self.titleLab.text = title;
        [self.titleLab setTextColor:UIColorFromHEX(0x333333)];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.titleLab];
    }
    return self;
}

@end
