//
//  SelectAreaView.m
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "SelectAreaView.h"


@interface SelectAreaView()<UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIPickerView *onePickerView;

@property (assign, nonatomic) NSInteger oneTableSelectRow;
@property (assign, nonatomic) NSInteger twoTableSelectRow;
@property (assign, nonatomic) NSInteger threeTableSelectRow;
@end

@implementation SelectAreaView

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
        self = [[[UINib nibWithNibName:NSStringFromClass([SelectAreaView class]) bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        [self commonInit];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackCoverViewTapAction:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    self.oneTableSelectRow = 0;
    self.twoTableSelectRow = 0;
    self.threeTableSelectRow = 0;
    
    self.onePickerView.delegate = self;
    self.onePickerView.dataSource = self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.dataView]) {
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
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverViewTapAction)]) {
        [self.delegate coverViewTapAction];
    }
}
- (IBAction)cancelButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectArea)]) {
        [self.delegate cancelSelectArea];
    }
}
- (IBAction)doneButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneSelectOneComponentRow:twoComponentRow:threeComponentRow:)]) {
        [self.delegate doneSelectOneComponentRow:self.oneTableSelectRow twoComponentRow:self.twoTableSelectRow threeComponentRow:self.threeTableSelectRow];
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceList count];
    } else if (component == 1) {
        FYProvinceModel *provinceModel = self.provinceList[self.oneTableSelectRow];
        return [provinceModel.cityList count];
    } else {
        FYProvinceModel *provinceModel = self.provinceList[self.oneTableSelectRow];
        FYCityModel *cityModel = provinceModel.cityList[self.twoTableSelectRow];
        return [cityModel.countryInfoList count];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
    
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *text = nil;
    if (component == 0) {//省
        FYProvinceModel *provinceModel = self.provinceList[row];
        text = provinceModel.provinceName;
    } else if (component == 1) {//市
        FYProvinceModel *provinceModel = self.provinceList[self.oneTableSelectRow];
        FYCityModel *cityModel = provinceModel.cityList[row];
        text = cityModel.cityName;
    } else {
        FYProvinceModel *provinceModel = self.provinceList[self.oneTableSelectRow];
        FYCityModel *cityModel = provinceModel.cityList[self.twoTableSelectRow];
        FYCountryModel *countryModel = cityModel.countryInfoList[row];
        text = countryModel.countryName;
    }
    
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    UIView* view = [self pickerView:pickerView viewForRow:row forComponent:component reusingView:nil];
//    view.backgroundColor = [UIColor greenColor];
    
    if (component == 0) {//省
        self.oneTableSelectRow = row;
        self.twoTableSelectRow = 0;
        self.threeTableSelectRow = 0;
    } else if (component == 1) {//市
        self.twoTableSelectRow = row;
        self.threeTableSelectRow = 0;
    } else {
        self.threeTableSelectRow = row;
    }
    [self.onePickerView reloadAllComponents];
}

#pragma mark - setters
- (void)setProvinceList:(NSArray<FYProvinceModel *> *)provinceList{
    _provinceList = provinceList;
    
    [self.onePickerView reloadAllComponents];
}
    
    
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide {
    [self removeFromSuperview];
}
//- (void)setDetailModel:(ServiceDetailModel *)detailModel{
//    _detailModel = detailModel;
//
//    self.titleLabel.text = detailModel.productSku.skuInfo[0].skuName;
//    NSInteger buttonCount = self.choiceButtons.count > detailModel.productSku.skuInfo[0].attrList.count ? detailModel.productSku.skuInfo[0].attrList.count : self.choiceButtons.count;
//    for (NSInteger i=0; i<buttonCount; i++) {
//        UIButton *tempButton = self.choiceButtons[i];
//        ServiceProductSkuInfoAttrModel *attrModel = detailModel.productSku.skuInfo[0].attrList[i];
//
//        tempButton.layer.cornerRadius = 4;
//        tempButton.layer.borderColor  = UIColorFromHEX(0xe5e5e5).CGColor;
//        tempButton.layer.borderWidth  = 1;
//
//        [tempButton setTitle:attrModel.attrName forState:UIControlStateNormal];
//        tempButton.hidden = NO;
//    }
//    if (buttonCount > 0) {
//        UIButton *tempButton = self.choiceButtons[0];
//        tempButton.layer.borderColor  = UIColorFromHEX(0x9accff).CGColor;
//        self.currentBtnIndex = 0;
//
//        NSString *currentPriceStr = @"0";
//        ServiceProductSkuInfoAttrModel *attrModel = detailModel.productSku.skuInfo[0].attrList[0];
//        for (ServiceProductSkuPriceModel *item in detailModel.productSku.priceList) {
//            if (item.attrIds == attrModel.attrId) {
//                currentPriceStr = item.price;
//                break;
//            }
//        }
//        self.currentPrice = [currentPriceStr floatValue];
//        self.moneyLabel.text = currentPriceStr;
//        self.countLabel.text = @"1";
//    }
//
//    if (detailModel.productInfo.saleWay == 1) {//售卖方式1购买2预约
//        [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
//    } else {
//        [self.buyButton setTitle:@"立即预约" forState:UIControlStateNormal];
//    }
//}

@end
