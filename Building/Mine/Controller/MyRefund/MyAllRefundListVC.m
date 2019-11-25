//
//  MyAllRefundListVC.m
//  Building
//
//  Created by Mac on 2019/3/11.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyAllRefundListVC.h"
#import "MyRefundCell.h"
#import "MyRefundDetailVC.h"
#import "MyRefundDetailVC.h"
#import "MyAfterSaleController.h"
#import "RefundController.h"

#define MyRefundCellHeight       200
#define MyRefundCellXibName       @"MyRefundCell"

@interface MyAllRefundListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSMutableArray<RefundItemModel *> *dataArray;
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, copy)  NSString  *status;//退款单状态

@end

@implementation MyAllRefundListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray=[[NSMutableArray alloc]init];
    self.pageSize = 10;
    self.page = 1;
    self.status=@"ALL";
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        [self gainRefundListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainRefundListWithRefresh:NO];
    }];
    [self.tableView.mj_header beginRefreshing];
}
//获取退款单列表
- (void)gainRefundListWithRefresh:(BOOL)isRefresh
{
    static UIImageView *imageView;
    static UILabel *label;
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
    [MineNetworkService gainMyRefundListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        //NSLog(@"params:%@",params);
         //NSLog(@"headerParams:%@",paramsHeader);
        RefundListModel *orderListModel = response;
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
        //NSLog(@"dataArray:%@",orderListModel.data);
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        
        if (!orderListModel.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        [wself.dataArray addObjectsFromArray:orderListModel.data];
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
    [self gainRefundListWithRefresh:YES];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyRefundCell *cell = (MyRefundCell *)[self getCellFromXibName:MyRefundCellXibName dequeueTableView:tableView];
    RefundItemModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    
    [params setObject:model.idStr forKey:@"refundId"];
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    if ([model.refundStatus integerValue] ==0 || [model.refundStatus integerValue] ==3) {
        cell.cancelBlock = ^(void) {
            //NSLog(@"params:%@",params);
            //NSLog(@"headerParams:%@",paramsHeader);
             __weak __typeof__ (self) wself = self;
            [MineNetworkService discharageMyRefundItemWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
                 [wself showHint:response];
                [self gainRefundListWithRefresh:YES];
            } failure:^(id  _Nonnull response) {
                 [wself showHint:@"撤销申请失败"];
            }];
            
        };
    }
    NSMutableDictionary* confirmParams = [[NSMutableDictionary alloc] init];
    [confirmParams setObject:@"RECEIPT" forKey:@"operate"];
    [confirmParams setObject:model.orderId forKey:@"orderId"];
    
    NSMutableDictionary* refundParams = [[NSMutableDictionary alloc] init];
    [refundParams setObject:@"REFUND" forKey:@"operate"];
    [refundParams setObject:model.orderId forKey:@"orderId"];
    
    MJWeakSelf
    cell.cancelBlock = ^{
        [MineNetworkService discharageMyRefundItemWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
            [weakSelf showHint:response];
             [self gainRefundListWithRefresh:YES];
        } failure:^(id  _Nonnull response) {
            [weakSelf showHint:@"撤销申请失败"];
        }];
    };
    
    cell.changeBlock = ^{
        MyAfterSaleController *vc = [MyAfterSaleController new];
        vc.refundModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    cell.serviceBlock = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15900594090"] options:@{} completionHandler:nil];
    };
    
    cell.returnBlock = ^{
        RefundController *vc = [RefundController new];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MyRefundCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RefundItemModel *model=self.dataArray[indexPath.row];
    MyRefundDetailVC * refundVC = [[MyRefundDetailVC alloc] init];
    refundVC.refundId = model.idStr;
    [refundVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:refundVC animated:YES];
    
}

@end
