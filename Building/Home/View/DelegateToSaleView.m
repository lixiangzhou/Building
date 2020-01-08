//
//  DelegateToSaleView.m
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "DelegateToSaleView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "LMJDropdownMenu.h"
#import "DelegateToSaleCollectionCell.h"
#import "UIViewController+HUD.h"

static NSString * const DelegateToSaleCollectionCellIdentifier = @"DelegateToSaleCollectionCell";

@interface DelegateToSaleView()<UIGestureRecognizerDelegate, LMJDropdownMenuDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *delegateView;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *LouPanDropdownMenu;
@property (weak, nonatomic) IBOutlet UICollectionView *FJCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *moneyUnitDropdownMenu;
@property (weak, nonatomic) IBOutlet UITextField *serviceMoneyTextField;
@property (weak, nonatomic) IBOutlet LMJDropdownMenu *serviceMoneyUnitDropdownMenu;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UIView *radiusView;




@property (strong, nonatomic) NSMutableArray <DelegateHouseModel *> *buildList;//楼盘列表
@property (strong, nonatomic) NSMutableDictionary *buildDic;//楼盘id为key，值为该楼盘下的房间
@property (strong, nonatomic) NSMutableArray <DelegateHouseModel *> *collectionDatas;

@property (strong, nonatomic) DelegateHouseModel *currentHouseModel;
@property (copy, nonatomic) NSString *currentMoneyUnit;
@property (copy, nonatomic) NSString *currentServerMoneyUnit;
@property (assign, nonatomic) int count;

@end

@implementation DelegateToSaleView

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[UINib nibWithNibName:NSStringFromClass([DelegateToSaleView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
    self.count++;
    //NSLog(@"commonInit:%d", self.count);
    
    self.buildDic = [[NSMutableDictionary alloc] init];
    self.buildList = [[NSMutableArray alloc] init];
    self.collectionDatas = [[NSMutableArray alloc] init];
    
    self.LouPanDropdownMenu.delegate = self;
    self.moneyUnitDropdownMenu.delegate = self;
    self.serviceMoneyUnitDropdownMenu.delegate = self;
    
    self.radiusView.layer.cornerRadius = 10;
    self.radiusView.layer.masksToBounds = YES;
    self.doneButton.backgroundColor = UIColorFromHEX(0x73B8FD);
    //self.currentHouseModel.houseId = nil;
    
    self.moneyTextField.textColor = UIColorFromHEX(0x6e6e6e);
    self.serviceMoneyTextField.textColor = UIColorFromHEX(0x6e6e6e);
    
    [self.moneyTextField setBorderWidthColor:UIColorFromHEX(0xc6c6c6)];
    [self.serviceMoneyTextField setBorderWidthColor:UIColorFromHEX(0xc6c6c6)];
    self.moneyTextField.layer.cornerRadius = 4;
    self.serviceMoneyTextField.layer.cornerRadius = 4;
    
    [self.LouPanDropdownMenu.mainBtn setBorderWidthColor:UIColorFromHEX(0xc6c6c6)];
    [self.serviceMoneyUnitDropdownMenu.mainBtn setBorderWidthColor:UIColorFromHEX(0xc6c6c6)];
    [self.moneyUnitDropdownMenu.mainBtn setBorderWidthColor:UIColorFromHEX(0xc6c6c6)];
    
    self.FJCollectionView.dataSource = self;
    self.FJCollectionView.delegate = self;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    self.FJCollectionView.collectionViewLayout = layout;
    [self.FJCollectionView registerNib:[UINib nibWithNibName:@"DelegateToSaleCollectionCell" bundle:nil] forCellWithReuseIdentifier:DelegateToSaleCollectionCellIdentifier];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackCoverViewTapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
//    UITapGestureRecognizer *delegateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delegateGestureTapAction:)];
//    delegateGesture.delegate = self;
//    [self.delegateView addGestureRecognizer:delegateGesture];
}

#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionDatas.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 47);
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
    
    DelegateToSaleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DelegateToSaleCollectionCellIdentifier forIndexPath:indexPath];
    
    DelegateHouseModel *model = self.collectionDatas[row];
    cell.houseModel = model;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (DelegateHouseModel *buildItem in self.collectionDatas) {
        buildItem.isSelect = NO;
    }
    NSInteger row = [indexPath row];
    DelegateHouseModel *model = self.collectionDatas[row];
    model.isSelect = YES;
    [self.FJCollectionView reloadData];
    self.currentHouseModel = model;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self endEditing:YES];
    if ([touch.view isDescendantOfView:self.delegateView]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Actions
//cover视图tap响应函数
- (void)blackCoverViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    //    UIView *itemView = tapGesture.view;
    //    NSLog(@"%ld", (long)itemView.tag);
    [self endEditing:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverViewTapActionOfDelegateToSaleView)]) {
        [self.delegate coverViewTapActionOfDelegateToSaleView];
    }
}

- (void)delegateGestureTapAction:(UITapGestureRecognizer *)tapGesture
{
    [self endEditing:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self endEditing:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelBtnActionOfDelegateToSaleView)]) {
        [self.delegate cancelBtnActionOfDelegateToSaleView];
    }
}

- (void)showHint:(NSString *)hint
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = [IosDeviceType isIphone_5]?1.f:1.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (IBAction)doneButtonAction:(id)sender {
    //ygz modify 2019-3-27
    //NSLog(@"doneButtonAction enter");
    [self endEditing:YES];
    //[self endEditing:NO];
    //NSLog(@"self.moneyTextField.text:%@", self.moneyTextField.text);
    //NSLog(@"self.serviceMoneyTextField.text:%@", self.serviceMoneyTextField.text);

    if (self.moneyTextField.text.length <= 0){
        [self showHint:@"出租金额未填写"];
        return;
    }/*else if (self.serviceMoneyTextField.text.length <= 0) {
        [self showHint:@"佣金金额未填写"];
        return;
    }*/
    if( [self.currentHouseModel.houseId isEqualToString:@""] || (self.currentHouseModel.houseId == nil) ){
        [self showHint:@"房间未选择"];
        return;
    }
    if( [self.currentMoneyUnit isEqualToString:@""] || (self.currentMoneyUnit == nil) ){
        [self showHint:@"出租金额单位未选择"];
        return;
    }
/*
    if( [self.currentServerMoneyUnit isEqualToString:@""] || (self.currentServerMoneyUnit == nil) )
    {
        [self showHint:@"佣金金额单位未选择"];
        return;
    }
*/
 //NSLog(@"doneButtonAction to delegate");
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneBtnActionOfDelegateToSaleView:)]) {
        //NSLog(@"doneButtonAction in delegate");
        //NSLog(@"moneyTextField:%@, currentMoneyUnit:%@, serviceMoneyTextField:%@, currentServerMoneyUnit:%@, houseId:%@", self.moneyTextField.text, self.currentMoneyUnit, self.serviceMoneyTextField.text, self.currentServerMoneyUnit, self.currentHouseModel.houseId);
        
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        [params setObject:self.moneyTextField.text forKey:@"amount"];//出租金额
        [params setObject:self.currentMoneyUnit forKey:@"amountUnit"];//出租价格单位
        
        if (self.serviceMoneyTextField.text.length <= 0)
            [params setObject:@"" forKey:@"commission"];//佣金
        else
            [params setObject:self.serviceMoneyTextField.text forKey:@"commission"];//佣金
        if( [self.currentServerMoneyUnit isEqualToString:@""] || (self.currentServerMoneyUnit == nil) )
            [params setObject:@"" forKey:@"commissionUnit"];//佣金价格单位
        else
            [params setObject:self.currentServerMoneyUnit forKey:@"commissionUnit"];//佣金价格单位
        
        [params setObject:self.currentHouseModel.houseId forKey:@"houseId"];//房源编号
        
        [self.delegate doneBtnActionOfDelegateToSaleView:params];
    }
}

#pragma mark - LMJDropdownMenuDelegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    [self endEditing:YES];
    [menu.mainBtn setTitleColor:UIColorFromHEX(0x6e6e6e) forState:UIControlStateNormal];
    if (menu == self.LouPanDropdownMenu) {
        DelegateHouseModel *buildItem = self.buildList[number];
        self.collectionDatas = [self.buildDic objectForKey:buildItem.buildingId];
        if (self.collectionDatas.count) {
            self.currentHouseModel = self.collectionDatas.firstObject;
            self.currentHouseModel.isSelect = YES;
        }
        [self.FJCollectionView reloadData];
        self.LouPanDropdownMenu.selectNumber = number;
    } else if (menu == self.moneyUnitDropdownMenu) {//租金
        //self.currentServerMoneyUnit = self.delegateModel.unitList[number];
        self.currentMoneyUnit = self.delegateModel.unitList[number];
        self.moneyUnitDropdownMenu.selectNumber = number;
    } else {//佣金
        self.currentServerMoneyUnit = self.delegateModel.unitList[number];
        self.serviceMoneyUnitDropdownMenu.selectNumber = number;
    }
}

#pragma mark - setters
- (void)setDelegateModel:(DelegateModel *)delegateModel{
    _delegateModel = delegateModel;
    [self endEditing:YES];
    NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
    for (DelegateHouseModel *buildItem in delegateModel.houseList) {
        NSMutableArray *houseTempArr = [cityDic objectForKey:buildItem.buildingId];
        if (houseTempArr == nil) {
            houseTempArr = [[NSMutableArray alloc] init];
            [self.buildList addObject:buildItem];
        }
        [houseTempArr addObject:buildItem];
        [cityDic setObject:houseTempArr forKey:buildItem.buildingId];
    }
    self.buildDic = cityDic;
    
    //初始化楼盘列表数据
    NSMutableArray *louPanNameArr = [[NSMutableArray alloc] init];
    for (DelegateHouseModel *buildItem in self.buildList) {
        [louPanNameArr addObject:buildItem.buildingName];
    }
    
    [self.LouPanDropdownMenu.mainBtn setTitleColor:UIColorFromHEX(0xA7ACB6) forState:UIControlStateNormal];
    [self.LouPanDropdownMenu.mainBtn setTitle:@"请选择楼盘" forState:UIControlStateNormal];
    
    [self.moneyUnitDropdownMenu.mainBtn setTitleColor:UIColorFromHEX(0xA7ACB6) forState:UIControlStateNormal];
    [self.moneyUnitDropdownMenu.mainBtn setTitle:@"请选择单位" forState:UIControlStateNormal];
    
    [self.serviceMoneyUnitDropdownMenu.mainBtn setTitleColor:UIColorFromHEX(0xA7ACB6) forState:UIControlStateNormal];
    [self.serviceMoneyUnitDropdownMenu.mainBtn setTitle:@"请选择单位" forState:UIControlStateNormal];
    
    [self.LouPanDropdownMenu setMenuTitles:louPanNameArr rowHeight:49];
    [self.moneyUnitDropdownMenu setMenuTitles:delegateModel.unitList rowHeight:49];
    [self.serviceMoneyUnitDropdownMenu setMenuTitles:delegateModel.unitList rowHeight:49];
}

@end
