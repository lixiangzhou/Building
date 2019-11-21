//
//  rentalOrderVc.m
//  Building
//
//  Created by Mac on 2019/3/25.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "rentalOrderVc.h"

@interface rentalOrderVc ()<UIScrollViewDelegate>

@property (nonatomic, strong) rentalOrderList *allRo;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) int navBarHeight;
@end

@implementation rentalOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self.view setBackgroundColor:[UIColor redColor]];
    [self setNavBarTitle:@"委托出租单"];
    if (@available(iOS 11.0, *)) {
        self.navBarHeight = 44 + 44;
    } else {
        self.navBarHeight = 44 + 20;
    }
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setDelegate:self];
    _scrollView.frame = CGRectMake(0, self.navBarHeight, ScreenWidth, ScreenHeight);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, 0)];
    
    self.allRo   = [[rentalOrderList alloc] init];
    [self addChildViewController:self.allRo];
    self.allRo.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //NSLog(@"ScreenWidth:%ld", ScreenWidth);
    //self.allRo.view.width = ScreenWidth;
    //[self.view addSubview:self.allRo.view];
    [_scrollView addSubview:self.allRo.view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CGFloat progress = scrollView.contentOffset.x/ScreenWidth;
    //self.topBarView.progress = progress;
    //NSLog(@"progress:%lf",progress);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}@end
