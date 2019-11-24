//
//  MyAfterSaleController.m
//  Building
//
//  Created by 李向洲 on 2019/11/24.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MyAfterSaleController.h"
#import "OrderProductBaseInfoView.h"
#import "ApplyRefundController.h"

@interface MyAfterSaleController ()
@property (nonatomic, strong) OrderProductBaseInfoView *productView;
@end

@implementation MyAfterSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择服务类型";
    [self setUI];
    [self setData];
}

#pragma mark - UI
- (void)setUI {
    self.view.backgroundColor = BackGroundColor;
    
    self.productView = [OrderProductBaseInfoView new];
    [self.view addSubview:self.productView];
    
    UIView *itemView1 = [self addItemViewIcon:@"ic_tuikuan_1" title:@"我要退款（无需退货）" subtitle:@"没收到货，或与卖家协商同意不同退货只退款"];
    itemView1.tag = 1;
    
    UIView *itemView2 = [self addItemViewIcon:@"ic_tuikuan_2" title:@"我要退货退款" subtitle:@"我要退货退款"];
    itemView2.tag = 2;
    
    [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@124);
    }];
    
    [itemView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@88);
    }];
    
    [itemView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemView1.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@88);
    }];
}

- (void)setData {
    self.productView.model = self.model;
}

- (UIView *)addItemViewIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [view addSubview:iconView];
    
    UILabel *titleLabel = [UILabel title:title txtColor:UIColorFromHEX(0x333333) font:UIFontWithSize(13)];
    UILabel *subTitleLabel = [UILabel title:title txtColor:UIColorFromHEX(0x999999) font:UIFontWithSize(12)];
    
    [view addSubview:titleLabel];
    [view addSubview:subTitleLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
    [view addSubview:arrowView];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(@14);
        make.width.height.equalTo(@22);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(18);
        make.top.equalTo(@25);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-25);
        make.left.equalTo(titleLabel);
    }];
    
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(@-12);
    }];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    [self.view addSubview:view];
     
    return view;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    ApplyRefundController *vc = [ApplyRefundController new];
    vc.type = tap.view.tag;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
