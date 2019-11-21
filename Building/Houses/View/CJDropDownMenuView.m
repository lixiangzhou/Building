//
//  CJDropDownMenuView.m
//  Building
//
//  Created by Macbook Pro on 2019/2/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CJDropDownMenuView.h"


//#define ItemViewTag         1
#define TitleLabelTag       2
#define ArrowImageTag       3

@interface CJDropDownMenuView()
@property (nonatomic, assign) NSInteger titleCount;
@property (nonatomic,strong)NSMutableArray <NSString *>*titleArr;
@end


@implementation CJDropDownMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray <NSString *> *)titleArr{
    if (self = [super initWithFrame:frame]) {
        _titleCount = titleArr.count;
        _titleArr = [NSMutableArray arrayWithArray:titleArr];
        _titleLabels = [NSMutableArray new];
        
        UIView *bottomLineView = [[UIView alloc]init];
        bottomLineView.backgroundColor = UIColorFromHEX(0xf5f5f5);
        [self addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@(1));
        }];
        
        NSInteger itemWidth = ScreenWidth / _titleCount;
        UIView *lastView = nil;
        for (NSInteger i = 0; i<_titleCount; i++) {
            UIView *itemView = [UIView new];
            [self addSubview:itemView];
            itemView.userInteractionEnabled = YES;
            itemView.tag = i;
            
            UIView *itemContainerView = [[UIView alloc] init];
            [itemView addSubview:itemContainerView];
            
            if (lastView == nil) {//第一个
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.left.mas_equalTo(self.mas_left);
                    make.width.mas_equalTo(itemWidth);
                }];
            } else {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.mas_top);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    make.left.mas_equalTo(lastView.mas_right);
                    make.width.mas_equalTo(itemWidth);
                }];
            }
            
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTapAction:)];
            [itemView addGestureRecognizer:gesture];
            lastView = itemView;
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = UIColorFromHEX(0x6e6e6e);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = titleArr[i];
            titleLabel.tag = TitleLabelTag;
            [self.titleLabels addObject:titleLabel];
            [itemContainerView addSubview:titleLabel];
            
            CGFloat width = [@"好好好好" sizeWithAttributes:@{NSFontAttributeName: titleLabel.font}].width + 8;
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(itemContainerView.mas_centerY);
                make.left.greaterThanOrEqualTo(@4);
                make.width.equalTo(@(width));
            }];
            //NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"list_cbb_n"], [UIImage imageNamed:@"list_cbb_h"], nil ];
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_cbb_n"] highlightedImage:[UIImage imageNamed:@"list_cbb_h"]];
            //arrowImageView.highlighted = YES;
            //UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_cbb_n"]];
            arrowImageView.tag = ArrowImageTag;
            [itemContainerView addSubview:arrowImageView];
            [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(titleLabel.mas_right).offset(4);
                make.right.lessThanOrEqualTo(@-4);
                make.centerY.mas_equalTo(itemContainerView.mas_centerY);
                make.width.mas_equalTo(@(10));
                make.height.mas_equalTo(@(6));
            }];
            
            UIView *rightLineView = [[UIView alloc]init];
            rightLineView.backgroundColor = UIColorFromHEX(0xf5f5f5);
            [itemView addSubview:rightLineView];
            
            if (i < _titleCount - 1) {            
                [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(itemView.mas_right);
                    make.bottom.mas_equalTo(itemView.mas_bottom);
                    make.top.mas_equalTo(itemView.mas_top);
                    make.width.mas_equalTo(@(1));
                }];
            }
            
            [itemContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(itemView);
                make.left.greaterThanOrEqualTo(@4);
                make.right.lessThanOrEqualTo(@-4);
            }];
            
        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    //NSLog(@"initWithFrame");
    if (self = [super initWithFrame:frame]) {
    }
    //assert(1);
    return self;
}


#pragma mark - Actions
- (void)itemViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    UIView *itemView = tapGesture.view;
//    NSLog(@"itemView:%ld", (long)itemView.tag);
    int flag = 0;
    for(UIView * view in itemView.subviews )
    {
        if( view.tag == ArrowImageTag )
        {
            UIImageView *aiv = (UIImageView *)view;
            if( aiv.highlighted == NO  )
            {
                aiv.highlighted = YES;
                flag = 1;
            }
            else
                aiv.highlighted = NO;
        }
    }
    for(UIView * view in itemView.subviews )
    {
        if( view.tag == TitleLabelTag )
        {
            UILabel *titleLabel = (UILabel *)view;
            if( flag )
            {
                titleLabel.textColor = UIColorFromHEX(0x73B8FD);
                titleLabel.highlightedTextColor = UIColorFromHEX(0x73B8FD);
            }
            else{
                titleLabel.textColor = UIColorFromHEX(0x6E6E6E);
                titleLabel.highlightedTextColor = UIColorFromHEX(0x6E6E6E);
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectMenuViewItem:)]) {
        [self.delegate didSelectMenuViewItem:itemView.tag];
        //NSLog(@"itemView:%ld +++", (long)itemView.tag);
    }
}


@end
