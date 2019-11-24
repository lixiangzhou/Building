//
//  MyOrderVC.m
//  DimaPatient
//
//  Created by qingsong on 16/7/7.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "MyOrderVC.h"
#import "MyAllOrderListVC.h"
#import "MyToBePayOrderListVC.h"
#import "MyToBeShipOrderListVC.h"
#import "MyToBeReceivedOrderListVC.h"
#import "CustomTopBarView.h"

@interface MyOrderVC ()
<UIScrollViewDelegate>
@property (nonatomic, strong) MyAllOrderListVC *allVC;//全部订单
@property (nonatomic, strong) MyToBePayOrderListVC *toPayVC;//待支付
@property (nonatomic, strong) MyToBeShipOrderListVC *toShipVC;//待发货
@property (nonatomic, strong) MyToBeReceivedOrderListVC *toReceiveVC;//待收货
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CustomTopBarView *topBarView;


@property (assign, nonatomic) int navBarHeight;
@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavBarTitle:@"我的订单"];
    if (kDevice_Is_iPhoneX) {
        self.navBarHeight = 44 + 44;
    } else {
       self.navBarHeight = 44 + 20;
    }
        

    [self loadingSubViews];
    
    [self loadingChildViewControllers];
}

- (void)loadingSubViews {
    
    self.topBarView = [[CustomTopBarView alloc] initWithFrame:CGRectMake(0, self.navBarHeight, ScreenWidth, 40) titlesArray:@[@"全部", @"待支付", @"待发货", @"待收货"]];
    self.topBarView.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:self.topBarView];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setDelegate:self];
    _scrollView.frame = CGRectMake(0, self.navBarHeight + 40, ScreenWidth, ScreenHeight-104);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth * 4, 0)];

    __weak typeof(self) weakSelf = self;
    self.topBarView.topButtonBlock = ^(TopBarCustomButton *button){
        NSInteger tag = button.tag;
        [weakSelf.scrollView setContentOffset:CGPointMake(ScreenWidth*(tag-1), 0) animated:YES];
    };
}

- (void)loadingChildViewControllers {
    self.allVC       = [[MyAllOrderListVC alloc] init];
    self.toPayVC   = [[MyToBePayOrderListVC alloc] init];
    self.toShipVC   = [[MyToBeShipOrderListVC alloc] init];
    self.toReceiveVC   = [[MyToBeReceivedOrderListVC alloc] init];

    [self addChildViewController:self.allVC];
    [self addChildViewController:self.toPayVC];
    [self addChildViewController:self.toShipVC];
    [self addChildViewController:self.toReceiveVC];
    
    self.allVC.view.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight-64-55);
    self.toPayVC.view.frame = CGRectMake(ScreenWidth, 0,ScreenWidth,ScreenHeight-64-55);
    self.toShipVC.view.frame = CGRectMake(ScreenWidth*2, 0,ScreenWidth,ScreenHeight-64-55);
    self.toReceiveVC.view.frame = CGRectMake(ScreenWidth*3, 0,ScreenWidth,ScreenHeight-64-55);
    
    [_scrollView addSubview:self.allVC.view];
    [_scrollView addSubview:self.toPayVC.view];
    [_scrollView addSubview:self.toShipVC.view];
    [_scrollView addSubview:self.toReceiveVC.view];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.x/ScreenWidth;
    self.topBarView.progress = progress;
    //NSLog(@"progress:%lf",progress);
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
