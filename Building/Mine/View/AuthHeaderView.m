//
//  AuthHeaderView.m
//  Building
//
//  Created by Mac on 2019/3/10.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "AuthHeaderView.h"

@implementation AuthHeaderView
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([AuthHeaderView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
}

- (IBAction)proprietorBtn:(id)sender {
    if (self.proBlock) {
        self.proBlock(sender);
    }
}
- (IBAction)houseBtn:(id)sender {
    if (self.houseBlock) {
        self.houseBlock(sender);
    }
}

- (IBAction)agentBtn:(id)sender {
    if (self.agentBlock) {
        self.agentBlock(sender);
    }
}

@end
