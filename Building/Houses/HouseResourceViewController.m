//
//  HouseResourceViewController.m
//  YouYi
//
//  Created by Macbook Pro on 2019/1/29.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "HouseResourceViewController.h"
#import "SDCycleScrollView.h"
#import "CJDropDownMenuView.h"
#import "FangYuanCell.h"
#import "CJMenuSelectTwoConView.h"
#import "CJMenuSelectOneConView.h"
#import "FYServiceHouseDetailVC.h"
#import "WRCustomNavigationBar.h"
#import "WRNavigationBar.h"
#import "EmptyView.h"
#import "WMDragViewManager.h"

#define FangYuanCellXibName       @"FangYuanCell"
#define FangYuanCellSectionHeight       47
#define FangYuanCellHeight       120
#define FangYuanCellXibName       @"FangYuanCell"

@interface HouseResourceViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, CJDropDownMenuViewDelegate, CJMenuSelectTwoConViewDelegate, CJMenuSelectOneConViewDelegate>
@property (weak, nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *bannerModelArr;
@property (nonatomic, assign) float cycleScrollViewheight;

@property (weak, nonatomic) EmptyView *emptyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CJDropDownMenuView *sectionView;
@property (strong, nonatomic) NSMutableArray <FYItemModel *> *houseList;

//房源列表的参数信息
@property (nonatomic, copy)  NSString  * sort;//排序字段,price_desc:价格从高到底; price_asc:价格从低到高；
@property (nonatomic, assign)  NSInteger rentRange;//租金范围1：1500以下；2：1500-2500；3：2500-3500；4：3500-4500；5：4500以上
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  * metro;//地铁线路
@property (nonatomic, copy)  NSString  * keyWord;//搜索关键词
@property (nonatomic, assign)  NSInteger houseTypeId;//房间类型id，从首页-》房源服务二级页面进来时必填
@property (nonatomic, copy)  NSString  *countyId;//区id
@property (nonatomic, assign)  NSInteger cityId;//城市id,首页定位的，===必填===
@property (nonatomic, assign)  NSInteger tradingId;//商圈id
@property (nonatomic, assign)  NSInteger buildId;

@property (strong, nonatomic) CJMenuSelectOneConView *loupanView;//楼盘
@property (assign, nonatomic) BOOL loupanViewIsShow;
@property (strong, nonatomic) NSArray <FYBuildListModel *> *loupanList;
@property (nonatomic, strong) NSMutableArray *lpArr;
@property (nonatomic, strong) NSArray *loupanArr;


@property (strong, nonatomic) CJMenuSelectTwoConView *quyuView;
@property (assign, nonatomic) BOOL quyuViewIsShow;
@property (strong, nonatomic) NSArray <FYProvinceModel *> *cityList;

@property (strong, nonatomic) CJMenuSelectOneConView *orderView;//排序
@property (assign, nonatomic) BOOL orderViewIsShow;
@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (strong, nonatomic) NSMutableArray <FYShangQuanCityModel *> *sqModel;

@property (nonatomic, strong) UIView *tabbarCoverView;
@property (nonatomic, strong) NSArray *sortArr;
@property (nonatomic, strong) FYCityModel *noLimitCityModel;
@property (nonatomic, strong) WMDragViewManager *dragViewManager;
@end

@implementation HouseResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.frame = CGRectMake(0,0,ScreenWidth, ScreenHeight);
    //self.tableView.backgroundColor = [UIColor redColor];
    //return;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
   
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackGroundColor;

    //数据初始化
    self.bannerModelArr = [[NSMutableArray alloc] init];
    self.houseList = [[NSMutableArray alloc] init];
    self.cityList = [[NSMutableArray alloc] init];
    self.lpArr = [[NSMutableArray alloc] init];
    self.loupanArr = [[NSArray alloc] init];
    self.loupanList = [[NSMutableArray alloc] init];
    self.sortArr = @[@"默认", @"发布 新->旧", @"价格 低->高", @"价格 高->低"];
    
    self.quyuViewIsShow = NO;
    self.orderViewIsShow = NO;
    self.cycleScrollViewheight = ScreenWidth * 56 / 75;
    
    //房源列表的参数信息,-1和nil在请求数据时不用组装成参数
    self.sort = nil;
    self.rentRange = -1;
    self.pageSize = 20;
    self.page = 1;
    self.metro = nil;
    self.keyWord = nil;
    self.houseTypeId = -1;
    self.countyId = nil;
//    self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
    self.tradingId = -1;
    
    //UIView *headView = [self myTableHeaderView];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [self myTableHeaderView];
    
    self.customNavBar.titleLabelColor = UIColorFromHEX(0x6e6e6e);//[UIColor whiteColor];
    //self.customNavBar.title = @"服务";
    [self.customNavBar wr_setBackgroundAlpha:0];
    [self.view insertSubview:self.customNavBar aboveSubview:self.tableView];

    EmptyView *emptyView = [EmptyView new];
    self.emptyView = emptyView;
    [self.tableView addSubview:self.emptyView];
    
    self.view.backgroundColor = BackGroundColor;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    self.tableView.tableHeaderView = [self myTableHeaderView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    CJDropDownMenuView *menuView = [[CJDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47) titleArr:@[@"楼盘", @"区域",@"默认"]];
    menuView.delegate = self;
    menuView.backgroundColor = [UIColor whiteColor];
    self.sectionView = menuView;
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.cycleScrollViewheight + 47 + 65));
        make.centerX.equalTo(self.tableView);
        make.width.equalTo(@(self.emptyView.width));
        make.height.equalTo(@(self.emptyView.height));
     }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        [self gainHouseResourceListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainHouseResourceListWithRefresh:NO];
    }];
//    [self.tableView.mj_header beginRefreshing];
    
    //请求数据
    self.dragViewManager = [WMDragViewManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];

    [self gainBannerData];
    [self gainCityList];
    [self gainCityShangQuanALL];
    [self getLouPanList];
    [self.dragViewManager showDragViewFrom:self];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - requests
//获取房源列表
- (void)gainHouseResourceListWithRefresh:(BOOL)isRefresh
{
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
    if (self.houseTypeId != -1) {
        [params setObject:@(self.houseTypeId) forKey:@"houseTypeId"];
    }
    if (self.countyId != nil) {
        [params setObject:self.countyId forKey:@"countyId"];
    }
    if (self.cityId != -1) {
        [params setObject:@(self.cityId) forKey:@"cityId"];
    } else if ([GlobalConfigClass shareMySingle].cityModel.cityId) {
        [params setObject:[GlobalConfigClass shareMySingle].cityModel.cityId forKey:@"cityId"];
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
    
    __weak __typeof__ (self) wself = self;
    [FangYuanNetworkService gainHouseResourceListWithParams:params Success:^(id  _Nonnull response) {
        FYItemListModel *houseListModel = response;
        if (isRefresh) {
            [self.houseList removeAllObjects];
        }
        
        if (!houseListModel.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        [wself.houseList addObjectsFromArray:houseListModel.data];
        [wself.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        self.emptyView.hidden = self.houseList.count != 0;
        
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
    
- (void)getLouPanList {
    NSDictionary *param = @{};
    if (self.cityId) {
        param = @{@"cityId": @(self.cityId)};
    } else if ([GlobalConfigClass shareMySingle].cityModel.cityId) {
        param = @{@"cityId": [GlobalConfigClass shareMySingle].cityModel.cityId};
    }
    [FangYuanNetworkService getLouPanList:param Success:^(NSArray<FYBuildListModel *> * _Nonnull loupanList) {
        NSMutableArray *array = [@[@"全部"] mutableCopy];
        // 是否包含当前选择的楼盘
        BOOL alreadContainCurrent = NO;
        NSString *name = self.sectionView.titleLabels[0].text;
        if ([name isEqualToString:@"全部"]) {
            alreadContainCurrent = YES;
        }
        for (FYBuildListModel *model in loupanList) {
            [array addObject:model.name];
            if (!alreadContainCurrent &&
                self.buildId == model.id.intValue && [name isEqualToString:model.name]) {
                alreadContainCurrent = YES;
            }
        }
        self.loupanArr = array;

        if (self.loupanArr.count > 1) {
            if (!alreadContainCurrent) {
                self.loupanView.selectIdx = 1;
                self.sectionView.titleLabels[0].text = self.loupanArr[1];
                self.buildId = loupanList[0].id.integerValue;
                [self gainHouseResourceListWithRefresh:YES];
            }
        } else {
            self.sectionView.titleLabels[0].text = self.loupanArr[0];
        }
    } failure:^(id  _Nonnull response) {
        [self gainHouseResourceListWithRefresh:YES];
    }];
}

- (void)gainBannerData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService getBannerInfoWithType:@"POST_HOUSE_RESOURCE" Success:^(NSArray *banners) {
        //NSLog(@"getBannerInfoWithType:%@", banners);
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
#pragma mark - getters and setters
- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > self.cycleScrollViewheight - 130) {
        CGFloat alpha = (offsetY - self.cycleScrollViewheight + 130) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        self.customNavBar.title = @"房源";
        [self.customNavBar wr_setTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        if (offsetY != self.navBarLastY) {
            self.navBarLastY = offsetY;
            self.customNavBar.title = @"";
            [self.customNavBar wr_setBackgroundAlpha:0];
            [self.customNavBar wr_setTintColor:UIColorFromHEX(0x707070)];
            [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
        }
    }
    
    CGFloat h = (offsetY > self.customNavBar.height) ? self.customNavBar.height : 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        scrollView.contentInset = UIEdgeInsetsMake(h
                                                   
                                                   , 0, 0, 0);
    });
//    self.tableViewTopConstraint.constant = h;
//    if (offsetY > self.customNavBar.height) {
//        self.sectionView.frame = CGRectMake(0, self.customNavBar.height, ScreenWidth, 47);
//        [self.view addSubview:self.sectionView];
//    }
    
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float y = rect.origin.y + rect.size.height;
    if (y != self.toolBarLastY) {
        self.toolBarLastY = y;
        CGRect frame = CGRectMake(0, y, ScreenWidth, self.view.frame.size.height - y);
        self.orderView.frame = frame;
        self.quyuView.frame = frame;
        self.loupanView.frame = frame;
    }
}
#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FangYuanCellSectionHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"self.houseList.count:%ld", self.houseList.count);
    return self.houseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FangYuanCell *cell = (FangYuanCell *)[self getCellFromXibName:FangYuanCellXibName dequeueTableView:tableView];
    FYItemModel *model = self.houseList[indexPath.row];
    cell.model = model;
    
    return cell;
    
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    cell.textLabel.text = @"测试";
//
//    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FangYuanCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    
    FYItemModel *model = self.houseList[row];
    FYServiceHouseDetailVC *hoseDetailVC = [[FYServiceHouseDetailVC alloc] init];
    hoseDetailVC.houseId = [model.houseId integerValue];
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
}

#pragma mark - CJDropDownMenuViewDelegate
- (void)didSelectMenuViewItem:(NSInteger)index{
    if(index == 0)
    {//楼盘
        [self hiddenQuYuView];
        [self hiddenOrderView];
        
        if (self.loupanViewIsShow) {//目前正在显示
            [self hiddenLoupanView];
        } else {
            [self showLoupanView];
        }
    }
    else if (index == 1) {//区域
        [self hiddenOrderView];
        [self hiddenLoupanView];

        if (self.quyuViewIsShow) {//目前正在显示
            [self hiddenQuYuView];
        } else {
            [self showQuYuView];
        }
        
    } else {//默认
        [self hiddenQuYuView];
        [self hiddenLoupanView];

        if (self.orderViewIsShow) {//目前正在显示
            [self hiddenOrderView];
        } else {
            [self showOrderView];
        }
    }
    
    
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
    //NSLog(@"city.cityId:%ld", city.cityId );
    if (city != nil) {
        if (city.cityId.length) {
            self.cityId = [city.cityId intValue];
        } else {    // 选择了不限，没有选择子区域
            self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
        }
        if (countryArr.count > 0) {
            self.sectionView.titleLabels[1].text = [countryArr.firstObject countryName];
            self.countyId = [[countryArr valueForKeyPath:@"countryId"] componentsJoinedByString:@","];
        } else {
            self.sectionView.titleLabels[1].text = @"区域";
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
        
        self.sectionView.titleLabels[2].text = self.sortArr[row];
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
                            self.sectionView.titleLabels[0].text = loupanStr.name;
                            self.buildId = [loupanStr.id intValue];
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
    else{

    }
}

- (void)selectOneConViewCoverViewTapActionSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//排序
        [self hiddenOrderView];
    } else if (oneConView == self.loupanView){//楼盘
        [self hiddenLoupanView];
    }
    else{
        [self hiddenOrderView];
        [self hiddenLoupanView];
    }
}

- (NSArray *)selectOneConViewTableViewDatasSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//排序
        return self.sortArr;
    } else if (oneConView == self.loupanView){//楼盘
//        for (NSArray *arr in self.loupanArr)
//        {
//            NSLog(@"NSArrayarr:%@", arr );
//        }
        return self.loupanArr;

//        return nil;
    }
    else{
        return nil;
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
    
    self.orderView.hidden = NO;
    self.orderViewIsShow = YES;
    [self showTabBar];
}

- (void)hiddenOrderView{
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
    [self hiddenLoupanView];
    [self hiddenOrderView];
    [self hiddenQuYuView];
}
@end
