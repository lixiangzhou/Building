//
//  CropServiceSecondLevelVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CropServiceSecondLevelVC.h"
#import "CJMenuSelectOneConCell.h"
#import "FYServiceSecondLevelCollectionCell.h"
#import "CropServiceHouseListVC.h"

#define FYServiceSecondLevelCellHeight       49
#define FYServiceSecondLevelCellXibName                @"CJMenuSelectOneConCell"

static NSString * const FYServiceSecondLevelCollectionCellIdentifier = @"FYServiceSecondLevelCollectionCell";
static NSInteger itemNumOfSection = 2;

@interface CropServiceSecondLevelVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewArr;
@property (nonatomic, assign) NSInteger currentSelectRow;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) float collectionItemWidth;
@end

@implementation CropServiceSecondLevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarTitle:@"企业服务筛选"];
    
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
    
    [self gainCropServiceSecondLevelVCData];
}

#pragma mark - requests
- (void)gainCropServiceSecondLevelVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainCropServiceSecondLevelVCDataSuccess:^(NSArray *banners) {
        weakSelf.tableViewArr = banners;
        if (banners.count > 0) {
            BuildCropServiceTwoLevelModel *model = weakSelf.tableViewArr[weakSelf.currentSelectRow];
            model.isSelect = YES;
            weakSelf.datasource = model.productTypeList;
        }
        
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
    BuildCropServiceTwoLevelModel *model = self.tableViewArr[indexPath.row];
    if (model.isSelect == YES) {
        cell.backgroundColor = UIColorFromHEX(0xffffff);
    } else {
        cell.backgroundColor = UIColorFromHEX(0xf3f3f3);
    }
    
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
        for (BuildCropServiceTwoLevelModel *model in self.tableViewArr) {
            model.isSelect = NO;
        }
        
        BuildCropServiceTwoLevelModel *model = self.tableViewArr[row];
        model.isSelect = YES;
        self.currentSelectRow = row;
        self.datasource = model.productTypeList;
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
    
    BuildCropServiceTwoLevelDetailModel *model = self.datasource[row];
    cell.serviceModel = model;

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    BuildCropServiceTwoLevelDetailModel *model = self.datasource[row];
    CropServiceHouseListVC *hoseListVC = [[CropServiceHouseListVC alloc] init];
    hoseListVC.productTypeId = [model.productTypeId integerValue];
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
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (CGFloat)gainCellHeight{
    float imageWidth = self.collectionItemWidth - 10*2;
    NSInteger imageHeight = imageWidth*3/4;
    NSInteger titleHeight = [self gainHeighWithTitle:@"商品名称" font:[UIFont systemFontOfSize:13.0f] width:(self.collectionItemWidth - 10)];
    
    NSInteger cellHeight = 10 + imageHeight + 10 + titleHeight + 10;
    return cellHeight;
}

@end
