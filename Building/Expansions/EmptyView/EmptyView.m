//
//  EmptyView.m
//  Building
//
//  Created by Macbook Pro on 2019/4/23.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    frame = CGRectMake(0, 0, 62, 66 + 15 + 17);
    self = [super initWithFrame:frame];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62, 66)];
    imgView.image = [UIImage imageNamed:@"pic_jingqingqidai"];
    [self addSubview:imgView];
    
    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66 + 15, 62, 17)];
    txtLabel.textColor = UIColorFromHEX(333333);
    txtLabel.font = [UIFont systemFontOfSize:12];
    txtLabel.text = @"敬请期待···";
    [self addSubview:txtLabel];
    
    self.hidden = YES;
    return self;
}

@end
