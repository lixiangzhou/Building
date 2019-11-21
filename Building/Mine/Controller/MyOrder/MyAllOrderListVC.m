//
//  MyAllOrderListVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MyAllOrderListVC.h"

#import "MyOrderCell.h"
#import "MyToBePayCell.h"
#import "MyToBeShipCell.h"
#import "MyToBeReceiveCell.h"
#import "MyToBePayDetailVC.h"
#import "MyToBeShipDetailVC.h"
#import "MyToBeReceiveDetailVC.h"
#import "MyAlreadyReceiveDetailVC.h"
#import "MyAlreadyCancelDetailVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "paySelectControl.h"

#define MyOrderCellHeight       200

#define MyOrderCellXibName          @"MyOrderCell"
#define MyToBePayCellXibName        @"MyToBePayCell"
#define MyToBeShipCellXibName       @"MyToBeShipCell"
#define MyToBeReceiveCellXibName       @"MyToBeReceiveCell"

@interface MyAllOrderListVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MyOrderItemModel *> *dataArray;
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, copy)  NSString  *status;//退款单状态
@property (nonatomic, strong) paySelectControl *ps;//委托视图

@end

@implementation MyAllOrderListVC

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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        //NSLog(@"gainOrderListWithRefresh0:%ld",self.page);
        [self gainOrderListWithRefresh:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainOrderListWithRefresh:NO];
    }];
//    [self.tableView.mj_header beginRefreshing];
    
    [self configPaySelect];

}
//获取订单列表
- (void)gainOrderListWithRefresh:(BOOL)isRefresh
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
    //NSLog(@"tableView numberOfRowsInSection");
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"tableView cellForRowAtIndexPath");
    MyOrderItemModel *model=self.dataArray[indexPath.row];
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    //确认收货参数
    NSMutableDictionary* confirmParams = [[NSMutableDictionary alloc] init];
    [confirmParams setObject:@"RECEIPT" forKey:@"operate"];
    [confirmParams setObject:model.idStr forKey:@"orderId"];
    //申请退款参数
    NSMutableDictionary* refundParams = [[NSMutableDictionary alloc] init];
    [refundParams setObject:@"REFUND" forKey:@"operate"];
    [refundParams setObject:model.idStr forKey:@"orderId"];
    //取消参数
    NSMutableDictionary* cancelParams = [[NSMutableDictionary alloc] init];
    [cancelParams setObject:@"CANCEL" forKey:@"operate"];
    [cancelParams setObject:model.idStr forKey:@"orderId"];
    //待支付参数
    NSMutableDictionary* payParams = [[NSMutableDictionary alloc] init];
    [payParams setObject:model.orderSn forKey:@"orderSn"];
    if ([model.orderStatus integerValue]==3 || [model.orderStatus integerValue]==4) {
         MyOrderCell *cell = (MyOrderCell *)[self getCellFromXibName:MyOrderCellXibName dequeueTableView:tableView];
        cell.model=model;
        return cell;
    }else if ([model.orderStatus integerValue]==0){
        MyToBePayCell *cell=(MyToBePayCell *)[self getCellFromXibName:MyToBePayCellXibName dequeueTableView:tableView];
        cell.model=model;
        cell.cannelBlock=^(UIButton *btn){
         __weak __typeof__ (self) wself = self;
            [MineNetworkService confirmProductWithParams:cancelParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
                [wself showHint:response];
                [self gainOrderListWithRefresh:YES];
            } failure:^(id  _Nonnull response) {
                [wself showHint:response];
                }];
            
        };
         __weak __typeof__ (self) wself = self;
        cell.payBlock=^(UIButton *btn){
            wself.ps.orderSn = model.orderSn;
            wself.ps.paymode = 2;
            [wself.ps showFrom:nil completion:^(BOOL isOK) {
                if (isOK) {                
                    [wself.tableView.mj_header beginRefreshing];
                }
            }];
//            [wself gainOrderListWithRefresh:YES];

//            //向后台获取支付宝拉起的字符串
//            [MineNetworkService gainMyOrderPayWithParams:payParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
//                //调用支付宝支付接口
//                [[AlipaySDK defaultService] payOrder:response fromScheme:AliPayScheme callback:^(NSDictionary *resultDic) {
//                    //            NSLog(@"payreslut : %@",resultDic);
//                    [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^{}];
//                }];
//            } failure:^(id  _Nonnull response) {
//                [wself showHint:response];
//            }];
            
        };
        return cell;
    }else if ([model.orderStatus integerValue]==1){
        MyToBeShipCell *cell=(MyToBeShipCell *)[self getCellFromXibName:MyToBeShipCellXibName dequeueTableView:tableView];
        cell.model=model;
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
    }else{
        MyToBeReceiveCell *cell=(MyToBeReceiveCell *)[self getCellFromXibName:MyToBeReceiveCellXibName dequeueTableView:tableView];
        cell.model=model;
        cell.refundBlock=^(UIButton *btn){
            __weak __typeof__ (self) wself = self;
            [MineNetworkService confirmProductWithParams:refundParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
                [wself showHint:response];
                [self gainOrderListWithRefresh:YES];
            } failure:^(id  _Nonnull response) {
                [wself showHint:response];
            }];
        };
        cell.confirmBlock=^(UIButton *btn){
            __weak __typeof__ (self) wself = self;
            [MineNetworkService confirmProductWithParams:confirmParams headerParams:paramsHeader Success:^(id  _Nonnull response) {
                [wself showHint:response];
                [self gainOrderListWithRefresh:YES];
            } failure:^(id  _Nonnull response) {
                [wself showHint:response];
            }];
        };
        return cell;
    }
    
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"tableView heightForRowAtIndexPath");

    return MyOrderCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"tableView cellForRowAtIndexPath");
    MyOrderItemModel *model=self.dataArray[indexPath.row];
    if ([model.orderStatus integerValue]==0) {
        MyToBePayDetailVC *ac=[[MyToBePayDetailVC alloc] init];
        ac.orderId=model.idStr;
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }else if ([model.orderStatus integerValue]==1){
        MyToBeShipDetailVC *ac=[[MyToBeShipDetailVC alloc] init];
        ac.orderId=model.idStr;
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }else if ([model.orderStatus integerValue]==2){
        MyToBeReceiveDetailVC *ac=[[MyToBeReceiveDetailVC alloc] init];
        ac.orderId=model.idStr;
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }else if ([model.orderStatus integerValue]==3){
        MyAlreadyReceiveDetailVC *ac=[[MyAlreadyReceiveDetailVC alloc] init];
        ac.orderId=model.idStr;
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }else{
        MyAlreadyCancelDetailVC *ac=[[MyAlreadyCancelDetailVC alloc] init];
        ac.orderId=model.idStr;
        [ac setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ac animated:YES];
    }
}



- (void)configPaySelect{
    //委托视图
    self.ps = [[paySelectControl alloc] init];
    self.ps.pscd = self;
}

- (void)coverViewTapActionOfpsView{
    [self.ps hide];
    //self.tabBarController.tabBar.hidden = NO;
    //NSLog(@"coverViewTapActionOfDelegateToSaleView");
    
    //[self configPaySelect];
    //[self.delegateView removeFromSuperview];
}

- (void)coverViewTapActionOfpsOkView{
    [self.ps hide];
//    [self.navigationController popViewControllerAnimated:YES];
}




@end
