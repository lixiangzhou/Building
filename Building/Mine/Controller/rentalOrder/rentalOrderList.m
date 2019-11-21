//
//  rentakOrderList.m
//  Building
//
//  Created by Mac on 2019/3/25.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "rentalOrderList.h"
#import "MineModel.h"
#import "rentalOrderCell.h"
#import "rentalOderDetail.h"


@interface rentalOrderList ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;   //list table
@property (nonatomic, strong) NSMutableArray<rentalOrderItemModel *> *rol;
@property (nonatomic, assign)  NSInteger page;//查询页码,默认第一页，===必填===
@property (nonatomic, assign)  NSInteger pageSize;//每页记录数,默认十条，===必填===
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, copy)  NSString  *orderSta;//订单状态
@property (assign, nonatomic) int navBarHeight;
@end

@implementation rentalOrderList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rol=[[NSMutableArray alloc]init];
    self.pageSize = 10;
    self.page = 1;
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }

    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        self.tableView.mj_footer.hidden = YES;
        //NSLog(@"gainrentalOrderList:%ld",self.page);
        [self gainrentalOrderList:YES];
    }];
    //上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self gainrentalOrderList:NO];
    }];
    //NSLog(@"gainrentalOrderList1:%ld",self.page);
    //[self gainrentalOrderList:YES];

    [self.tableView.mj_header beginRefreshing];
}

//委托出租k列表
- (void)gainrentalOrderList:(BOOL)isRefresh
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
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainRentalOrderListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        rentalOrderListMode *model=response;
        
        //NSLog(@"rentalOrderListMode-data:%@",model.data);
        //NSLog(@"rentalOrderListMode-data count:%ld",model.data.count);
        if (model.data.count==0) {
            imageView=[[UIImageView alloc] initWithFrame:CGRectMake(130, 124, 115, 100)];
            imageView.image=[UIImage imageNamed:@"bj_pic_no"];
            [self.tableView addSubview:imageView];
            label=[[UILabel alloc] initWithFrame:CGRectMake(164, 241, 50, 17)];
            label.text=@"暂无信息";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor=([UIColor colorWithRed:81/255.0 green:92/255.0 blue:111/255.0 alpha:1]);
            [self.tableView addSubview:label];
        }else{
            if( [imageView isKindOfClass:[UIImageView class]])
            {
                [imageView removeFromSuperview];
            }
            if( [label isKindOfClass:[UILabel class]] )
                [label removeFromSuperview];
        }
        
        if (isRefresh) {
            [self.rol removeAllObjects];
        }
        
        if (!model.hasNext) {//下拉加载更多
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        //self.tableView.frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-104);
        //NSLog(@"wself.rol addObjectsFromArray:model.data");
        [wself.rol addObjectsFromArray:model.data];
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
    [self gainrentalOrderList:YES];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"tableView numberOfRowsInSection");
    return [self.rol count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableView cellForRowAtIndexPath");
    rentalOrderItemModel *model=self.rol[indexPath.row];
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    rentalOrderCell *cell = (rentalOrderCell *)[self getCellFromXibName:rentalOrderCellXibName dequeueTableView:tableView];
    
    cell.model=model;
    //NSLog(@"cell-model:%@", cell.model );
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:model.orderId forKey:@"orderId"];
    //NSLog(@"rentalOrderCell paramsHeader:%@",paramsHeader);
    
    if( [model.orderStatus integerValue] == 0 )
    {
        //NSLog(@"params:%@",params);
        cell.cancelBlock=^(UIButton *btn){
            //NSLog(@"params:%@",params);
            //NSLog(@"headerParams:%@",paramsHeader);
            __weak __typeof__ (self) wself = self;
            [MineNetworkService disCancelRentalOrderWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
                [wself showHint:response];
                [self gainrentalOrderList:YES];
                [self.tableView.mj_header beginRefreshing];
                [self.tableView.mj_footer endRefreshing];
                //NSLog(@"disCancelRentalOrderWithParams:%@",response);
                } failure:^(id  _Nonnull response) {
                    [wself showHint:@"取消委托失败"];
            }];
        };
    }
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"tableView heightForRowAtIndexPath");
    return CELL_HIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    rentalOrderItemModel *model=self.rol[indexPath.row];
    rentalOderDetail *rod=[[rentalOderDetail alloc] init];
    rod.orderId=model.orderId;
    //NSLog(@"tableView didSelectRowAtIndexPath:%@, orderId:%@",model, rod.orderId );
    [rod setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:rod animated:YES];
//    if ([roModel.orderStatus integerValue]==0) {
//        //待受理
//    }else if ([roModel.orderStatus integerValue]==1){
//        //已受理
//    }else if ([roModel.orderStatus integerValue]==2){
//        //已取消
//    }else{
//        //未知
//    }

}
@end
