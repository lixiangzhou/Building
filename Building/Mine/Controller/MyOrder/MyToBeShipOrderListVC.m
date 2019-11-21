//
//  MyToBeShipOrderListVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MyToBeShipOrderListVC.h"
#import "MyToBeShipCell.h"
#import "MyToBeShipDetailVC.h"

#define MyOrderCellHeight       200
#define MyToBeShipCellXibName       @"MyToBeShipCell"

@interface MyToBeShipOrderListVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MyOrderItemModel *> *dataArray;
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, copy)  NSString  *status;//退款单状态
@end

@implementation MyToBeShipOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray=[[NSMutableArray alloc]init];
    self.pageSize = 10;
    self.page = 1;
    self.status=@"1";
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        [self gainOrderListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainOrderListWithRefresh:NO];
    }];
//    [self.tableView.mj_header beginRefreshing];
}
//获取订单列表(待发货)
- (void)gainOrderListWithRefresh:(BOOL)isRefresh
{   //NSLog(@"待发货");
    static UIImageView *imageView;
    static UILabel *label;
    
    self.pageSize = 10;
    self.page = 1;
    self.status=@"1";
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    if (self.pageSize != -1) {
        [params setObject:@(self.pageSize) forKey:@"pageSize"];
    }
    if (self.page != -1) {
        [params setObject:@(self.page) forKey:@"page"];
    }
    if (self.status !=nil) {
        [params setObject:self.status forKey:@"status"];
    }
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainMyOrderListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        MyOrderListModel *model=response;
        if (model.data.count==0) {
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
            [self.dataArray removeAllObjects];
        }
        
        if (!model.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:model.data];
        [wself.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(id  _Nonnull response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
//重新刷新列表
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self gainOrderListWithRefresh:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderItemModel *model=self.dataArray[indexPath.row];
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //申请退款参数
    NSMutableDictionary* refundParams = [[NSMutableDictionary alloc] init];
    [refundParams setObject:@"REFUND" forKey:@"operate"];
    [refundParams setObject:model.idStr forKey:@"orderId"];
    MyToBeShipCell *cell = (MyToBeShipCell *)[self getCellFromXibName:MyToBeShipCellXibName dequeueTableView:tableView];
    cell.model = model;
    cell.refundBlock=^(UIButton *btn){
        __weak __typeof__ (self) wself = self;
        [MineNetworkService confirmProductWithParams:refundParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
            [wself showHint:response];
            [self gainOrderListWithRefresh:YES];
        } failure:^(id  _Nonnull response) {
            [wself showHint:response];
        }];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyOrderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderItemModel *model=self.dataArray[indexPath.row];
    MyToBeShipDetailVC *ac=[[MyToBeShipDetailVC alloc] init];
    ac.orderId=model.idStr;
    [ac setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ac animated:YES];
}

@end
