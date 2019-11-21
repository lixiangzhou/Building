//
//  CJMenuSelectTwoConView.m
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CJMenuSelectTwoConView.h"
#import "CJMenuSelectCell.h"
#import "CJMenuCommonCell.h"

#define CJMenuSelectTwoConViewCellHeight       49
#define CJMenuCommonCellXibName                @"CJMenuCommonCell"
#define CJMenuSelectCellXibName                @"CJMenuSelectCell"


@interface CJMenuSelectTwoConView()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic, strong) NSArray *leftTableViewArr;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, strong) NSMutableArray *rightSelectedRows;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (nonatomic, strong) NSArray *rightTableViewArr;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end


@implementation CJMenuSelectTwoConView

- (instancetype)init
{
    if (self = [super init]) {
//        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
//        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([CJMenuSelectTwoConView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
         [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
    self.rightSelectedRows = [NSMutableArray new];
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [UIView new];
    self.leftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [UIView new];
    self.rightTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.resetButton.layer.cornerRadius = 4;
    self.doneButton.layer.cornerRadius = 4;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackCoverViewTapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    self.leftTableViewArr = [[NSMutableArray alloc] init];
    self.leftSelectedRow = 0;
    self.rightTableViewArr = [[NSMutableArray alloc] init];
    
    [self reloadAllTableView];
//    [self reloadRightTableView];
}

#pragma mark - Actions
//cover视图tap响应函数
- (void)blackCoverViewTapAction:(UITapGestureRecognizer *)tapGesture
{
//    UIView *itemView = tapGesture.view;
    //    NSLog(@"%ld", (long)itemView.tag);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverViewTapAction)]) {
        [self.delegate coverViewTapAction];
    }
}

- (IBAction)resetButtonAction:(id)sender {
    [self restTableviewData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetButtonAction:)]) {
        [self.delegate resetButtonAction:nil];
    }
}

- (void)restTableviewData{
    FYCityModel *cityModel = self.leftTableViewArr[self.leftSelectedRow];
    cityModel.isSelect = NO;
    for (FYCountryModel *countryModel in cityModel.countryInfoList) {
        countryModel.isSelect = NO;
    }
}

- (IBAction)doneButtonAction:(id)sender {
    NSMutableArray *selectCountryArr = [[NSMutableArray alloc] init];
    FYCityModel *cityModel = self.leftTableViewArr[self.leftSelectedRow];
    
    for (FYCountryModel *countryModel in cityModel.countryInfoList) {
        if (countryModel.isSelect == YES) {
            [selectCountryArr addObject:countryModel];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneButtonActionSelectCity:selectCountryArr:)]) {
        [self.delegate doneButtonActionSelectCity:cityModel selectCountryArr:selectCountryArr];
    }
    
//    [self restTableviewData];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.blackView]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {//左侧
        return self.leftTableViewArr.count;
    } else {
        return self.rightTableViewArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {//左侧
        CJMenuCommonCell * cell = [tableView dequeueReusableCellWithIdentifier:CJMenuCommonCellXibName];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:CJMenuCommonCellXibName owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        FYCityModel *model = self.leftTableViewArr[indexPath.row];
        model.isSelect = self.leftSelectedRow == indexPath.row;
        cell.cityModel = model;
        
        return cell;
    } else {
        CJMenuSelectCell * cell = [tableView dequeueReusableCellWithIdentifier:CJMenuSelectCellXibName];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:CJMenuSelectCellXibName owner:nil options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        FYCountryModel *model = self.rightTableViewArr[indexPath.row];
        cell.countryModel = model;
        
//        cell.backgroundColor = selected ? [UIColor whiteColor] : UIColorFromHEX(0xF9F9F9);
//        cell.textLabel.textColor = selected ? UIColorFromHEX(0x73B8FD) : UIColorFromHEX(0x6E6E6E);
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CJMenuSelectTwoConViewCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    if (tableView == self.leftTableView) {//左侧
        if (self.leftSelectedRow == row) {//选中了当前行，什么也不用做
            
        } else {//选中了其他行，要重置当前已经选中的数据
            for (FYCityModel *cityModel in self.leftTableViewArr) {
                cityModel.isSelect = NO;
            }
            FYCityModel *cityModel = self.leftTableViewArr[self.leftSelectedRow];
            for (FYCountryModel *countryModel in cityModel.countryInfoList) {
                countryModel.isSelect = NO;
            }
        }
        self.leftSelectedRow = row;//FYProvinceModel
        
        FYCityModel *cityModel = self.leftTableViewArr[row];
        cityModel.isSelect = YES;//为新的选中行设置选中状态
        
        [self reloadAllTableView];
    } else {
        FYCountryModel *countryModel = self.rightTableViewArr[row];
        countryModel.isSelect = !countryModel.isSelect;//为新的选中行设置选中状态
        
        [self.rightTableView reloadData];
    }
}

#pragma mark - Private
- (void)reloadAllTableView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftTableViewDatas)]) {
        self.leftTableViewArr = [self.delegate leftTableViewDatas];
        FYCityModel *cityModel = self.leftTableViewArr[self.leftSelectedRow];
        self.rightTableViewArr = cityModel.countryInfoList;
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    }
}

- (void)showView{
    self.hidden = NO;
    [self reloadAllTableView];
}

- (void)hiddenView{
    self.hidden = YES;
}
@end
