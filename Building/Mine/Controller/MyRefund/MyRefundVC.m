//
//  MyRefundVC.m
//  Building
//
//  Created by Mac on 2019/3/11.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyRefundVC.h"
#import "MyAllAuditListVC.h"
#import "MyAllRefundListVC.h"
#import "MyToBePayListVC.h"
#import "MyAlreadyPayListVC.h"
#import "CustomTopBarView.h"
@interface MyRefundVC ()<UIScrollViewDelegate>

@property(nonatomic,strong)MyAllRefundListVC *refundVC;//全部
@property(nonatomic,strong)MyAllAuditListVC *auditVC;//待审核
@property(nonatomic,strong)MyToBePayListVC *bePayVC;//待打款
@property(nonatomic,strong)MyAlreadyPayListVC *alreadyPayVC;//已打款
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) int navBarHeight;
@property (strong, nonatomic) CustomTopBarView *topBarView;

@end

@implementation MyRefundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setNavBarTitle:@"我的退款"];
    if (@available(iOS 11.0, *)) {
        self.navBarHeight = 44 + 44;
    } else {
        self.navBarHeight = 44 + 20;
    }
    
    [self loadingSubViews];
    
    [self loadingChildViewControllers];
}
-(void)loadingSubViews{
    self.topBarView = [[CustomTopBarView alloc] initWithFrame:CGRectMake(0, self.navBarHeight, ScreenWidth, 40) titlesArray:@[@"全部", @"待审核", @"待打款", @"已打款"]];
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

-(void)loadingChildViewControllers{
    self.refundVC       = [[MyAllRefundListVC alloc] init];
    self.auditVC   = [[MyAllAuditListVC alloc] init];
    self.bePayVC   = [[MyToBePayListVC alloc] init];
    self.alreadyPayVC   = [[MyAlreadyPayListVC alloc] init];
    
    [self addChildViewController:self.refundVC];
    [self addChildViewController:self.auditVC];
    [self addChildViewController:self.bePayVC];
    [self addChildViewController:self.alreadyPayVC];
    
    self.refundVC.view.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight-64-55);
    self.auditVC.view.frame = CGRectMake(ScreenWidth, 0,ScreenWidth,ScreenHeight-64-55);
    self.bePayVC.view.frame = CGRectMake(ScreenWidth*2, 0,ScreenWidth,ScreenHeight-64-55);
    self.alreadyPayVC.view.frame = CGRectMake(ScreenWidth*3, 0,ScreenWidth,ScreenHeight-64-55);
    
    [_scrollView addSubview:self.refundVC.view];
    [_scrollView addSubview:self.auditVC.view];
    [_scrollView addSubview:self.bePayVC.view];
    [_scrollView addSubview:self.alreadyPayVC.view];
    
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


@end
