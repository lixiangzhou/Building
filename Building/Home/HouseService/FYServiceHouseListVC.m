//
//  FYServiceHouseListVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceHouseListVC.h"
#import "CJDropDownMenuView.h"
#import "FangYuanCell.h"
#import "CJMenuSelectThreeConView.h"
#import "CJMenuSelectOneConView.h"
#import "FYCommonModel.h"
#import "FYServiceHouseDetailVC.h"
#import "EmptyView.h"

#define FangYuanCellXibName       @"FangYuanCell"
#define FangYuanCellSectionHeight       47
#define FangYuanCellHeight       120
#define FangYuanCellXibName       @"FangYuanCell"

@interface FYServiceHouseListVC ()<UITableViewDataSource, UITableViewDelegate, CJDropDownMenuViewDelegate, CJMenuSelectOneConViewDelegate, UITextFieldDelegate>
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
@property (nonatomic, copy)  NSString  *countyId;//区id
@property (nonatomic, assign)  NSInteger cityId;//城市id,首页定位的，===必填===
@property (nonatomic, assign)  NSInteger tradingId;//商圈id

@property (strong, nonatomic) CJMenuSelectThreeConView *quyuView;
@property (assign, nonatomic) BOOL quyuViewIsShow;
@property (strong, nonatomic) NSArray <FYShangQuanCityModel *> *cityList;
@property (strong, nonatomic) FYShangQuanCityModel * currentCityModel;

@property (strong, nonatomic) CJMenuSelectOneConView *orderView;//排序
@property (assign, nonatomic) BOOL orderViewIsShow;

@property (strong, nonatomic) CJMenuSelectOneConView *zuJinView;//租金
@property (assign, nonatomic) BOOL zuJinViewIsShow;

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) NSArray *sortArr;
@property (nonatomic, strong) NSArray *zhujinArr;
@property (weak, nonatomic) EmptyView *emptyView;
@end

@implementation FYServiceHouseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据初始化
    self.houseList = [[NSMutableArray alloc] init];
    self.cityList = [[NSMutableArray alloc] init];
    self.quyuViewIsShow = NO;
    self.orderViewIsShow = NO;
    self.zuJinViewIsShow = NO;
    self.currentCityModel = nil;
    
    //房源列表的参数信息,-1和nil在请求数据时不用组装成参数
    self.sort = nil;
    self.rentRange = -1;
    self.pageSize = 20;
    self.page = 1;
    self.metro = nil;
    self.keyWord = nil;
    self.countyId = nil;
    self.cityId = [[GlobalConfigClass shareMySingle].cityModel.cityId integerValue];
    self.tradingId = -1;
    
    self.sortArr = @[@"默认", @"发布 新->旧", @"价格 低->高", @"价格 高->低"];
    self.zhujinArr = @[@"不限", @"1500以下", @"1500-2500", @"2500-3500", @"3500-4500", @"4500以上"];
    
    CJDropDownMenuView *menuView = [[CJDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47) titleArr:@[@"区域", @"租金", @"默认"]];
    menuView.delegate = self;
    menuView.backgroundColor = [UIColor whiteColor];
    self.sectionView = menuView;
    
    EmptyView *emptyView = [EmptyView new];
    self.emptyView = emptyView;
    [self.tableView addSubview:self.emptyView];
    self.tableView.backgroundColor = BackGroundColor;
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).offset(-30);
        make.width.equalTo(@(self.emptyView.width));
        make.height.equalTo(@(self.emptyView.height));
    }];
    //设置nav bar
    [self setUpNav];
    
    self.tableView.tableFooterView = [UIView new];
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
    [self.tableView.mj_header beginRefreshing];
    
    //请求数据
    [self gainCityShangQuanList];
}

- (void)setUpNav
{
    //设置tableview的头视图
    NSInteger bgViewHeight = 32;
    NSInteger bgViewWidth = ScreenWidth*4/5;
    
    UIView *bgView = [UIView new];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.layer.cornerRadius = 5;
    bgView.layer.masksToBounds = YES;
    bgView.frame = CGRectMake(0, 0, bgViewWidth, bgViewHeight);
    [bgView setBorderWidthColor:UIColorFromHEX(0xc1c1c1)];

    NSInteger searchLeftMargin = 6;
    NSInteger searchHeight = 15;
    NSInteger searchTopMargin = (bgViewHeight - searchHeight) / 2;
    UIImageView *searchImgView = [UIImageView new];
    [searchImgView setImage:[UIImage imageNamed:@"nav_icon_search"]];
    searchImgView.frame = CGRectMake(searchLeftMargin, searchTopMargin, searchHeight, searchHeight);
    [bgView addSubview:searchImgView];


    NSInteger textLeftMargin = searchLeftMargin + searchHeight + 10;
    NSInteger textHeight = 26;
    NSInteger textTopMargin = (bgViewHeight - textHeight) / 2;
    NSInteger textWidth = bgViewWidth - 10 - textLeftMargin;
    _searchTextField = [[UITextField alloc] init];
    [_searchTextField setReturnKeyType:UIReturnKeySearch];
    _searchTextField.delegate = self;
    [_searchTextField setFont:[UIFont systemFontOfSize:13.0f]];
    [_searchTextField setPlaceholder:@"搜索房源"];
    [_searchTextField setTextColor:UIColorFromHEX(0x333333)];
    _searchTextField.frame = CGRectMake(textLeftMargin, textTopMargin, textWidth, textHeight);
    [bgView addSubview:_searchTextField];


    self.navigationItem.titleView = bgView;
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
    }
    if (self.tradingId != -1) {
        [params setObject:@(self.tradingId) forKey:@"tradingId"];
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
        
        self.emptyView.hidden = self.houseList.count != 0;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(id  _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//城市、商圈基础数据查询
- (void)gainCityShangQuanList{
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityShangQuanListSuccess:^(NSArray * _Nonnull citys) {
        weakSelf.cityList = citys;
        
        NSString *cityId = [GlobalConfigClass shareMySingle].cityModel.cityId;
        for (FYShangQuanCityModel *cityModel in citys) {
            if ([cityId isEqualToString:cityModel.cityId]) {
                weakSelf.currentCityModel = cityModel;
                NSMutableArray *metroList = [NSMutableArray new];
                NSArray *metroArray = [cityModel.metro componentsSeparatedByString:@","];
                
                for (NSString *metroStr in metroArray) {
                    FYShangQuanMetroModel *temp = [[FYShangQuanMetroModel alloc] init];
                    temp.metroName = metroStr;
                    temp.tradingInfoList = @[].mutableCopy;
                    [metroList addObject:temp];
                }
                cityModel.metroList = metroList;
                break;
            }
        }
        
    } failure:^(id  _Nonnull response) {
        
    }];
}

#pragma mark - UITextFieldDelegate
//在textField的代理函数中调用搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchTextField resignFirstResponder];
    
    self.keyWord = textField.text;
    [self.tableView.mj_header beginRefreshing];
    
    return YES;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return FangYuanCellSectionHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.houseList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FangYuanCell *cell = (FangYuanCell *)[self getCellFromXibName:FangYuanCellXibName dequeueTableView:tableView];
    FYItemModel *model = self.houseList[indexPath.row];
    cell.model = model;
    
    return cell;
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
//下拉菜单代理方法
- (void)didSelectMenuViewItem:(NSInteger)index{
    if (index == 0) {//区域
        [self hiddenZuJinView];
        [self hiddenOrderView];
        
        if (self.currentCityModel == nil) {
            [self showHint:@"暂无数据"];
            return;
        }
        
        self.quyuView.currentCityModel = self.currentCityModel;
        if (self.quyuViewIsShow) {//目前正在显示
            [self hiddenQuYuView];
        } else {
            [self showQuYuView];
        }
    } else if (index == 1){//租金
        [self hiddenQuYuView];
        [self hiddenOrderView];
        
        if (self.zuJinViewIsShow) {//目前正在显示
            [self hiddenZuJinView];
        } else {
            [self showZuJinView];
        }
    } else {//默认
        [self hiddenQuYuView];
        [self hiddenZuJinView];
        
        if (self.orderViewIsShow) {//目前正在显示
            [self hiddenOrderView];
        } else {
            [self showOrderView];
        }
    }
}

//#pragma mark - CJMenuSelectThreeConViewDelegate
//- (void)doneSelectTradingId:(NSInteger)tradingId{
//    self.metro = nil;
//    self.tradingId = tradingId;
//    [self.tableView.mj_header beginRefreshing];
//    
//    [self hiddenQuYuView];
//}
//
//- (void)doneSelectBuXian{
//    self.metro = nil;
//    self.tradingId = -1;
//    [self.tableView.mj_header beginRefreshing];
//    
//    [self hiddenQuYuView];
//}
//
//- (void)doneSelectMeroRow:(NSInteger)row{
//    FYShangQuanMetroModel *model = self.currentCityModel.metroList[row];
//    self.metro = model.metroName;
//    self.tradingId = -1;
//    [self.tableView.mj_header beginRefreshing];
//    
//    [self hiddenQuYuView];
//}
//
//- (void)coverViewTapAction{
//    [self hiddenQuYuView];
//}

#pragma mark - CJMenuSelectOneConViewDelegate
//row从0开始，分别为@[@"默认", @"价格 低->高", @"价格 高->低"]
- (void)selectOneConViewSelectRow:(NSInteger)row selfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//默认列表
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
    } else {//租金选择列表
        //1：1500以下；2：1500-2500；3：2500-3500；4：3500-4500；5：4500以上
        if (row == 0) {//不限
            self.rentRange = -1;
        } else {
            self.rentRange = row;
        }
        
        self.sectionView.titleLabels[1].text = self.zhujinArr[row];
        
        [self.tableView.mj_header beginRefreshing];
        
        [self hiddenZuJinView];
    }
}

- (void)selectOneConViewCoverViewTapActionSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//默认列表
        [self hiddenOrderView];
    } else {//租金选择列表
        [self hiddenZuJinView];
    }
}

- (NSArray *)selectOneConViewTableViewDatasSelfView:(CJMenuSelectOneConView *)oneConView{
    if (oneConView == self.orderView) {//默认列表
        return self.sortArr;
    } else {//租金选择列表
        return self.zhujinArr;
    }
}

#pragma - getters and setters
- (CJMenuSelectThreeConView *)quyuView{
    if (_quyuView == nil) {
        _quyuView = [[CJMenuSelectThreeConView alloc] init];
//        _quyuView.delegate = self;
        _quyuView.hidden = YES;
        [self.view addSubview:_quyuView];
        float quyuY = FangYuanCellSectionHeight + 44;
        self.quyuView.frame = CGRectMake(0, quyuY, ScreenWidth, self.view.frame.size.height - quyuY);
        MJWeakSelf;
        self.quyuView.selectedBlock = ^{
            weakSelf.metro = weakSelf.quyuView.metro;
            weakSelf.countyId = weakSelf.quyuView.countryModel.countryId;
            
            if (weakSelf.quyuView.tradingModel.tradingId.length) {
                weakSelf.tradingId = weakSelf.quyuView.tradingModel.tradingId.integerValue;
            } else {
                weakSelf.tradingId = -1;
            }
            
            if (weakSelf.metro.length) {
                weakSelf.sectionView.titleLabels[0].text = weakSelf.metro;
            } else if (weakSelf.tradingId > 0) {
                weakSelf.sectionView.titleLabels[0].text = weakSelf.quyuView.tradingModel.tradingName;
            } else if (weakSelf.countyId.length) {
                weakSelf.sectionView.titleLabels[0].text = weakSelf.quyuView.countryModel.countryName;
            }
            
            [weakSelf gainHouseResourceListWithRefresh:YES];
        };
        
    }
    return _quyuView;
}
- (CJMenuSelectOneConView *)orderView{
    if (_orderView == nil) {
        _orderView = [[CJMenuSelectOneConView alloc] init];
        _orderView.delegate = self;
        _orderView.hidden = YES;
        [self.view addSubview:_orderView];
        float orderY = FangYuanCellSectionHeight + 44;
        self.orderView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
        
    }
    return _orderView;
}

- (CJMenuSelectOneConView *)zuJinView{
    if (_zuJinView == nil) {
        _zuJinView = [[CJMenuSelectOneConView alloc] init];
        _zuJinView.delegate = self;
        _zuJinView.hidden = YES;
        [self.view addSubview:_zuJinView];
        float orderY = FangYuanCellSectionHeight + 44;
        self.zuJinView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
        
    }
    return _zuJinView;
}

#pragma - privates
- (void)showQuYuView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float quyuY = rect.origin.y + rect.size.height;
    self.quyuView.frame = CGRectMake(0, quyuY, ScreenWidth, self.view.frame.size.height - quyuY);
    
    [self.quyuView showView];
    self.quyuViewIsShow = YES;
}

- (void)hiddenQuYuView{
    [self.quyuView hiddenView];
    self.quyuViewIsShow = NO;
}

- (void)showOrderView{
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float orderY = rect.origin.y + rect.size.height;
    self.orderView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
    
    self.orderView.hidden = NO;
    self.orderViewIsShow = YES;
}

- (void)hiddenOrderView{
    self.orderView.hidden = YES;
    self.orderViewIsShow = NO;
}

- (void)showZuJinView{
    CGRect rect = [self.sectionView convertRect:self.sectionView.bounds toView:self.view];
    float orderY = rect.origin.y + rect.size.height;
    self.zuJinView.frame = CGRectMake(0, orderY, ScreenWidth, self.view.frame.size.height - orderY);
    
    self.zuJinView.hidden = NO;
    self.zuJinViewIsShow = YES;
}

- (void)hiddenZuJinView{
    self.zuJinView.hidden = YES;
    self.zuJinViewIsShow = NO;
}
@end
