//
//  WMDragViewManager.m
//  Building
//
//  Created by lixiangzhou on 2020/1/6.
//  Copyright © 2020 Macbook Pro. All rights reserved.
//

#import "WMDragViewManager.h"

@interface WMDragViewManager () <DelegateToSaleViewDelegate>
@property(nonatomic, strong, nullable) UIViewController *controller;//拖拽视图
@end

@implementation WMDragViewManager

- (void)showDragViewFrom:(UIViewController *)vc {
    self.controller = vc;
    //创建拖拽视图
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token!=nil && [[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqualToString:@"2"] && [[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]) {
        
        if (_dragView == nil) {
            [vc.view addSubview:self.dragView];
        } else {
            [vc.view bringSubviewToFront:self.dragView];
        }
    } else {
        [_dragView removeFromSuperview];
        _dragView = nil;
    }
}

//获取委托的可选数据
- (void)gainDelegateHouseData{
    [_delegateView removeFromSuperview];
    _delegateView = nil;
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainDelegateHouseDataSuccess:^(DelegateModel *response) {
        weakSelf.controller.tabBarController.tabBar.hidden = YES;
        weakSelf.delegateView.delegateModel = response;
    } failure:^(NSString *response) {
        [self.controller showHint:response];
    }];
}

- (WMDragView *)dragView {
    if (_dragView == nil) {
        _dragView = [[WMDragView alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
        [_dragView.button setBackgroundImage:[UIImage imageNamed:@"btn_weituochuzu"] forState:UIControlStateNormal];
        _dragView.layer.cornerRadius = 25;
        _dragView.isKeepBounds = YES;
        _dragView.freeRect = CGRectMake(0, 88, ScreenWidth, ScreenHeight-180);
        __weak typeof(self) weakSelf = self;
        _dragView.clickDragViewBlock = ^(WMDragView *dragView){
            [weakSelf gainDelegateHouseData];
        };
    }
    return _dragView;
}

- (DelegateToSaleView *)delegateView {
    if (_delegateView == nil) {
        _delegateView = [[DelegateToSaleView alloc] init];
        _delegateView.delegate = self;
        [self.controller.view addSubview:self.delegateView];
        _delegateView.frame = CGRectMake(0, 0, ScreenWidth, 430);
        [_delegateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.controller.view.mas_bottom);
            make.left.mas_equalTo(self.controller.view.mas_left);
            make.right.mas_equalTo(self.controller.view.mas_right);
            make.height.mas_equalTo(self.controller.view.mas_height);
        }];
    }
    return _delegateView;
}

#pragma mark - DelegateToSaleViewDelegate
- (void)doneBtnActionOfDelegateToSaleView:(NSMutableDictionary *)params{
    [self requestCreateDelegateHouseData:params];
    
    self.delegateView.hidden = YES;
    self.controller.tabBarController.tabBar.hidden = NO;
}

- (void)cancelBtnActionOfDelegateToSaleView{
    self.delegateView.hidden = YES;
    self.controller.tabBarController.tabBar.hidden = NO;
}

- (void)coverViewTapActionOfDelegateToSaleView{
    self.delegateView.hidden = YES;
    self.controller.tabBarController.tabBar.hidden = NO;
}


//增加新的委托
- (void)requestCreateDelegateHouseData:(NSMutableDictionary *)params{
    __weak __typeof__ (self) wself = self;
    [HomeNetworkService requestCreateDelegateHouseData:params Success:^(NSInteger code) {
        [wself.controller showHint:@"\n委托成功!\n请在个人中心及时关注委托状态\n"];
    } failure:^(id response) {
        [wself.controller showHint:response];
    }];
}
@end
