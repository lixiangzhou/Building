//
//  AddressListVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/8.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "AddressListVC.h"
#import "AddressSelectCell.h"
#import "FYCommonModel.h"
#import "AddressListFooterView.h"
#import "AddAddressVC.h"

#define AddressListVCTableHeaderHeight       120
#define AddressSelectCellHeight       120
#define AddressSelectCellXibName       @"AddressSelectCell"


@interface AddressListVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <AddressModel*> *addressList;

//房源列表的参数信息
@property (nonatomic, copy)  NSString  *token;//header传参,登录了传，没有不传，不影响数据的获取
@end

@implementation AddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"收货地址";

    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = BackGroundColor;
    
    //数据初始化
    self.addressList = [[NSMutableArray alloc] init];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, AddressListVCTableHeaderHeight)];
//    AddressListFooterView *personView = [[AddressListFooterView alloc] init];
//    [headerView addSubview:personView];
//    __weak typeof(self) weakSelf = self;
//    personView.addAddressBtnBlock = ^(UIButton *button){
//        AddAddressVC *hoseDetailVC = [[AddAddressVC alloc] init];
//        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
//        [weakSelf.navigationController pushViewController:hoseDetailVC animated:YES];
//    };
//    personView.frame = CGRectMake(0, 0, ScreenWidth, AddressListVCTableHeaderHeight);
//    self.tableView.tableFooterView = headerView;
    
    AddressListFooterView *personView = [[AddressListFooterView alloc] init];
    __weak typeof(self) weakSelf = self;
    personView.addAddressBtnBlock = ^(UIButton *button){
        AddAddressVC *hoseDetailVC = [[AddAddressVC alloc] init];
        hoseDetailVC.editMode = 2;
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:hoseDetailVC animated:YES];
    };
    personView.frame = CGRectMake(0, -1, ScreenWidth, AddressListVCTableHeaderHeight);
    self.tableView.tableFooterView = personView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self gainAddressList];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - requests
//获取地址列表
- (void)gainAddressList
{
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainAddressListWithHeaderParams:paramsHeader Success:^(NSArray *addressArr) {
        wself.addressList = addressArr;
        [wself.tableView reloadData];
        [wself.tableView.mj_header endRefreshing];
    } failure:^(id  _Nonnull response) {
        [wself.tableView.mj_header endRefreshing];
    }];
}

//更新地址
- (void)updateAddressToDefaultWithIndex:(NSIndexPath *)indexPath
{
    AddressModel *model = self.addressList[indexPath.row];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:model.address forKey:@"address"];//详细地址
    [params setObject:model.idStr forKey:@"addressId"];//地址ID
    [params setObject:model.cityId forKey:@"cityId"];//城市ID
    [params setObject:model.contact forKey:@"contact"];//联系方式
    [params setObject:model.countyId forKey:@"countryId"];//区县ID
    [params setObject:model.provinceId forKey:@"provinceId"];//省份ID
    [params setObject:model.receiver forKey:@"receiver"];//收货人
    [params setObject:@"true" forKey:@"setDefault"];//设置默认,传入true、或者留空
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService updateAddressWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [wself.tableView.mj_header beginRefreshing];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"cellForRowAtIndexPath");

    AddressSelectCell *cell = (AddressSelectCell *)[self getCellFromXibName:AddressSelectCellXibName dequeueTableView:tableView];
    AddressModel *model = self.addressList[indexPath.row];
    cell.addressModel = model;
    __weak typeof(self) weakSelf = self;
    cell.defaultBtnBlock = ^(id sender){
        [weakSelf updateAddressToDefaultWithIndex:indexPath];
    };
    cell.editBtnBlock = ^(UIButton *button){
        AddAddressVC *hoseDetailVC = [[AddAddressVC alloc] init];
        hoseDetailVC.addressModel = model;
        hoseDetailVC.editMode = 1;
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [weakSelf.navigationController pushViewController:hoseDetailVC animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AddressSelectCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"didSelectRowAtIndexPath");
    if (self.selectAddressBlock)
    {
        AddressModel *model = self.addressList[indexPath.row];
        self.selectAddressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
