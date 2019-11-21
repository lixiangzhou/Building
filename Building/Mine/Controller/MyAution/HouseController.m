//
//  HouseController.m
//  Building
//
//  Created by Mac on 2019/3/10.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "HouseController.h"
#import "LMJDropdownMenu.h"


@interface HouseController ()<LMJDropdownMenuDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameFiled;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *companyLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *postionLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;

@property (weak, nonatomic) IBOutlet UILabel *authcationLabel;

@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property(nonatomic,strong)NSMutableArray *array;//接口参数 房源数组id
@property(nonatomic,strong)NSMutableArray *idArray;
@property(nonatomic,assign)BOOL agentCompany;//接口参数 是否有经济公司
@property(nonatomic,copy)NSString *companyName;//接口参数 公司名称
@property(nonatomic,copy)NSString *mobile;//接口参数 手机登录时有
@property(nonatomic,assign)NSInteger houseId;
@property(nonatomic,strong)NSMutableArray *buildMArray;//楼盘名称
@property(nonatomic,strong)NSMutableArray *buildNoArray;//楼盘号名称
@property(nonatomic,strong)NSMutableArray *unitNoArray;//单元名称
@property(nonatomic,strong)NSMutableArray *floorNoArray;//楼层名称
@property(nonatomic,strong)NSMutableArray *roomNoArray;//房间名称
@property(nonatomic,strong)LMJDropdownMenu * buildingMenu;
@property(nonatomic,strong)LMJDropdownMenu * buildingNoMenu;
@property(nonatomic,strong)LMJDropdownMenu * unitNoMenu;
@property(nonatomic,strong)LMJDropdownMenu * floorNoMenu;
@property(nonatomic,strong)LMJDropdownMenu * roomNoMenu;
@property(nonatomic,strong)buildingListModel    *buildingData;
@property(nonatomic,strong)buildingNoListModel  *buildingNoData;
@property(nonatomic,strong)unitNoListModel      *unitNoListData;
@property(nonatomic,strong)floorNoListModel     *floorNoListData;
@property(nonatomic,strong)roomNoListModel      *roomNoListData;

@property(nonatomic,strong)NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray<selectedHouseModel *> *dataArray;
@property(nonatomic,strong)selectedHouseModel *sha;
@property (weak, nonatomic) IBOutlet UIView *houseView;

@property (weak, nonatomic) IBOutlet UIView *roomTableViewTo;
@property (weak, nonatomic) IBOutlet UIView *i00View;
@property (weak, nonatomic) IBOutlet UIView *l6View;
@property (weak, nonatomic) IBOutlet UILabel *noAllowLabel;


@end

@implementation HouseController

static UIView *lui;
static UIView *lineview;
static UIView *companyview;
static UITextField *txci;
static UITextField *txzw;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.idArray=[[NSMutableArray alloc] init];
    self.nameArray=[[NSMutableArray alloc] init];
    self.array=[[NSMutableArray alloc] init];
    self.buildMArray=[[NSMutableArray alloc] init];
    self.buildNoArray=[[NSMutableArray alloc] init];
    self.unitNoArray=[[NSMutableArray alloc] init];
    self.floorNoArray=[[NSMutableArray alloc] init];
    self.roomNoArray=[[NSMutableArray alloc] init];
    self.dataArray=[[NSMutableArray alloc]init];
    self.sha = [[selectedHouseModel alloc]init];
    
    
    float weight = ScreenWidth * 302 / 375;
    float lease = ScreenWidth - weight - 60;
    float weightTo = (weight-(ScreenWidth * 44 / 375))/2;
    float leaseTo = ScreenWidth - weightTo - lease;
    
    self.buildingMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 10, weight, 34)];
    self.buildingMenu.selectNumber = -1;
    [self.buildingMenu setMenuTitles:nil rowHeight:30];
    self.buildingMenu.delegate = self;
    [self.houseView addSubview:self.buildingMenu];
    [self.view bringSubviewToFront:self.buildingMenu];
    
    self.buildingNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 64, weightTo, 34)];
    //[self.buildingNoMenu setFrame:CGRectMake(60, 64, weightTo, 34)];
    self.buildingNoMenu.selectNumber = -1;
    [self.buildingNoMenu setMenuTitles:nil rowHeight:30];
    self.buildingNoMenu.delegate = self;
    [self.houseView addSubview:self.buildingNoMenu];
    [self.houseView bringSubviewToFront:self.buildingNoMenu];
    
    //[self.view bringSubviewToFront:self.houseView];
    
    
    UILabel *laba = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 197 / 375, 72, ScreenWidth * 30 / 375, 18 )];
    laba.text = @"单元";
    laba.font = [UIFont systemFontOfSize:13];
    laba.textColor = UIColorFromHEX(0x6e6e6e);
    
    [self.houseView addSubview: laba];
    self.unitNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(leaseTo, 64, weightTo, 34)];
    [self.unitNoMenu setMenuTitles:nil rowHeight:30];
    self.unitNoMenu.selectNumber = -1;
    self.unitNoMenu.delegate = self;
    [self.view bringSubviewToFront:self.unitNoMenu];
    
    [self.houseView addSubview:self.unitNoMenu];
    
    self.floorNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 120, weightTo, 34)];
    [self.floorNoMenu setMenuTitles:nil rowHeight:30];
    self.floorNoMenu.selectNumber = -1;
    self.floorNoMenu.delegate = self;
    [self.view bringSubviewToFront:self.floorNoMenu];
    [self.houseView addSubview:self.floorNoMenu];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 197 / 375, 128, ScreenWidth * 30 / 375, 18 )];
    lab.text = @"房间";
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = UIColorFromHEX(0x6e6e6e);
    [self.houseView addSubview: lab];
    
    self.roomNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(leaseTo, 120, weightTo, 34)];
    [ self.roomNoMenu setMenuTitles:nil rowHeight:30];
    self.roomNoMenu.selectNumber = -1;
    self.roomNoMenu.delegate = self;
    [self.view bringSubviewToFront:self.roomNoMenu];
    [self.houseView addSubview: self.roomNoMenu];
    
    self.buildingNoMenu.clipsToBounds = NO;
    self.buildingNoMenu.layer.masksToBounds = NO;
    //    self.houseView.clipsToBounds = NO;
    
    
    //[self.buildMArray addObject:@"build"];
    [self gainHData];
    
#if 0
    //房间列表
    float x=0;
    float y=_l6View.frame.origin.y + _l6View.frame.size.height;
    float w = ScreenWidth;
    float h = 58 * self.model.selectedHouse.count+1;
    [lui removeFromSuperview];
    CGSize size = CGSizeMake(w, h);
    lui = [[UIView alloc]initWithFrame:CGRectMake( x, y, size.width, size.height )];
    
    if( self.model.selectedHouse.count > 0)
    {
        int i=0;
        for (selectedHouseModel *sh in self.model.selectedHouse)
        {
            y = i*58 + 10;
            self.houseId=[sh.houseId integerValue];
            [self.idArray addObject:@(self.houseId)];
            [self.nameArray addObject:sh.title];
            [self ConfigHouselabel:sh.title startx:(x+24) starty:y ];
            [ self configHouseLabelImage:sh.title Cnt:i ui:lui];
            
            i++;
        }
    }
    [self.i00View addSubview:lui ];
    [self lineView:lui ];
    [self companyView:lineview];
#endif
    //NSLog(@"sMArray:%@",self.buildMArray);
    // Do any additional setup after loading the view from its nib.
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
        self.nameFiled.text=self.model.name;
    
    self.phoneLabel.text=self.model.mobile;
    //NSLog(@"phone:%@",self.model.mobile);
    self.houseLabel.layer.borderWidth=1;
    self.houseLabel.layer.cornerRadius=4;
    self.houseLabel.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
    self.houseLabel.text=self.model.selectedHouse[0].title;
    self.authcationLabel.layer.borderWidth=1;
    self.authcationLabel.layer.cornerRadius=13;
    
    txci.text = self.model.companyName;
    txzw.text = self.model.companyPost;
    self.noAllowLabel.alpha = 0;
    
    if ([self.model.authStatus integerValue]==1) {
        self.authcationLabel.text=@"审核中...";
        //self.view.userInteractionEnabled=NO;
        self.authcationLabel.textColor=[UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
        
        [self theShowConfig];
    }else if ([self.model.authStatus integerValue]==9){
        self.authcationLabel.text=@"已认证";
        //self.view.userInteractionEnabled=NO;
        self.authcationLabel.textColor=[UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
        
        [self theShowConfig];
        
    }else if ([self.model.authStatus integerValue]==-1){
        self.authcationLabel.text=@"未通过";
        [self.confirmBtn setTitle:@"重新认证" forState:UIControlStateNormal];
        self.authcationLabel.textColor=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1].CGColor);
        
        self.noAllowLabel.text = self.model.authRemark;
        self.noAllowLabel.alpha = 1;
        self.buildingNoMenu.userInteractionEnabled = YES;
        self.buildingMenu.userInteractionEnabled = YES;
        self.unitNoMenu.userInteractionEnabled = YES;
        self.floorNoMenu.userInteractionEnabled = YES;
        self.roomNoMenu.userInteractionEnabled = YES;
        
        [self theaddConfig];
    }else{
        self.authcationLabel.alpha=0;
        self.houseLabel.alpha=0;
        
        self.buildingNoMenu.userInteractionEnabled = YES;
        self.buildingMenu.userInteractionEnabled = YES;
        self.unitNoMenu.userInteractionEnabled = YES;
        self.floorNoMenu.userInteractionEnabled = YES;
        self.roomNoMenu.userInteractionEnabled = YES;
        [self theaddConfig];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}
-(void) theShowConfig{
    //房间列表
    float x=0;
    float y=_l6View.frame.origin.y + _l6View.frame.size.height;
    float w = ScreenWidth;
    float h = 58 * self.model.selectedHouse.count+1;
    [lui removeFromSuperview];
    CGSize size = CGSizeMake(w, h);
    lui = [[UIView alloc]initWithFrame:CGRectMake( x, y, size.width, size.height )];
    
    if( self.model.selectedHouse.count > 0)
    {
        int i=0;
        for (selectedHouseModel *sh in self.model.selectedHouse)
        {
            y = i*58 + 10;
            self.houseId=[sh.houseId integerValue];
            [self.idArray addObject:@(self.houseId)];
            [self.nameArray addObject:sh.title];
            [self ConfigHouselabel:sh.title startx:(x+24) starty:y ];
            i++;
        }
    }
    [self.i00View addSubview:lui ];
    [self lineView:lui ];
    [self companyView:lineview];
    
    self.confirmBtn.alpha=0;
    self.nameFiled.enabled = NO;
    self.buildingNoMenu.userInteractionEnabled = NO;
    self.buildingMenu.userInteractionEnabled = NO;
    self.unitNoMenu.userInteractionEnabled = NO;
    self.floorNoMenu.userInteractionEnabled = NO;
    self.roomNoMenu.userInteractionEnabled = NO;
}

-(void) theaddConfig{
    //房间列表
    float x=0;
    float y=_l6View.frame.origin.y + _l6View.frame.size.height;
    float w = ScreenWidth;
    float h = 58 * self.model.selectedHouse.count+1;
    [lui removeFromSuperview];
    CGSize size = CGSizeMake(w, h);
    lui = [[UIView alloc]initWithFrame:CGRectMake( x, y, size.width, size.height )];
    
    if( self.model.selectedHouse.count > 0)
    {
        int i=0;
        for (selectedHouseModel *sh in self.model.selectedHouse)
        {
            y = i*58 + 10;
            self.houseId=[sh.houseId integerValue];
            [self.idArray addObject:@(self.houseId)];
            [self.nameArray addObject:sh.title];
            //[self ConfigHouselabel:sh.title startx:(x+24) starty:y ];
            [ self configHouseLabelImage:sh.title Cnt:i ui:lui];
            
            i++;
        }
    }
    [self.i00View addSubview:lui ];
    [self lineView:lui ];
    [self companyView:lineview];
    
    
}


- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
}

-(void)lineView:(UIView *)preui{
    float w = ScreenWidth;
    float h = 10;
    CGRect pframe = preui.frame;
    float x = pframe.origin.x;
    float y = pframe.origin.y + pframe.size.height;
    //CGSize size = CGSizeMake(w, h);
    lineview = [[UIView alloc]initWithFrame:CGRectMake( x, y, w, h )];
    lineview.backgroundColor = UIColorFromHEX(0xeeeeee);
    [self.i00View addSubview:lineview ];
}
-(void)companyView:(UIView *)preui{
    float w = ScreenWidth;
    float h = 130;
    CGRect pframe = preui.frame;
    float x = pframe.origin.x;
    float y = pframe.origin.y + pframe.size.height;
    //CGSize size = CGSizeMake(w, h);
    companyview = [[UIView alloc]initWithFrame:CGRectMake( x, y, w, h )];
    companyview.backgroundColor = [UIColor whiteColor];
    
    UILabel *companyInfo = [[UILabel alloc] initWithFrame:CGRectMake( 24, 8, 60, 18 )];
    companyInfo.text=@"公司信息";
    companyInfo.font = [UIFont systemFontOfSize:13];
    companyInfo.textColor=([UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]);
    [companyview addSubview:companyInfo ];
    
    UILabel *companyName = [[UILabel alloc] initWithFrame:CGRectMake( 24, 46, 60, 18 )];
    companyName.text=@"公司名称";
    companyName.font = [UIFont systemFontOfSize:13];
    companyName.textColor=([UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]);
    [companyview addSubview:companyName ];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake( 87, 80, ScreenWidth*273/375, 1 )];
    view.backgroundColor = UIColorFromHEX(0xf5f5f5);
    [companyview addSubview:view ];
    
    UILabel *companyZhiwei = [[UILabel alloc] initWithFrame:CGRectMake( 24, 95, 60, 18 )];
    companyZhiwei.text=@"公司职位";
    companyZhiwei.font = [UIFont systemFontOfSize:13];
    companyZhiwei.textColor=([UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]);
    [companyview addSubview:companyZhiwei ];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake( 85, 8, 60, 18 )];
    label.text=@"(非必填)";
    label.textColor = UIColorFromHEX(0x999999);
    label.font = [UIFont systemFontOfSize:13];
    [companyview addSubview:label ];
    
    float width = ScreenWidth*270/375;
    txci = [[UITextField alloc] initWithFrame:CGRectMake( 96, 46, width, 18 )];
    [txci setTextColor:UIColorFromHEX(0x999999)];
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        txci.text = self.model.companyName;
        txci.enabled = NO;
        
    }else{
        txci.placeholder = @"请输入您的公司";
    }
    [companyview addSubview:txci ];
    
    txzw = [[UITextField alloc] initWithFrame:CGRectMake( 96, 95, width, 18 )];
    [txzw setTextColor:UIColorFromHEX(0x999999)];
    if (([self.model.authStatus integerValue]==1) || ([self.model.authStatus integerValue]==9))
    {
        txzw.text = self.model.companyPost;
        txzw.enabled = NO;
    }else{
        txzw.placeholder = @"请输入您的职位";
    }
    [companyview addSubview:txzw ];
    
    [self.i00View addSubview:companyview ];
    
    //    UIView *tv = [[UIView alloc]initWithFrame:CGRectMake( x, y+h, w, 400 )];
    //    tv.backgroundColor = [UIColor redColor];
    //    [self.i00View addSubview:tv ];
}

-(void)gainHData{
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    //NSLog(@"gainHData");
    [params setObject:[GlobalConfigClass shareMySingle].cityModel.cityId forKey:@"cityId"];
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    // __weak __typeof__ (self) wself = self;
    [MineNetworkService gainSelectHouseListWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        //NSLog(@"respose:%@",response);
        
        self.array=response;
        for (buildingListModel *model in self.array) {
            [self.buildMArray addObject:model.buildingName];
            // NSLog(@"buildName:%@",self.buildMArray);
            
        }
        [self.buildingMenu setMenuTitles:self.buildMArray rowHeight:30];
        
        [self.buildingNoMenu setMenuTitles:nil rowHeight:30];
        [self.unitNoMenu setMenuTitles:nil rowHeight:30];
        [self.floorNoMenu setMenuTitles:nil rowHeight:30];
        [ self.roomNoMenu setMenuTitles:nil rowHeight:30];
    } failure:^(id  _Nonnull response) {
        
        NSLog(@"获取respose失败");
    }];
    
}
- (IBAction)submitBtn:(id)sender {
    
    if(self.nameFiled.text == nil)
    {
        [self showHint:@"姓名未填写"];
        return;
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@(0) forKey:@"agentCompany"];
    [params setObject:txci.text forKey:@"companyName"];
    [params setObject:txzw.text forKey:@"companyPost"];
    [params setObject:@(3) forKey:@"memberType"];
    [params setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.mobile forKey:@"mobile"];
    [params setObject:self.nameFiled.text forKey:@"name"];
    [params setObject:self.idArray forKey:@"selectedHouse"];
    [params setObject:@"" forKey:@"serviceArea"];
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    
    
    [paramsHeader setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    
    NSLog(@"token:%@",[GlobalConfigClass shareMySingle].userAndTokenModel.token);
    __weak __typeof__ (self) wself = self;
    //NSLog(@"params:%@",params);
    [MineNetworkService gainSubmitWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        //NSLog(@"success");
        [wself showHint:response];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
        [wself showHint:response];
        NSLog(@"fail");
    }];
}

//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //NSLog(@"touchesBegan");
}

#pragma mark - LMJDropdownMenu Delegate
- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    //    NSLog(@"selectNumber:%ld", number);
    //    NSLog(@"self.buildingMenu.selectNumber:%ld", self.buildingMenu.selectNumber);
    //    NSLog(@"menu:%@", menu);
    //    NSLog(@"buildingMenu:%@", self.buildingMenu);
    if (([self.model.authStatus integerValue]==9))
        return;
    if( [menu isEqual:self.buildingMenu] ){
        [self buildingSet:self.buildingMenu selectedCellNumber:number];
    }else if( ([menu isEqual:self.buildingNoMenu]) ){
        [self buildingNoSet:self.buildingNoMenu selectedCellNumber:number];
    }else if( ([menu isEqual:self.unitNoMenu]) ){
        [self unitNoSet:self.unitNoMenu selectedCellNumber:number];
    }else if(([menu isEqual:self.floorNoMenu]) ){
        [self floorNoSet:self.floorNoMenu selectedCellNumber:number];
    }else if( ([menu isEqual:self.roomNoMenu]) ){
        [self roomNoSet:self.roomNoMenu selectedCellNumber:number];
    }
}

- (void)dropdownMenuWillShow:(LMJDropdownMenu *)menu{
    //NSLog(@"--将要显示--");
}
- (void)dropdownMenuDidShow:(LMJDropdownMenu *)menu{
    //NSLog(@"--已经显示--");
}

- (void)dropdownMenuWillHidden:(LMJDropdownMenu *)menu{
    //NSLog(@"--将要隐藏--");
}
- (void)dropdownMenuDidHidden:(LMJDropdownMenu *)menu{
    //NSLog(@"--已经隐藏--");
}

- (void)clearMenuSelect:(LMJDropdownMenu *)menu arrayData:(NSMutableArray *)array;
{
    //    menu.selectNumber = -1;
    //    [menu setMenuTitles:nil rowHeight:30];
    [menu clearData];
    [array removeAllObjects];
}

- (void)SetMenuSelect:(LMJDropdownMenu *)menu arrayData:(NSMutableArray *)array;{
    [menu setMenuTitles:array rowHeight:30];
}
//1
- (void)buildingSet:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    NSLog(@"buildingSet:%ld, %ld", menu.selectNumber, number);
    if( number != menu.selectNumber )
    {
        //先清除所有下级数据
        [self clearMenuSelect:self.buildingNoMenu arrayData:self.buildNoArray];
        [self clearMenuSelect:self.unitNoMenu arrayData:self.unitNoArray];
        [self clearMenuSelect:self.floorNoMenu arrayData:self.floorNoArray];
        [self clearMenuSelect:self.roomNoMenu arrayData:self.roomNoArray];
        
        //第二级数据获得
        buildingListModel *building = self.array[number];
        for (buildingNoListModel *nmodel in building.buildingNoList) {
            [self.buildNoArray addObject:nmodel.buildingNo];
            //NSLog( @"buildingNo:%@", nmodel.buildingNo );
        }
        
        //第一级动作获得行号
        menu.selectNumber = number;
        self.buildingData = building;
        [self SetMenuSelect:self.buildingNoMenu arrayData:self.buildNoArray];
    }
}
//2
- (void)buildingNoSet:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    if( number != menu.selectNumber )
    {
        //先清除所有下级数据
        [self clearMenuSelect:self.unitNoMenu arrayData:self.unitNoArray];
        [self clearMenuSelect:self.floorNoMenu arrayData:self.floorNoArray];
        [self clearMenuSelect:self.roomNoMenu arrayData:self.roomNoArray];
        
        //第三级数据获得
        NSInteger i=0;
        for (buildingNoListModel *nmodel in self.buildingData.buildingNoList) {
            if( i == number )
            {
                for (unitNoListModel *uModel in nmodel.unitNoList){
                    [self.unitNoArray addObject:uModel.unitNo];
                }
                //第二级动作获得行号
                menu.selectNumber = number;
                self.buildingNoData = nmodel;
                [self SetMenuSelect:self.unitNoMenu arrayData:self.unitNoArray];
                break;
            }
            i++;
        }
    }
}
//3
- (void)unitNoSet:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    if( number != menu.selectNumber )
    {
        //先清除所有下级数据
        [self clearMenuSelect:self.floorNoMenu arrayData:self.floorNoArray];
        [self clearMenuSelect:self.roomNoMenu arrayData:self.roomNoArray];
        
        //第三级数据获得
        NSInteger i=0;
        for (unitNoListModel *uModel in self.buildingNoData.unitNoList) {
            if( i == number )
            {
                for ( floorNoListModel *fModel in uModel.floorNoList){
                    [self.floorNoArray addObject:fModel.floorNo];
                }
                
                //第三级动作获得行号
                menu.selectNumber = number;
                self.unitNoListData = uModel;
                [self SetMenuSelect:self.floorNoMenu arrayData:self.floorNoArray];
                break;
            }
            i++;
        }
    }
}

//4
- (void)floorNoSet:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    if( number != menu.selectNumber )
    {
        //先清除所有下级数据
        [self clearMenuSelect:self.roomNoMenu arrayData:self.roomNoArray];
        
        //第四级数据获得
        NSInteger i=0;
        for (floorNoListModel *fModel in self.unitNoListData.floorNoList) {
            if( i == number )
            {
                for ( roomNoListModel *rModel in fModel.roomNoList){
                    [self.roomNoArray addObject:rModel.roomNo];
                }
                
                //第四级动作获得行号
                menu.selectNumber = number;
                self.floorNoListData = fModel;
                [self SetMenuSelect:self.roomNoMenu arrayData:self.roomNoArray];
                break;
            }
            i++;
        }
    }
}


//5
- (void)roomNoSet:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
    if( number != menu.selectNumber )
    {
        //第五级数据获得
        NSInteger i=0;
        for (roomNoListModel *rModel in self.floorNoListData.roomNoList) {
            if( i == number )
            {
                //第五级动作获得行号
                menu.selectNumber = number;
                self.roomNoListData = rModel;
                
                self.houseId=[rModel.houseId integerValue];
                //[self.idArray removeAllObjects];
                [self.idArray addObject:@(self.houseId)];
                [self.nameArray addObject:rModel.roomName];
                //
                //                NSUInteger n = 0;
                //                if( self.idArray.count > 0 )
                //                    n = self.idArray.count - 1;
                //
                //                [ self configHouseLabelImage:rModel.roomName Cnt:n];
                //NSLog(@"rModel-5 sh:%@,%@", rModel.roomName, rModel.houseId );
                
                //self.sha.houseId = rModel.houseId;
                //self.sha.title = rModel.roomName;
                selectedHouseModel *sha = [[selectedHouseModel alloc] init];
                sha.houseId = rModel.houseId;
                sha.title = rModel.roomName;
                //NSLog(@"roomNoSet-5 sh:%@,%@", self.sha.title, self.sha.houseId );
                NSUInteger n = self.idArray.count;
                
                //                for (UIView *view in [self.roomTableViewTo subviews]){
                //                    [view removeFromSuperview];
                //                }
                float x=0;
                float y=391;
                float w = ScreenWidth;
                float h = 58 * n;
                CGSize size = CGSizeMake(w, h);
                [lui removeFromSuperview];
                lui = [[UIView alloc]initWithFrame:CGRectMake( x, y, size.width, size.height )];
                //lui.backgroundColor = [UIColor redColor];
                
                
                //self.roomTableViewTo.frame = CGRectMake( self.roomTableViewTo.frame.origin.x, self.roomTableViewTo.frame.origin.y, size.width, size.height );
                
                [ self tableArrayAdd:sha ui:lui];
                [self.i00View addSubview:lui ];
                [self redrawView];
                
                break;
            }
            i++;
        }
    }
}

-(void)redrawView{
    CGRect pframe = lui.frame;
    float y = pframe.origin.y + pframe.size.height;
    
    CGRect lineframe = CGRectMake( lineview.frame.origin.x,y, lineview.frame.size.width, lineview.frame.size.height );
    lineview.frame = lineframe;
    
    y = lineview.frame.origin.y + lineview.size.height;
    CGRect companyFrame = CGRectMake( companyview.frame.origin.x,y, companyview.frame.size.width, companyview.frame.size.height );
    companyview.frame = companyFrame;
}

-(void)configHouseLabelImage:(NSString *)name Cnt:(NSUInteger)n ui:(UIView *)views{
    float x = 24;
    float y = n*42 + 9;
    
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"  %@  ", name];
    label.textColor = UIColorFromHEX(0x6e6e6e);
    label.font = [UIFont systemFontOfSize:13];
    CGSize maxSize = CGSizeMake(300, 30);
    CGSize expect = [label sizeThatFits:maxSize];
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 4;
    label.layer.borderColor = [UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    label.backgroundColor = UIColorFromHEX(0xeff7ff);
    label.numberOfLines = 0;
    label.lineBreakMode =NSLineBreakByTruncatingTail;
    //label.textAlignment = UITextAlignmentLeft;
    if( expect.width >= (ScreenWidth - x - 4) ){
        expect.width = (ScreenWidth - x - 4);
        expect.height = 60;
    }
    else{
        expect.height = 30;
    }
    label.frame = CGRectMake( x, y, expect.width, expect.height );
    [views addSubview:label];
    
    UIImageView *deleteImg = [[UIImageView alloc] init];
    [deleteImg setImage:[UIImage imageNamed:@"delete"]];
    deleteImg.userInteractionEnabled = YES;
    float dt = 8;
    deleteImg.frame = CGRectMake( x+expect.width-dt, y-dt, 16, 16 );
    [deleteImg setTag:1000+n];
    
    UITapGestureRecognizer *imgTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchOn:)];
    //imgTouch.view.tag = 1000+n;
    [deleteImg addGestureRecognizer:imgTouch];
    [views addSubview:deleteImg];
    
}

-(void)imgTouchOn:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    //NSLog(@"imgTouchOn:%ld", tag );
    
    tag = tag - 1000;
    
    //NSString * str = [self.nameArray objectAtIndex:tag];
    //NSLog(@"idArray:%@", str );
    
    [self.idArray removeObjectAtIndex:tag];
    [self.nameArray removeObjectAtIndex:tag];
    [self.dataArray removeObjectAtIndex:tag];
    self.roomNoMenu.selectNumber = -1;
    
    for (UIView *view in [lui subviews]){
        [view removeFromSuperview];
    }
    
    for( int i=0; i<self.idArray.count; i++ )
    {
        NSString * str = [self.nameArray objectAtIndex:i];
        [ self configHouseLabelImage:str Cnt:i ui:lui];
    }
    
    CGRect pframe = lui.frame;
    float h = pframe.size.height - 58;
    lui.frame = CGRectMake( lui.frame.origin.x,lui.frame.origin.y, lineview.frame.size.width, h );
    
    [self redrawView];
    
}


- (void)tableArrayAdd:(selectedHouseModel *) sh ui:(UIView *)views{
    //NSLog(@"tableArrayAdd sh:%@,%@", sh.title, sh.houseId );
    [self.dataArray addObject:(selectedHouseModel *)sh];
    NSUInteger n = 0;
    if( self.idArray.count > 0 )
        n = self.idArray.count - 1;
    
    //[self configHouseLabelImage:sh.title Cnt:n];
    for( int i=0; i<self.idArray.count; i++ )
    {
        NSString * str = [self.nameArray objectAtIndex:i];
        [ self configHouseLabelImage:str Cnt:i ui:views];
    }
}

-(void) ConfigHouselabel:(NSString *)name startx:(float)x starty:(float)y{
    UILabel * label = [[UILabel alloc] init];//initWithFrame:CGRectMake(24, 10, 200, 30)];
    label.text = [NSString stringWithFormat:@"  %@  ", name];
    label.textColor = UIColorFromHEX(0x6e6e6e);
    label.font = [UIFont systemFontOfSize:13];
    
    CGSize maxSize = CGSizeMake(300, 30);
    CGSize expect = [label sizeThatFits:maxSize];
    
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 4;
    label.layer.borderColor = [UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    
    label.backgroundColor = UIColorFromHEX(0xeff7ff);//[UIColor colorWithRed:239/255.0 green:247/255.0 blue:255/255.0 alpha:1];
    label.numberOfLines = 0;
    label.lineBreakMode =NSLineBreakByTruncatingTail;
    label.textAlignment = UITextAlignmentLeft;
    
    //NSLog(@"label x:%lf, y:%lf, w:%lf, h:%lf", x, y, expect.width, expect.height );
    if( expect.width >= (ScreenWidth - x - 4) )
    {
        expect.width = (ScreenWidth - x - 4);
        expect.height = 60;
    }
    else{
        expect.height = 30;
    }
    //NSLog(@"label x:%lf, y:%lf, w:%lf, h:%lf", x, y, expect.width, expect.height );
    
    label.frame = CGRectMake( x, y, expect.width, expect.height );
    
    [lui addSubview:label];
}

@end
