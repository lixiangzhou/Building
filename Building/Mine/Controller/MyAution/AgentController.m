//
//  AgentController.m
//  Building
//
//  Created by Mac on 2019/3/10.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "AgentController.h"
#import "AddressPickerView.h"

@interface AgentController ()<AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameFiled;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UILabel *authcationLabel;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
@property (weak, nonatomic) IBOutlet UIView *areaClick;

@property (weak, nonatomic) IBOutlet UITextField *companyLabel;

@property (weak, nonatomic) IBOutlet UITextField *postionlabless;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UIView *l3lineView;
@property (weak, nonatomic) IBOutlet UIView *guanxiaView;
@property (weak, nonatomic) IBOutlet UIView *l2loseView;
@property (weak, nonatomic) IBOutlet UILabel *noAllowLabel;


@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property(nonatomic,copy)NSString *token;//登录时有 ，接口参数
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic ,strong) AddressPickerView * pickerView;
@property(nonatomic,strong) NSString * proName;
@property(nonatomic,strong) NSString * cityName;
@property(nonatomic,assign)BOOL select;
@property(nonatomic,strong) NSArray *PArray;//省份
@property(nonatomic,assign)NSInteger proId;
@property(nonatomic,assign)NSInteger cityId;

@end

@implementation AgentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.proName=nil;
    self.cityName=nil;
    self.select=NO;
    self.proId=0;
    self.cityId=0;
    [self gainData];
    [self.view addSubview:self.pickerView];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationClick:)];
    [self.areaClick addGestureRecognizer:tapGesture];
    self.areaClick.userInteractionEnabled = YES;
    
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    
    
    UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yesClick:)];
    [self.yesLabel addGestureRecognizer:tapGesture0];
    self.yesLabel.userInteractionEnabled= YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noClick:)];
    [self.noLabel addGestureRecognizer:tapGesture1];
    self.noLabel.userInteractionEnabled= YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self gainData];
}

-(void)yesClick:(id)sender{
    [self yesBtn:sender];
}

-(void)noClick:(id)sender{
    [self noBtn:sender];
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    //[self.pickerView hide];
}


-(void)gainData{
    if (self.model.agentCompany) {
        [self.yesBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
        [self.noBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
        
        self.companyLabel.enabled = NO;
        self.postionlabless.enabled = YES;
        self.select=YES;
        
    }else{
        [self.yesBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
         [self.noBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
        
        self.companyLabel.enabled = NO;
        self.postionlabless.enabled = NO;
        self.select=NO;
    }

    //self.companyLabel.text = self.model.companyName;
    self.postionlabless.text=self.model.companyName;
    
    //NSLog(@"serviceAreaName:%@", self.model.serviceAreaName);
    if( self.model.serviceAreaName == nil )
        self.areaLabel.text=@"请选择管辖区域";
    else
        self.areaLabel.text=self.model.serviceAreaName;
    
    
    self.nameFiled.text=self.model.name;
    self.phoneLabel.text=self.model.mobile;
    self.authcationLabel.layer.borderWidth=1;
    self.authcationLabel.layer.cornerRadius=13;
    self.noAllowLabel.alpha = 0;

    if ([self.model.authStatus integerValue]==1) {
        self.authcationLabel.text=@"审核中...";
         //self.view.userInteractionEnabled=NO;
        self.confirmBtn.alpha=0;
        self.authcationLabel.textColor=[UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
        self.nameFiled.enabled = NO;
        self.postionlabless.enabled = NO;
        self.companyLabel.enabled = NO;
   
        
    }else if ([self.model.authStatus integerValue]==9){
        self.authcationLabel.text=@"已认证";
        //self.view.userInteractionEnabled=NO;
        self.authcationLabel.textColor=[UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
        self.nameFiled.enabled = NO;
        self.postionlabless.enabled = NO;
        self.confirmBtn.alpha=0;
        
    }else if ([self.model.authStatus integerValue]==-1){
        self.authcationLabel.text=@"未通过";
        [self.confirmBtn setTitle:@"重新认证" forState:UIControlStateNormal];
        self.authcationLabel.textColor=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1].CGColor);
        self.noAllowLabel.text = self.model.authRemark;
        self.noAllowLabel.alpha = 1;

    }else{
        self.authcationLabel.alpha=0;
       
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    NSString *cityId = [GlobalConfigClass shareMySingle].cityModel.cityId;
    if (cityId) {
        [params setObject:[GlobalConfigClass shareMySingle].cityModel.cityId forKey:@"cityId"];
    }
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    [MineNetworkService gainSelectHouseListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        if( self.select == YES )
        {
            CGRect f = self.l3lineView.frame;
            CGRect f1 = self.guanxiaView.frame;
            //NSLog(@"l3lineView x:%lf, y:%lf, w:%lf, h:%lf", self.l3lineView.frame.origin.x, self.l3lineView.frame.origin.y, self.l3lineView.frame.size.width, self.l3lineView.frame.size.height );
            //NSLog(@"guanxiaView x:%lf, y:%lf, w:%lf, h:%lf", self.guanxiaView.frame.origin.x, self.guanxiaView.frame.origin.y, self.guanxiaView.frame.size.width, self.guanxiaView.frame.size.height );
            
            f.origin.y += 50;
            f1.origin.y += 50;
            
            self.l3lineView.frame = f;
            self.guanxiaView.frame = f1;
            
            //NSLog(@"l3lineView x:%lf, y:%lf, w:%lf, h:%lf", self.l3lineView.frame.origin.x, self.l3lineView.frame.origin.y, self.l3lineView.frame.size.width, self.l3lineView.frame.size.height );
            //NSLog(@"guanxiaView x:%lf, y:%lf, w:%lf, h:%lf", self.guanxiaView.frame.origin.x, self.guanxiaView.frame.origin.y, self.guanxiaView.frame.size.width, self.guanxiaView.frame.size.height );
        }
    } failure:^(id  _Nonnull response) {
    }];
 }

- (AddressPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc]init];
        _pickerView.delegate = self;
        
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        _pickerView.isAutoOpenLast = YES;
    }
    
    return _pickerView;
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    self.areaLabel.text = [NSString stringWithFormat:@"%@ %@ ",province,city];
   //NSLog(@"addressLabel:%@,%@,%@",province,city,area);
    self.proName=province;
    self.cityName=city;

    [self.pickerView hide];
    //[self areaBtn:_addressBtn];
}
- (void)cancelBtnClick{
    //NSLog(@"点击了取消按钮");
    //[self areaBtn:_addressBtn];
    [self.pickerView hide];
}
//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //NSLog(@"touchesBegan");
}

- (IBAction)submitBtn:(id)sender {
    //NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *headerParams=[[NSMutableDictionary alloc]init];
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityListSuccess:^(NSArray *array) {
        weakSelf.PArray=array;
        //NSLog(@"datadic:%@",weakSelf.dataDict);
        //weakSelf.provincesArr=[weakSelf.dataDict objectForKey:@"provinceName"];
        for (FYProvinceModel *address in weakSelf.PArray) {
            for (FYCityModel *city in address.cityList){
                
                    
                    if ( [weakSelf.cityName isEqualToString:city.cityName] &&[weakSelf.proName isEqualToString:address.provinceName])
                        
                    {
                        weakSelf.proId=[address.provinceId intValue] ;
                        weakSelf.cityId=[city.cityId intValue];
                       
                    }
                    
                }
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        NSLog(@"失败");
    }];
    
    if(self.nameFiled.text == nil)
    {
        [self showHint:@"姓名未填写"];
        return;
    }
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    if (self.select==YES) {
        [params setObject:@(1) forKey:@"agentCompany"];
    }else{
        [params setObject:@(0) forKey:@"agentCompany"];
    }
    [params setObject:self.postionlabless.text forKey:@"companyName"];
    //[params setObject:self.postionlabless.text forKey:@"companyPost"];
    [params setObject:@(4) forKey:@"memberType"];
    [params setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.mobile forKey:@"mobile"];
    [params setObject:self.nameFiled.text forKey:@"name"];
    [params setObject:@[] forKey:@"selectedHouse"];
    
    [params setObject:[NSNumber numberWithInt:weakSelf.cityId] forKey:@"serviceArea"];
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    
         [paramsHeader setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
        
     __weak __typeof__ (self) wself = self;
    [MineNetworkService gainSubmitWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        NSLog(@"success");
        [wself showHint:response];
        
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
        
    }];
    
}

- (IBAction)yesBtn:(id)sender {
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        return;
    }
    [self.yesBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    
    [self.noBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    
    
    self.companyLabel.enabled = NO;
    self.postionlabless.enabled = YES;
    //NSLog(@"yesBtn");
    
    if ( self.select == YES )
        return;
    self.select=YES;
    
    CGRect f = _l3lineView.frame;
    CGRect f1 = _guanxiaView.frame;
    
    f.origin.y += 50;
    f1.origin.y += 50;

    _l3lineView.frame = f;
    _guanxiaView.frame = f1;
}

- (IBAction)noBtn:(id)sender {
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        return;
    }
    [self.yesBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.noBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];

    self.companyLabel.enabled = NO;
    self.postionlabless.enabled = NO;

    if ( self.select == NO )
        return;
    self.select=NO;

    CGRect f = _l3lineView.frame;
    CGRect f1 = _guanxiaView.frame;
    
    f.origin.y -= 50;
    f1.origin.y -= 50;
    
    _l3lineView.frame = f;
    _guanxiaView.frame = f1;
}

- (IBAction)areaBtn:(id)sender {
//    UIButton *btn=sender;
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [self.pickerView show];
//    }else{
//        [self.pickerView hide];
//    }
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        return;
    }
    [self.pickerView show];
}

-(void) locationClick:(id)sender {
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        return;
    }
    [self.pickerView show];
}

@end
