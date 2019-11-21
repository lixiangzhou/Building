//
//  FYServiceSecondLevelVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceSecondLevelVC.h"
#import "CJMenuSelectOneConCell.h"
#import "FYServiceSecondLevelCollectionCell.h"
#import "FYServiceHouseListVC.h"

#define FYServiceSecondLevelCellHeight       49
#define FYServiceSecondLevelCellXibName                @"CJMenuSelectOneConCell"

static NSString * const FYServiceSecondLevelCollectionCellIdentifier = @"FYServiceSecondLevelCollectionCell";
static NSInteger itemNumOfSection = 2;

@interface FYServiceSecondLevelVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) NSInteger currentSelectRow;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) float collectionItemWidth;
@end

@implementation FYServiceSecondLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarTitle:@"房源服务筛选"];

    //数据初始化
    self.tableViewArr = @[];
    self.datasource = @[].mutableCopy;
    self.currentSelectRow = 0;
    self.collectionItemWidth = (ScreenWidth - self.view.width*22/75 - 20) / itemNumOfSection - 6;//-2是防止小数误差
    
    //初始化界面
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;//不显示分割线
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"FYServiceSecondLevelCollectionCell" bundle:nil]forCellWithReuseIdentifier:FYServiceSecondLevelCollectionCellIdentifier];
    [self.view addSubview:_collectionView];
    
//    [EmptyDataManager noDataEmptyView:_collectionView btnActionBlock:^{
//    }];
    
    [self gainFYServiceSecondLevelVCData];
}

#pragma mark - requests
- (void)gainFYServiceSecondLevelVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainFYServiceSecondLevelVCDataSuccess:^(NSArray *banners) {
        weakSelf.tableViewArr = banners;
        FYServiceTwoLevelModel *model = weakSelf.tableViewArr[weakSelf.currentSelectRow];
        model.isSelect = YES;
        weakSelf.datasource = model.houseTypeList;
        [weakSelf.tableView reloadData];
        [weakSelf.collectionView reloadData];
    } failure:^(id response) {
        [self showHint:response];
    }];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CJMenuSelectOneConCell *cell = (CJMenuSelectOneConCell *)[self getCellFromXibName:FYServiceSecondLevelCellXibName dequeueTableView:tableView];
    FYServiceTwoLevelModel *model = self.tableViewArr[indexPath.row];
    if (model.isSelect == YES) {
        cell.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        cell.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
    //cell.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.titleLabel.text = model.buildTypeName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FYServiceSecondLevelCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    if (self.currentSelectRow == row) {//点击的一选中的cell
        
    } else {
        for (FYServiceTwoLevelModel *model in self.tableViewArr) {
            model.isSelect = NO;
        }
        
        FYServiceTwoLevelModel *model = self.tableViewArr[row];
        model.isSelect = YES;
        self.currentSelectRow = row;
        self.datasource = model.houseTypeList;
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self gainCellHeight];
    return CGSizeMake(self.collectionItemWidth, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    FYServiceSecondLevelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FYServiceSecondLevelCollectionCellIdentifier forIndexPath:indexPath];
    
    FYServiceTwoLevelDetailModel *model = self.datasource[row];
    cell.model = model;

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"dsfdsfsadfdfdfd");
    NSInteger row = [indexPath row];
    FYServiceTwoLevelDetailModel *model = self.datasource[row];
    FYServiceHouseListVC *hoseListVC = [[FYServiceHouseListVC alloc] init];
    hoseListVC.houseTypeId = [model.houseTypeId integerValue];
    [hoseListVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseListVC animated:YES];
}

#pragma mark - private
//动态计算label高度
- (CGFloat )gainHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (CGFloat)gainCellHeight{
    float imageWidth = self.collectionItemWidth - 10*2;
    NSInteger imageHeight = imageWidth*3/4;
    NSInteger titleHeight = [self gainHeighWithTitle:@"商品名称" font:[UIFont systemFontOfSize:13.0f] width:(self.collectionItemWidth - 10)] + 5;
    //NSLog(@"self.collectionItemWidth:%lf ,titleHeight:%ld", self.collectionItemWidth, titleHeight);
    NSInteger cellHeight = 10 + imageHeight + 10 + titleHeight + 10;
    return cellHeight;
}

@end
