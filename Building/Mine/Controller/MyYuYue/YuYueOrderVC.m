//
//  YuYueOrderVC.m
//  DimaPatient
//
//  Created by qingsong on 16/7/7.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "YuYueOrderVC.h"
#import "YuYueServiceOrderVC.h"
#import "YuYueBuildOrderVC.h"
#import "CustomTopBarView.h"

@interface YuYueOrderVC ()
<UIScrollViewDelegate>
@property (nonatomic, strong) YuYueServiceOrderVC *serviceVC;
@property (nonatomic, strong) YuYueBuildOrderVC *buildVC;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CustomTopBarView *topBarView;


@property (assign, nonatomic) int navBarHeight;
@end

@implementation YuYueOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavBarTitle:@"我的预约"];
    if (@available(iOS 11.0, *)) {
        self.navBarHeight = 44 + 44;
    } else {
       self.navBarHeight = 44 + 20;
    }

    [self loadingSubViews];
    
    [self loadingChildViewControllers];
}

- (void)loadingSubViews {
    
    self.topBarView = [[CustomTopBarView alloc] initWithFrame:CGRectMake(0, self.navBarHeight, ScreenWidth, 40) titlesArray:@[@"房源",@"服务"]];
    self.topBarView.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:self.topBarView];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setDelegate:self];
    _scrollView.frame = CGRectMake(0, self.navBarHeight + 40, ScreenWidth, ScreenHeight-104);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth * 2, 0)];

    __weak typeof(self) weakSelf = self;
    self.topBarView.topButtonBlock = ^(TopBarCustomButton *button){
        NSInteger tag = button.tag;
        [weakSelf.scrollView setContentOffset:CGPointMake(ScreenWidth*(tag-1), 0) animated:YES];
    };
}

- (void)loadingChildViewControllers {
    self.buildVC       = [[YuYueBuildOrderVC alloc] init];
    self.serviceVC   = [[YuYueServiceOrderVC alloc] init];
    
    [self addChildViewController:self.buildVC];
    [self addChildViewController:self.serviceVC];
    
    self.buildVC.view.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight-64-55);
    self.serviceVC.view.frame = CGRectMake(ScreenWidth, 0,ScreenWidth,ScreenHeight-64-55);
    
    [_scrollView addSubview:self.buildVC.view];
    [_scrollView addSubview:self.serviceVC.view];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.x/ScreenWidth;
    self.topBarView.progress = progress;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
