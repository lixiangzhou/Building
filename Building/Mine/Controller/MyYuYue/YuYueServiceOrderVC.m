//
//  YuYueServiceOrderVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "YuYueServiceOrderVC.h"
//#import "MyYuYueCell.h"
#import "YuYueServiceOrderDetailVC.h"
#import "MyYuYueServiceCell.h"


#define MyYuYueCellHeight       165
#define MyYuYueServiceCellXibName       @"MyYuYueServiceCell"

@interface YuYueServiceOrderVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//接口参数
//@property (strong, nonatomic) NSMutableArray <YuYueOrderItemModel*> *orderList;
@property (strong, nonatomic) NSMutableArray <YuYueServerItemModel*> *sList;
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@end

@implementation YuYueServiceOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sList = [[NSMutableArray alloc] init];
    self.pageSize = 20;
    self.page = 1;
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    NSLog(@"YuYueServiceOrderVC" );

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        [self gainYuYueServerOrderListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainYuYueServerOrderListWithRefresh:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self gainYuYueServerOrderListWithRefresh:YES];
}

#pragma mark - requests
//获取服务类型订单列表
- (void)gainYuYueServerOrderListWithRefresh:(BOOL)isRefresh
{
    static UIImageView *imageView;
    static UILabel *label;
    //NSLog(@"gainYuYueServerOrderListWithRefresh:%ld", isRefresh );


    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (self.pageSize != -1) {
        [params setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    if (self.page != -1) {
        [params setObject:@(self.page) forKey:@"page"];
    }
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if ( [GlobalConfigClass shareMySingle].userAndTokenModel.token != nil ) {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //NSLog(@"self.token:%@", self.token );

    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainYuYueServerOrderListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        YuYueServerListModel *orderListModel = response;
        //NSLog(@"orderListModel.data:%@", orderListModel.data );
        //NSLog(@"orderListModel.data.count:%@", orderListModel.data.count );
        if (orderListModel.data.count==0) {
            //NSLog(@"[imageView addsss]");
            imageView=[[UIImageView alloc] initWithFrame:CGRectMake(130, 124, 115, 100)];
            imageView.image=[UIImage imageNamed:@"bj_pic_no"];
            imageView.tag = 3500;
            [self.tableView addSubview:imageView];
            label=[[UILabel alloc] initWithFrame:CGRectMake(164, 241, 50, 17)];
            label.text=@"暂无信息";
            label.tag = 3501;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor=([UIColor colorWithRed:81/255.0 green:92/255.0 blue:111/255.0 alpha:1]);
            [self.tableView addSubview:label];
        }else{
            //NSLog(@"[imageView need removeFromSuperview]");
            //if( [imageView isKindOfClass:[UIImageView class]])
            for (UIView *view in [self.tableView subviews]){
                if( view.tag == 3500 || view.tag == 3501 )
                {
                    [view removeFromSuperview];
                    //NSLog(@"[view removeFromSuperview]");
                }
            }
        }
        
        if (isRefresh) {
            [self.sList removeAllObjects];
        }
        
        if (!orderListModel.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        [wself.sList addObjectsFromArray:orderListModel.data];
        [wself.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(id  _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//取消预约:orderId    订单ID;type 订单类型    HOUSE：房源，PRODUCT：产品
- (void)cancelYuYueServerType:(NSString *)type orderId:(NSString *)orderId
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:type forKey:@"type"];
    [params setObject:orderId forKey:@"orderId"];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService cancelYuYueOrderWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [wself.tableView.mj_header beginRefreshing];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.sList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyYuYueServiceCell *cell = (MyYuYueServiceCell *)[self getCellFromXibName:MyYuYueServiceCellXibName dequeueTableView:tableView];
    YuYueServerItemModel *model = self.sList[indexPath.row];
    cell.serverModel = model;
    //NSLog(@"orderSn:%@",cell.serverModel.orderSn);

    __weak typeof(self) weakSelf = self;
    cell.cancelBlock = ^(UIButton *button){
        [weakSelf cancelYuYueServerType:@"PRODUCT" orderId:model.idStr];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyYuYueCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YuYueOrderItemModel *model = self.sList[indexPath.row];

    YuYueServiceOrderDetailVC * serviceVC = [[YuYueServiceOrderDetailVC alloc] init];
    serviceVC.orderId = model.idStr;
    [serviceVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:serviceVC animated:YES];
}


@end
