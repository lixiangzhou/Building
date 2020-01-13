//
//  ServiceViewController.m
//  YouYi
//
//  Created by Macbook Pro on 2019/1/29.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "ServiceViewController.h"
#import "SDCycleScrollView.h"
#import "CJDropDownMenuView.h"
#import "HomeChoiceCell.h"
#import "CJMenuSelectTwoConView.h"
#import "CJMenuSelectOneConView.h"
#import "FYServiceHouseDetailVC.h"
#import "BuildServiceHouseDetailVC.h"
#import "WRCustomNavigationBar.h"
#import "WRNavigationBar.h"
#import "EmptyView.h"
#import "WMDragViewManager.h"

#define FangYuanCellSectionHeight       47
#define HomeServiceCellHeight       120
#define HomeChoiceCellXibName       @"HomeChoiceCell"

@interface ServiceViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, CJDropDownMenuViewDelegate, CJMenuSelectTwoConViewDelegate, CJMenuSelectOneConViewDelegate>
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *bannerModelArr;
@property (nonatomic, assign) float cycleScrollViewheight;

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CJDropDownMenuView *sectionView;
@property (strong, nonatomic) NSMutableArray <ServiceItemModel *> *serviceList;
@property (weak, nonatomic) EmptyView *emptyView;
    
//房源列表的参数信息
@property (nonatomic, copy)  NSString  * serviceType;//楼宇服务：buildService;企业服务：corpService
@property (nonatomic, copy)  NSString  * sort;//排序字段,price_desc:价格从高到底; price_asc:价格从低到高；
@property (nonatomic, assign)  NSInteger rentRange;//租金范围1：1500以下；2：1500-2500；3：2500-3500；4：3500-4500；5：4500以上
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  * metro;//地铁线路
@property (nonatomic, copy)  NSString  * keyWord;//搜索关键词
@property (nonatomic, assign)  NSInteger productTypeId;//产品类型id ，从首页-》服务二级页面进来时必填
@property (nonatomic, copy)  NSString  *countyId;//区id,支持多选，多个逗号分隔
@property (nonatomic, assign)  NSInteger cityId;//城市id,首页定位的，===必填===
@property (nonatomic, assign)  NSInteger tradingId;//商圈id,支持多选，多个逗号分隔
@property (nonatomic, copy)  NSString  *token;//header传参,登录了传，没有不传，不影响数据的获取
@property (nonatomic, assign)  NSInteger buildId;

@property (strong, nonatomic) CJMenuSelectOneConView *loupanView;//楼盘
@property (assign, nonatomic) BOOL loupanViewIsShow;
@property (strong, nonatomic) NSArray <FYBuildListModel *> *loupanList;
@property (nonatomic, strong) NSMutableArray *lpArr;
@property (nonatomic, strong) NSArray *loupanArr;

@property (strong, nonatomic) NSMutableArray <FYShangQuanCityModel *> *sqModel;

@property (strong, nonatomic) CJMenuSelectOneConView *serviceTypeView;//服务分类
@property (assign, nonatomic) BOOL serviceTypeViewIsShow;

@property (strong, nonatomic) CJMenuSelectTwoConView *quyuView;
@property (assign, nonatomic) BOOL quyuViewIsShow;
@property (strong, nonatomic) NSArray <FYProvinceModel *> *cityList;

@property (strong, nonatomic) CJMenuSelectOneConView *orderView;//排序
@property (assign, nonatomic) BOOL orderViewIsShow;
@property (nonatomic, strong) UIView *tabbarCoverView;
@property (nonatomic, strong) NSArray *sortArray;
@property (nonatomic, strong) NSArray *serverArray;
@property (nonatomic, strong) FYCityModel *noLimitCityModel;
@property (nonatomic, strong) WMDragViewManager *dragViewManager;
@end

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //数据初始化
    self.bannerModelArr = [[NSMutableArray alloc] init];
    self.serviceList = [[NSMutableArray alloc] init];
    self.cityList = [[NSMutableArray alloc] init];
    self.lpArr = [[NSMutableArray alloc] init];
    self.loupanArr = [[NSArray alloc] init];
    self.loupanList = [[NSMutableArray alloc] init];
    self.sortArray = @[@"默认", @"发布 新-旧", @"价格 低->高", @"价格 高->低"];
    self.serverArray = @[@"全部", @"楼宇服务", @"楼通万商"];
    self.quyuViewIsShow = NO;
    self.orderViewIsShow = NO;
    self.serviceTypeViewIsShow = NO;
    self.cycleScrollViewheight = ScreenWidth * 56 / 75;
    
    //房源列表的参数信息,-1和nil在请求数据时不用组装成参数
    self.serviceType = nil;
    self.sort = nil;
    self.rentRange = -1;
    self.pageSize = 20;
    self.page = 1;
    self.metro = nil;
    self.keyWord = nil;
    self.productTypeId = -1;
    self.countyId = nil;
    self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
    self.tradingId = -1;
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    self.view.backgroundColor = BackGroundColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    //UIView *headView = [self myTableHeaderView];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    self.tableView.tableHeaderView = [self myTableHeaderView];
    
    
    
    self.customNavBar.titleLabelColor = UIColorFromHEX(0x6e6e6e);//[UIColor whiteColor];
    //self.customNavBar.title = @"服务";
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];

    CJDropDownMenuView *menuView = [[CJDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47) titleArr:@[@"楼盘", @"服务分类", @"区域", @"默认"]];
    menuView.delegate = self;
    self.sectionView = menuView;
    self.sectionView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:self.sectionView belowSubview:self.customNavBar];

    EmptyView *emptyView = [EmptyView new];
    self.emptyView = emptyView;
    [self.tableView addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.cycleScrollViewheight + 47 + 65));
        make.centerX.equalTo(self.tableView);
        make.width.equalTo(@(self.emptyView.width));
        make.height.equalTo(@(self.emptyView.height));
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        [self gainServiceListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainServiceListWithRefresh:NO];
    }];
    
    if ([[GlobalConfigClass shareMySingle].serviceType isEqualToString:@"buildService"]) {
        self.sectionView.titleLabels[1].text = self.serverArray[1];
    } else if ([[GlobalConfigClass shareMySingle].serviceType isEqualToString:@"corpService"]) {
        self.sectionView.titleLabels[1].text = self.serverArray[2];
    }
    
    //请求数据
    [self gainBannerData];
    [self gainCityList];
//    [self gainCityShangQuanALL];
    [self getLouPanList];
    self.dragViewManager = [WMDragViewManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
    
    if ([[GlobalConfigClass shareMySingle].serviceType isEqualToString:@"buildService"]) {
        self.sectionView.titleLabels[1].text = self.serverArray[1];
    } else if ([[GlobalConfigClass shareMySingle].serviceType isEqualToString:@"corpService"]) {
        self.sectionView.titleLabels[1].text = self.serverArray[2];
    }
    
    [self gainBannerData];
    [self gainCityList];
    [self getLouPanList];
    [self gainCityShangQuanALL];
    [self.dragViewManager showDragViewFrom:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //NSLog(@"viewWillAppear animated");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//城市、商圈基础数据查询
- (void)gainCityShangQuanALL{
    if (self.sqModel.count) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityShangQuanListSuccess:^(NSArray * _Nonnull citys) {
        weakSelf.sqModel = citys;
    } failure:^(id  _Nonnull response) {
    }];
}

#pragma mark - requests
    
- (void)getLouPanList {
    NSDictionary *param = @{};
    if (self.cityId) {
        param = @{@"cityId": @(self.cityId)};
    } else if ([GlobalConfigClass shareMySingle].cityModel.cityId) {
        param = @{@"cityId": [GlobalConfigClass shareMySingle].cityModel.cityId};
    }
    [FangYuanNetworkService getLouPanList:param Success:^(NSArray<FYBuildListModel *> * _Nonnull loupanList) {
        NSMutableArray *array = [@[@"全部"] mutableCopy];
//        [array addObjectsFromArray:[loupanList valueForKeyPath:@"name"]];
        // 是否包含当前选择的楼盘
        BOOL alreadContainCurrent = NO;
        NSString *name = self.sectionView.titleLabels[0].text;
        for (FYBuildListModel *model in loupanList) {
            [array addObject:model.name];
            if (!alreadContainCurrent &&
                self.buildId == model.id.intValue && [name isEqualToString:model.name]) {
                alreadContainCurrent = YES;
            }
        }
        
        self.loupanArr = array;
        
        if (([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"2"] ||
            [[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"3"] ||
            [[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"5"]) &&
            [[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]) {
            if (self.loupanArr.count > 1 && !alreadContainCurrent) {
                self.loupanView.selectIdx = 1;
                self.sectionView.titleLabels[0].text = self.loupanArr[1];
                self.buildId = loupanList[0].id.integerValue;
            }
        }
        
        if (!alreadContainCurrent) {    // 如果包含选择的楼盘，就不去刷新了
            [self gainServiceListWithRefresh:YES];
        }
    } failure:^(id  _Nonnull response) {
        [self gainServiceListWithRefresh:YES];
    }];
}
    
//获取服务列表
- (void)gainServiceListWithRefresh:(BOOL)isRefresh
{
    //NSLog(@"gainServiceListWithRefresh isRefresh");
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (self.rentRange != -1) {
        [params setObject:@(self.rentRange) forKey:@"rentRange"];
    }
    if (self.pageSize != -1) {
        [params setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    if (self.page != -1) {
        [params setObject:@(self.page) forKey:@"page"];
    }
    if (self.productTypeId != -1) {
        [params setObject:@(self.productTypeId) forKey:@"productTypeId"];
    }
    if (self.countyId != nil) {
        [params setObject:self.countyId forKey:@"countyId"];
    }
    if (self.cityId != -1) {
        [params setObject:@(self.cityId) forKey:@"cityId"];
    }
    if (self.tradingId != -1) {
        [params setObject:@(self.tradingId) forKey:@"tradingId"];
    }
    if (self.buildId != -1) {
        [params setObject:@(self.buildId) forKey:@"buildId"];
    }
    if (self.keyWord != nil) {
        [params setObject:self.keyWord forKey:@"keyWord"];
    }
    if (self.metro != nil) {
        [params setObject:self.metro forKey:@"metro"];
    }
    if (self.sort != nil) {
        [params setObject:self.sort forKey:@"sort"];
    }
    if( [GlobalConfigClass shareMySingle].serviceType != nil )
    {
        self.serviceType = [GlobalConfigClass shareMySingle].serviceType;
        [GlobalConfigClass shareMySingle].serviceType = nil;
        //NSLog(@"serviceType:%@", self.serviceType );
        [params setObject:self.serviceType forKey:@"serviceType"];
    }else if (self.serviceType != nil ) {
//        if( [GlobalConfigClass shareMySingle].serviceType != nil )
//        {
//            self.serviceType = [GlobalConfigClass shareMySingle].serviceType;
//            [GlobalConfigClass shareMySingle].serviceType = nil;
//        }
        //NSLog(@"serviceType in:%@", self.serviceType );
        [params setObject:self.serviceType forKey:@"serviceType"];
    }
    else
    {
        //NSLog(@"serviceType out:%@", self.serviceType );
    }

    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [FangYuanNetworkService gainServiceListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        ServiceItemListModel *serviceListModel = response;
        if (isRefresh) {
            [self.serviceList removeAllObjects];
        }
        
        if (!serviceListModel.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        [wself.serviceList addObjectsFromArray:serviceListModel.data];
        [wself.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.emptyView.hidden = self.serviceList.count != 0;
    } failure:^(id  _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//获取城市列表
- (void)gainCityList{
    if (self.cityList.count) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityListSuccess:^(NSArray * _Nonnull citys) {
        weakSelf.cityList = citys;
    } failure:^(id  _Nonnull response) {
        
    }];
}

- (void)gainBannerData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService getBannerInfoWithType:@"POST_SERVICE" Success:^(NSArray *banners) {
        //        NSLog(@"%@", banners);
        [weakSelf.bannerModelArr removeAllObjects];
        for (BannerModel * banner in banners) {
            if([banner.image hasPrefix:@"http"]) {
                [weakSelf.bannerModelArr addObject:banner];
            }
        }
        
        NSMutableArray * bannersTemp = [NSMutableArray arrayWithCapacity:6];
        for (BannerModel *banner in weakSelf.bannerModelArr) {
            [bannersTemp addObject:banner.image];
        }
        
        weakSelf.cycleScrollView.imageURLStringsGroup = bannersTemp;
    } failure:^(id response) {
        [self showHint:response];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > self.cycleScrollViewheight - 130)
    {
        CGFloat alpha = (offsetY - self.cycleScrollViewheight + 130) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        self.customNavBar.title = @"服务";
        [self.customNavBar wr_setTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
        //self.sectionView.frame=CGRectMake(0, offsetY, ScreenWidth, self.cycleScrollViewheight);

    }
    else
    {
        self.customNavBar.title = @"";
        [self.customNavBar wr_setBackgroundAlpha:0];
        [self.customNavBar wr_setTintColor:UIColorFromHEX(0x707070)];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    
    if( offsetY > self.customNavBar.height )
    {
        scrollView.contentInset = UIEdgeInsetsMake(self.customNavBar.height, 0, 0, 0);
        self.sectionView.backgroundColor = [UIColor whiteColor];

    }
    else
    {
        self.sectionView.backgroundColor = [UIColor whiteColor];
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    }
//    CGFloat sectionHeaderHeight = 47;
//    NSLog(@"contentOffset:%lf,%lf", scrollView.contentOffset.x,scrollView.contentOffset.y);
// if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
//
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//
//    }
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float y = rect.origin.y + rect.size.height;
    CGRect frame = CGRectMake(0, y, ScreenWidth, self.view.frame.size.height - y);
    self.orderView.frame = frame;
    self.quyuView.frame = frame;
    self.loupanView.frame = frame;
    self.serviceTypeView.frame = frame;
}
#pragma mark - getters and setters
- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //ygz test
//    CJDropDownMenuView *menuView = [[CJDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47) titleArr:@[@"楼盘", @"服务分类", @"区域", @"默认"]];
//    menuView.delegate = self;
//    self.sectionView = menuView;
//    return menuView;
    
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FangYuanCellSectionHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.serviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeChoiceCell *cell = (HomeChoiceCell *)[self getCellFromXibName:HomeChoiceCellXibName dequeueTableView:tableView];
    ServiceItemModel *model = self.serviceList[indexPath.row];
    cell.serviceModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HomeServiceCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    
    ServiceItemModel *model = self.serviceList[row];
    BuildServiceHouseDetailVC *hoseDetailVC = [[BuildServiceHouseDetailVC alloc] init];
    hoseDetailVC.productId = [model.productId integerValue];
    
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
}

#pragma mark - CJDropDownMenuViewDelegate
- (void)didSelectMenuViewItem:(NSInteger)index{
    if(index == 0){
        [self hiddenServiceTypeView];
        [self hiddenQuYuView];
        [self hiddenOrderView];
        
        if (self.loupanViewIsShow) {//目前正在显示
            [self hiddenLoupanView];
        } else {
            [self showLoupanView];
        }
    }
    else if (index == 1) {//服务分类
        [self hiddenLoupanView];
        [self hiddenQuYuView];
        [self hiddenOrderView];
        
        if (self.serviceTypeViewIsShow) {//目前正在显示
            [self hiddenServiceTypeView];
        } else {
            [self showServiceTypeView];
        }
        
    } else if (index == 2) {//区域
        [self hiddenLoupanView];
        [self hiddenServiceTypeView];
        [self hiddenOrderView];
        
        if (self.quyuViewIsShow) {//目前正在显示
            [self hiddenQuYuView];
        } else {
            [self showQuYuView];
        }
        
    } else {//默认
        [self hiddenLoupanView];
        [self hiddenServiceTypeView];
        [self hiddenQuYuView];
        
        if (self.orderViewIsShow) {//目前正在显示
            [self hiddenOrderView];
        } else {
            [self showOrderView];
        }
    }
}

#pragma mark - CJMenuSelectTwoConViewDelegate
- (NSArray *)leftTableViewDatas{
    
    for( FYProvinceModel *pmodel in self.cityList )
    {
        for( FYCityModel *cmode in pmodel.cityList )
        {
            NSString  * cityId = [GlobalConfigClass shareMySingle].cityModel.cityId;
            if( [cmode.cityId isEqualToString:cityId] )
            {
                self.noLimitCityModel = [FYCityModel new];
                self.noLimitCityModel.cityName = @"不限";
                self.noLimitCityModel.countryInfoList = cmode.countryInfoList;
//                NSMutableArray *array = [NSMutableArray new];
//                [pmodel.cityList enumerateObjectsUsingBlock:^(FYCityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [array addObjectsFromArray:obj.countryInfoList];
//                }];
//
//                self.noLimitCityModel.countryInfoList = array;
                
                return @[self.noLimitCityModel, cmode];
                
            }
        }
    }
    
    FYProvinceModel *model = self.cityList[0];
    //NSLog(@"model.cityList[0]:%@", model.cityList[0].cityName );
    return @[model.cityList[0]];//===写死的北京，应该是首页定位的城市或者选择的城市
}

- (void)resetButtonAction:(id)data{
    self.countyId = nil;
    [self hiddenQuYuView];
    [self.tableView.mj_header beginRefreshing];
}

- (void)doneButtonActionSelectCity:(FYCityModel *)city selectCountryArr:(NSArray *)countryArr{
    if (city != nil) {
        if (city.cityId.length) {
            self.cityId = [city.cityId intValue];
        } else {    // 选择了不限，没有选择子区域
            self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
        }
        if (countryArr.count > 0) {
            self.sectionView.titleLabels[2].text = [countryArr.firstObject countryName];
            self.countyId = [[countryArr valueForKeyPath:@"countryId"] componentsJoinedByString:@","];
        } else {
            self.sectionView.titleLabels[2].text = @"区域";
            self.countyId = nil;
        }
        
        [self.tableView.mj_header beginRefreshing];
    }
    
    [self hiddenQuYuView];
}

- (void)coverViewTapAction{
    [self hiddenQuYuView];
}

#pragma mark - CJMenuSelectOneConViewDelegate
//row从0开始，分别为@[@"默认", @"价格 低->高", @"价格 高->低"]
- (void)selectOneConViewSelectRow:(NSInteger)row selfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//排序
        //price_desc:价格从高到底; price_asc:价格从低到高；
        if( row == 1 ){
            self.sort = @"update_desc";
        }
        else if (row == 2) {
            self.sort = @"price_asc";
        } else if(row == 3){
            self.sort = @"price_desc";
        } else {
            self.sort = nil;
        }
        self.sectionView.titleLabels[3].text = self.sortArray[row];
        [self.tableView.mj_header beginRefreshing];
        
        [self hiddenOrderView];
    }
    else if (oneConView == self.loupanView){//楼盘
        //add
        if( row > 0 )
        {
            NSString *cityId = [GlobalConfigClass shareMySingle].cityModel.cityId;
            for (FYShangQuanCityModel *cityModel in self.sqModel) {
                if ([cityId isEqualToString:cityModel.cityId])
                {
                    for (FYBuildListModel *loupanStr in cityModel.buildList)
                    {
                        if( [loupanStr.name isEqualToString:self.loupanArr[row]] )
                        {
                            self.buildId = [loupanStr.id intValue];
                            self.sectionView.titleLabels[0].text = loupanStr.name;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        else {
            self.sectionView.titleLabels[0].text = @"全部";
            self.buildId = -1;
        }
        NSLog(@"self.buildId:%ld", self.buildId);
        
        [self.tableView.mj_header beginRefreshing];
        
        [self hiddenLoupanView];
    }
    else {//服务分类
        //楼宇服务：buildService;企业服务：corpService
        if (row == 1) {
            self.serviceType = @"buildService";
        } else if(row == 2){
            self.serviceType = @"corpService";
        } else {
            self.serviceType = nil;
        }
        self.sectionView.titleLabels[1].text = self.serverArray[row];
        [self.tableView.mj_header beginRefreshing];
        
        [self hiddenServiceTypeView];
    }
}

- (void)selectOneConViewCoverViewTapActionSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//排序
        [self hiddenOrderView];
    }  else if (oneConView == self.loupanView){//楼盘
        [self hiddenLoupanView];
    }else {//服务分类
        [self hiddenServiceTypeView];
    }
}

- (NSArray *)selectOneConViewTableViewDatasSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//排序
        return self.sortArray;
    }  else if (oneConView == self.loupanView){//楼盘
        return self.loupanArr;
    }else {//服务分类
        return self.serverArray;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; {
//    if (self.bannerModelArr.count > index) {
        //        BannerModel *bannerModel = self.bannerModelArr[index];
        //
        //        //统计banner点击率
        //        [HomeNetworkService StatisticBannerClickRateWithBannerid:bannerModel.idStr Success:^(id response) {
        //        } failure:^(id response) {
        //        }];
        //
        //        //跳转对应的链接页
        //        self.webBrowser.navigationItem.title = bannerModel.title;
        //        self.webBrowser.KINWebType = CustomKINWebBrowserTypeHomeBanner;
        //        [self.navigationController pushViewController:self.webBrowser animated:YES];
        //        [self.webBrowser loadURLString:bannerModel.linkUrl];
//    }
}

#pragma mark - getters
- (UIView *)myTableHeaderView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.cycleScrollViewheight)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, self.cycleScrollViewheight) delegate:self placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    cycleScrollView.pageDotColor = [UIColor whiteColor];
    cycleScrollView.currentPageDotColor = BAR_TINTCOLOR;
    [headerView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    return headerView;
}

#pragma - getters and setters
- (CJMenuSelectOneConView *)loupanView{
    if (_loupanView == nil) {
        _loupanView = [[CJMenuSelectOneConView alloc] init];
        _loupanView.delegate = self;
        _loupanView.hidden = YES;
        [self.view addSubview:_loupanView];
        float orderY = self.cycleScrollViewheight + FangYuanCellSectionHeight + 44;
        self.orderView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
    }
    return _loupanView;
}

- (CJMenuSelectTwoConView *)quyuView{
    if (_quyuView == nil) {
        _quyuView = [[CJMenuSelectTwoConView alloc] init];
        _quyuView.delegate = self;
        _quyuView.hidden = YES;
        [self.view addSubview:_quyuView];
        float quyuY = self.cycleScrollViewheight + FangYuanCellSectionHeight + 44;
        self.quyuView.frame = CGRectMake(0, quyuY, ScreenWidth, self.view.frame.size.height - quyuY);
        
    }
    return _quyuView;
}
- (CJMenuSelectOneConView *)orderView{
    if (_orderView == nil) {
        _orderView = [[CJMenuSelectOneConView alloc] init];
        _orderView.delegate = self;
        _orderView.hidden = YES;
        [self.view addSubview:_orderView];
        float orderY = self.cycleScrollViewheight + FangYuanCellSectionHeight + 44;
        self.orderView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
        
    }
    return _orderView;
}

- (CJMenuSelectOneConView *)serviceTypeView{
    if (_serviceTypeView == nil) {
        _serviceTypeView = [[CJMenuSelectOneConView alloc] init];
        _serviceTypeView.delegate = self;
        _serviceTypeView.hidden = YES;
        [self.view addSubview:_serviceTypeView];
        float orderY = self.cycleScrollViewheight + FangYuanCellSectionHeight + 44;
        self.serviceTypeView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
        
    }
    return _serviceTypeView;
}

#pragma - privates
- (void)showLoupanView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float loupanViewY = rect.origin.y + rect.size.height;
    self.loupanView.frame = CGRectMake(0, loupanViewY, ScreenWidth, self.view.frame.size.height - loupanViewY);
    
    self.loupanView.hidden = NO;
    self.loupanViewIsShow = YES;
    [self.loupanView reloadData];
    [self showTabBar];
}

- (void)hiddenLoupanView{
    self.loupanView.hidden = YES;
    self.loupanViewIsShow = NO;
    [self hideTabBar];
}

- (void)showServiceTypeView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float orderY = rect.origin.y + rect.size.height;
    self.serviceTypeView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
    
    self.serviceTypeView.hidden = NO;
    self.serviceTypeViewIsShow = YES;
    [self showTabBar];
}

- (void)hiddenServiceTypeView{
    self.serviceTypeView.hidden = YES;
    self.serviceTypeViewIsShow = NO;
    [self hideTabBar];
}

- (void)showQuYuView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float quyuY = rect.origin.y + rect.size.height;
    self.quyuView.frame = CGRectMake(0, quyuY, ScreenWidth, self.view.frame.size.height - quyuY);

    [self.quyuView showView];
    self.quyuViewIsShow = YES;
    [self showTabBar];
}

- (void)hiddenQuYuView{
    [self.quyuView hiddenView];
    self.quyuViewIsShow = NO;
    [self hideTabBar];
}

- (void)showOrderView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float orderY = rect.origin.y + rect.size.height;
    self.orderView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
    
    //self.orderView.tintColor = UIColorFromHEX(0x73b8ee);
    
    self.orderView.hidden = NO;
    self.orderViewIsShow = YES;
    [self showTabBar];
}

- (void)hiddenOrderView{
    //self.orderView.tintColor = UIColorFromHEX(0x6e6e6e);

    self.orderView.hidden = YES;
    self.orderViewIsShow = NO;
    [self hideTabBar];
}
    
- (void)showTabBar {
    self.tabbarCoverView.hidden = NO;
}
    
- (void)hideTabBar {
    self.tabbarCoverView.hidden = YES;
}
    
- (UIView *)tabbarCoverView {
    if (_tabbarCoverView == nil) {
        CGFloat height = kDevice_Is_iPhoneX ? 83 : 49;
        _tabbarCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - height, ScreenWidth, height)];
        _tabbarCoverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        [_tabbarCoverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAll)]];
        [[UIApplication sharedApplication].keyWindow addSubview:_tabbarCoverView];
    }
    return _tabbarCoverView;
}
    
- (void)hideAll {
    [self hiddenQuYuView];
    [self hiddenOrderView];
    [self hiddenLoupanView];
    [self hiddenServiceTypeView];
}
@end
