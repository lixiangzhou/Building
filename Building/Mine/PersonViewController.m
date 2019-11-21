//
//  PersonViewController.m
//  YouYi
//
//  Created by Macbook Pro on 2019/1/29.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonVCCell.h"
#import "PersonVCLoginOutCell.h"
#import "PersonVCHeaderView.h"
#import "WRCustomNavigationBar.h"
#import "WRNavigationBar.h"
#import "YuYueOrderVC.h"
#import "MyOrderVC.h"
#import "AddressListVC.h"
#import "AuthenticationController.h"
#import "MyRefundVC.h"
#import "AboutMeVC.h"
#import "rentalOrderVc.h"

#define PersonVCTableHeaderHeight       220
#define PersonVCCellHeight       49
#define PersonVCCellXibName                @"PersonVCCell"

#define PersonVCLoginOutCellHeight       101
#define PersonVCLoginOutCellXibName                @"PersonVCLoginOutCell"

#define LogOutStringKey           @"退出登录"

@interface PersonViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewArr;

@property (nonatomic, strong) PersonVCHeaderView *personHeaderView;
@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;//自定义nav bar
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义导航条
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    self.customNavBar.title = @"我的";
    self.customNavBar.titleLabelFont = [UIFont systemFontOfSize:18];
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];
    
    //设置tableview视图
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self myTableHeaderView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.tableView.mj_footer.hidden = YES;
                
        [self reloadSelfVc];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    [self.tableView.mj_header beginRefreshing];

    //数据初始化
    self.tableViewArr = @[@"实名认证", @"我的预约", @"我的订单", @"我的退款", @"收货地址", @"关于我们"].mutableCopy;
    self.isLogin = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self reloadSelfVc];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT(PersonVCTableHeaderHeight))
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT(PersonVCTableHeaderHeight)) / NAV_HEIGHT;
//        [self.customNavBar wr_setBackgroundAlpha:alpha];
//        [self.customNavBar wr_setTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
//        [self.customNavBar wr_setBackgroundAlpha:0];
//        [self.customNavBar wr_setTintColor:UIColorFromHEX(0x707070)];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *rowTitle = self.tableViewArr[indexPath.row];
    if ([rowTitle  isEqual: LogOutStringKey]) {//退出cell
        PersonVCLoginOutCell *cell = (PersonVCLoginOutCell *)[self getCellFromXibName:PersonVCLoginOutCellXibName dequeueTableView:tableView];
        cell.logOutBlock = ^(UIButton *btn) {
            [GlobalConfigClass shareMySingle].userAndTokenModel = nil;
            [self reloadSelfVc];
        };
        return cell;
    } else {
        PersonVCCell *cell = (PersonVCCell *)[self getCellFromXibName:PersonVCCellXibName dequeueTableView:tableView];
        cell.titleLabel.text = self.tableViewArr[indexPath.row];
        if ([rowTitle  isEqual: @"实名认证"]) {//实名认证
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_01"];
            if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
                self.isLogin = NO;
            } else {
                self.isLogin = YES;
            }
            //[GlobalConfigClass shareMySingle].LoginStatus = self.isLogin;
            //NSLog(@"LoginStatus:%@", [GlobalConfigClass shareMySingle].LoginStatus);
            // 0：未认证，1：审核中，9：已认证，-1：未通过
            if (self.isLogin == YES) {//已登录
                NSString *authStatusStr = @"";
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"0"]) {
                    authStatusStr = @"未认证";
                } else if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"1"]) {
                    authStatusStr = @"审核中";
                } else if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]) {
                    authStatusStr = @"已认证";
                } else if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"5"]) {
                    authStatusStr = @"审核中";
                } else if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"-1"]) {
                    authStatusStr = @"未通过";
                }
                else{
                    authStatusStr = @"待认证";
                }
                cell.titleLabel.text = [NSString stringWithFormat:@"%@（%@）", self.tableViewArr[indexPath.row], authStatusStr];
                //NSLog(@"authStatus:%@,%@", [GlobalConfigClass shareMySingle].userAndTokenModel.authStatus,cell.titleLabel.text);
            }
        } else if ([rowTitle  isEqual: @"我的预约"]){//我的预约
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_02"];
        } else if ([rowTitle  isEqual: @"我的订单"]){//我的订单
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_03"];
        } else if ([rowTitle  isEqual: @"我的退款"]){//我的退款
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_04"];
        } else if ([rowTitle  isEqual: @"委托出租单"]){//委托出租单
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_07"];
        } else if ([rowTitle  isEqual: @"收货地址"]){//收货地址
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_05"];
        } else if ([rowTitle  isEqual: @"关于我们"]){//关于我们
            cell.myImageView.image = [UIImage imageNamed:@"my_list_ic_06"];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewArr[indexPath.row]  isEqual: LogOutStringKey]) {//退出cell
        return PersonVCLoginOutCellHeight;
    } else {
        return PersonVCCellHeight;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *rowTitle = self.tableViewArr[indexPath.row];
    if ([rowTitle  isEqual: @"实名认证"]) {//实名认证
        if (self.isLogin == YES) {//已登录
            AuthenticationController *ac = [[AuthenticationController alloc]init];
            [ac setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ac animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"我的预约"]){//我的预约
        if (self.isLogin == YES) {//已登录
            YuYueOrderVC * loginVC = [[YuYueOrderVC alloc] init];
            [loginVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"我的订单"]){//我的订单
        if (self.isLogin == YES) {//已登录
            MyOrderVC * loginVC = [[MyOrderVC alloc] init];
            [loginVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"我的退款"]){//我的退款
        if (self.isLogin == YES) {//已登录
            MyRefundVC *ac=[[MyRefundVC alloc]init];
            [ac setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ac animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"委托出租单"]){//委托出租单
        if (self.isLogin == YES) {//已登录
            rentalOrderVc *ro=[[rentalOrderVc alloc]init];
            [ro setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ro animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"收货地址"]){//收货地址
        if (self.isLogin == YES) {//已登录
            AddressListVC * loginVC = [[AddressListVC alloc] init];
            [loginVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            [self goToLogin];
        }
    } else if ([rowTitle  isEqual: @"关于我们"]){//关于我们
        AboutMeVC *ac=[[AboutMeVC alloc] init];
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }
}

#pragma mark - Actions
- (void)personViewTapAction:(UITapGestureRecognizer *)tapGesture
{
//    UIView *itemView = tapGesture.view;
//    NSLog(@"%ld", (long)itemView.tag);
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil)
        [self goToLogin];
}

#pragma mark - getters and setters
- (UIView *)myTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, PersonVCTableHeaderHeight)];
    
    PersonVCHeaderView *personView = [[PersonVCHeaderView alloc] init];
    [headerView addSubview:personView];
    personView.frame = CGRectMake(0, 0, ScreenWidth, PersonVCTableHeaderHeight);
    personView.statusLabel.text = @"登录/注册";
    self.personHeaderView = personView;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personViewTapAction:)];
    [personView addGestureRecognizer:gesture];
    
    return headerView;
}

- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

#pragma mark - Privates
- (void)goToLogin {
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [loginVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)reloadSelfVc{
    void (^getDataArr)() = ^ {
        self.tableViewArr = @[@"实名认证", @"我的预约", @"我的订单", @"我的退款", @"收货地址", @"关于我们"].mutableCopy;
        if (self.isLogin == YES) {//已登录
            self.personHeaderView.statusLabel.text = @"（普通游客）";
            self.personHeaderView.phoneLabel.text = [GlobalConfigClass shareMySingle].userAndTokenModel.mobile;
            if ([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"1"]) {
                self.personHeaderView.statusLabel.text = @"（普通游客）";
            } else if([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"2"]){
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]){
                    self.personHeaderView.statusLabel.text = @"（业主）";
                    if (![self.tableViewArr containsObject:@"委托出租单" ]) {
                        [self.tableViewArr insertObject:@"委托出租单" atIndex:4];
                    }
                }
                //[self.tableViewArr insertObject:@"委托出租单" atIndex:4];
            }else if([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"3"]){
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"])
                    self.personHeaderView.statusLabel.text = @"（住户）";
            }else if([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"4"]){
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"])
                    self.personHeaderView.statusLabel.text = @"（经纪人）";
            }else if([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"5"]){
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"])
                    self.personHeaderView.statusLabel.text = @"（代理人）";
                if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]) {
                    if (![self.tableViewArr containsObject:@"委托出租单" ]) {
                        [self.tableViewArr insertObject:@"委托出租单" atIndex:4];
                    }
                } else if ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"5"]) {
                    self.personHeaderView.statusLabel.text = @"（普通游客）";
                }
            }else{
                self.personHeaderView.statusLabel.text = @"（普通游客）";
            }
            if( ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"0"]) || ([[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"-1"]) ){
                self.personHeaderView.statusLabel.text = @"（普通游客）";
            }
            
            if (![self.tableViewArr containsObject:LogOutStringKey]) {
                [self.tableViewArr addObject:LogOutStringKey];
            }
            
            [self.tableView reloadData];
        } else {
            self.personHeaderView.phoneLabel.text = @"登录/注册";
            self.personHeaderView.statusLabel.text = @"";
            if ([self.tableViewArr containsObject:LogOutStringKey]) {
                [self.tableViewArr removeObject:LogOutStringKey];
            }
            
            [self.tableView reloadData];
        }
    };
    
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.isLogin = NO;
        getDataArr();
    } else {
        self.isLogin = YES;
        [MineNetworkService gainAuthinfoWithSuccess:^(AuthInfoModel *response) {
            [GlobalConfigClass shareMySingle].userAndTokenModel.memberType = response.memberType;
            [GlobalConfigClass shareMySingle].userAndTokenModel.authStatus = response.authStatus;
            getDataArr();
        } failure:^(id  _Nonnull response) {
        }];
    }
    
    
}



@end
