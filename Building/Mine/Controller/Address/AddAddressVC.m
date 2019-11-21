//
//  AddAddressVC.m
//  Building
//
//  Created by Macbook Pro on 2019/3/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "AddAddressVC.h"
#import "SelectAreaView.h"

@interface AddAddressVC ()<SelectAreaViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *personField;
@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButton;

@property (nonatomic, strong) SelectAreaView *buyView;
@property (strong, nonatomic) NSArray <FYProvinceModel *> *provinceList;
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property (nonatomic, copy)  NSString  *provinceId;//省份ID
@property (nonatomic, copy)  NSString  *cityId;//城市ID
@property (nonatomic, copy)  NSString  *countryId;///区县ID
@end

@implementation AddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if( self.editMode == 1 )
        self.navigationItem.title = @"编辑收货地址";
    else if( self.editMode == 2 )
        self.navigationItem.title = @"新增收货地址";
    else
        self.navigationItem.title = @"收货地址";

    self.provinceList = [[NSMutableArray alloc] init];
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    
    self.buyView = [[SelectAreaView alloc] init];
    self.buyView.delegate = self;
    
    if (self.addressModel != nil) {
        self.personField.text = self.addressModel.receiver;
        self.telField.text = self.addressModel.contact;
        self.addressField.text = self.addressModel.address;
        self.provinceId = self.addressModel.provinceId;
        self.cityId = self.addressModel.cityId;
        self.countryId = self.addressModel.countyId;
        
        self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@", self.addressModel.provinceName, self.addressModel.cityName, self.addressModel.countyName];
    }
    
    [self gainCityList];
}

#pragma mark - Request
//获取城市列表
- (void)gainCityList{
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityListSuccess:^(NSArray * _Nonnull citys) {
        weakSelf.provinceList = citys;
        weakSelf.buyView.provinceList = citys;
    } failure:^(id  _Nonnull response) {
        
    }];
}

//添加地址
- (void)requestAddAddressToServer
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.personField.text forKey:@"receiver"];//收货人
    [params setObject:self.telField.text forKey:@"contact"];//联系方式
    [params setObject:self.addressField.text forKey:@"address"];//详细地址
    [params setObject:self.provinceId forKey:@"provinceId"];//省份ID
    [params setObject:self.cityId forKey:@"cityId"];//城市ID
    [params setObject:self.countryId forKey:@"countryId"];//区县ID
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService addAddressWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
}

//更新地址
- (void)updateAddressToDefault
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.addressField.text forKey:@"address"];//详细地址
    [params setObject:self.addressModel.idStr forKey:@"addressId"];//地址ID
    [params setObject:self.cityId forKey:@"cityId"];//城市ID
    [params setObject:self.telField.text forKey:@"contact"];//联系方式
    [params setObject:self.countryId forKey:@"countryId"];//区县ID
    [params setObject:self.provinceId forKey:@"provinceId"];//省份ID
    [params setObject:self.personField.text forKey:@"receiver"];//收货人
//    [params setObject:@"true" forKey:@"setDefault"];//设置默认,传入true、或者留空
    
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    __weak __typeof__ (self) wself = self;
    [MineNetworkService updateAddressWithParams:params headerParams:paramsHeader Success:^(NSInteger code) {
        [wself.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    
}

#pragma mark - Action
//创建地址
- (IBAction)addAddressButtonAction:(id)sender {
    [self.view endEditing:YES];
    if (self.personField.text.length == 0){
        [self showHint:@"请填写收货人姓名"];
        return;
    }
    if (self.telField.text.length == 0){
        [self showHint:@"请填写收货人联系电话"];
        return;
    }else if ([GlobalUtil checkMobileNumberTrue:self.telField.text] == NO) {
        [self showHint:@"请输入正确手机号"];
        return;
    }
    if (self.addressField.text.length == 0){
        [self showHint:@"请填写收货人详细地址"];
        return;
    }
    
    if (self.addressModel != nil) {//修改
        [self updateAddressToDefault];
    } else {
        [self requestAddAddressToServer];
    }
    
}
//选择地区
- (IBAction)areaTapAction:(id)sender {
    [self.view endEditing:YES];

    if (self.provinceList.count > 0) {
        [self.buyView show];
    } else {
        [self showHint:@"未获取到地区数据，请稍后"];
    }
}
#pragma mark - SelectAreaViewDelegate
- (void)coverViewTapAction{
    [self.buyView hide];;
}

- (void)cancelSelectArea{
    [self.buyView hide];;
}
- (void)doneSelectOneComponentRow:(NSInteger)oneRow twoComponentRow:(NSInteger)twoRow threeComponentRow:(NSInteger)threeRow{
    FYProvinceModel *provinceModel = self.provinceList[oneRow];
    FYCityModel *cityModel = provinceModel.cityList[twoRow];
    FYCountryModel *countryModel = cityModel.countryInfoList[threeRow];
    
    self.provinceId = provinceModel.provinceId;
    self.cityId = cityModel.cityId;
    self.countryId = countryModel.countryId;
    
    self.areaLabel.text = [NSString stringWithFormat:@"%@%@%@", provinceModel.provinceName, cityModel.cityName, countryModel.countryName];
    
    [self.buyView hide];;
}

@end
