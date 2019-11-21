//
//  ProprietorController.m
//  Building
//
//  Created by Mac on 2019/3/10.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "ProprietorController.h"
#import "LMJDropdownMenu.h"
#import <UIKit/UILabel.h>
#import "SDCycleScrollView.h"

@interface ProprietorController ()<LMJDropdownMenuDelegate, SDCycleScrollViewDelegate>
@property (nonatomic, assign) float cycleScrollViewheight;


@property (weak, nonatomic) IBOutlet UITextField *nameFiled;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *authcationLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, copy)  NSString  *token;//header传参,登录后有
@property(nonatomic,strong)NSMutableArray *array;//接口参数 房源数组id

@property(nonatomic,strong)NSMutableArray *buildingMenuArray;
@property(nonatomic,strong)NSMutableArray *buildingNoMenuArray;
@property(nonatomic,strong)NSMutableArray *unitNoMenuArray;
@property(nonatomic,strong)NSMutableArray *floorNoMenuArray;
@property(nonatomic,strong)NSMutableArray *roomNoMenuArray;

@property(nonatomic,strong)NSMutableArray *idArray;
@property(nonatomic,strong)NSMutableArray *nameArray;

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
@property (weak, nonatomic) IBOutlet UILabel *loupanPoint;
@property (weak, nonatomic) IBOutlet UILabel *louhaoPoint;
@property (weak, nonatomic) IBOutlet UILabel *loucenPoint;
@property (weak, nonatomic) IBOutlet UILabel *danyuanPoint;
@property (weak, nonatomic) IBOutlet UILabel *fangjianPoint;
@property (weak, nonatomic) IBOutlet UIView *houseView;
@property (weak, nonatomic) IBOutlet UILabel *yezhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailirenLabel;

@property (weak, nonatomic) IBOutlet UIButton *yezhuBtn;
@property (weak, nonatomic) IBOutlet UIButton *dailirenBtn;

@property(nonatomic,assign)NSInteger memberType;
@property (weak, nonatomic) IBOutlet UIView *houseSelectView;


@end

@implementation ProprietorController

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
//    self.buildingMenu=[[LMJDropdownMenu alloc] init];
//    self.buildingMenu.selectNumber = -1;
//    self.buildingNoMenu=[[LMJDropdownMenu alloc] init];
//    self.buildingNoMenu.selectNumber = -1;
//    self.unitNoMenu=[[LMJDropdownMenu alloc] init];
//    self.unitNoMenu.selectNumber = -1;
//    self.floorNoMenu=[[LMJDropdownMenu alloc] init];
//    self.floorNoMenu.selectNumber = -1;
//    self.roomNoMenu=[[LMJDropdownMenu alloc] init];
//    self.roomNoMenu.selectNumber = -1;
    float weight = ScreenWidth * 302 / 375;
    float lease = ScreenWidth - weight - 60;
    float weightTo = (weight-(ScreenWidth * 44 / 375))/2;
    float leaseTo = ScreenWidth - weightTo - lease;
    self.memberType = 2;
    
    self.buildingMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 10, weight, 34)];
    self.buildingMenu.selectNumber = -1;
    [self.buildingMenu setMenuTitles:nil rowHeight:30];

    self.buildingMenu.delegate = self;
    [self.houseView addSubview:self.buildingMenu];

    self.buildingNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 64, weightTo, 34)];
    self.buildingNoMenu.selectNumber = -1;
    [self.buildingNoMenu setMenuTitles:nil rowHeight:30];
    self.buildingNoMenu.delegate = self;
    [self.houseView addSubview:self.buildingNoMenu];
    
    UILabel *laba = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth * 197 / 375, 72, ScreenWidth * 30 / 375, 18 )];
    laba.text = @"单元";
    laba.font = [UIFont systemFontOfSize:13];
    laba.textColor = UIColorFromHEX(0x6e6e6e);

    [self.houseView addSubview: laba];
    self.unitNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(leaseTo, 64, weightTo, 34)];
    [self.unitNoMenu setMenuTitles:nil rowHeight:30];
    self.unitNoMenu.selectNumber = -1;
    self.unitNoMenu.delegate = self;
    [self.houseView addSubview:self.unitNoMenu];
    
    self.floorNoMenu = [[LMJDropdownMenu alloc] initWithFrame:CGRectMake(60, 120, weightTo, 34)];
    [self.floorNoMenu setMenuTitles:nil rowHeight:30];
    self.floorNoMenu.selectNumber = -1;
    self.floorNoMenu.delegate = self;
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
    [self.houseView addSubview: self.roomNoMenu];
    

    [self gainBData];
    
    //NSLog(@"sMArray:%@",self.buildMArray);
   // Do any additional setup after loading the view from its nib.
    self.nameFiled.text=self.model.name;
    self.nameFiled.textColor = UIColorFromHEX(0x6e6e6e);
    self.phoneLabel.text=self.model.mobile;
    self.phoneLabel.textColor = UIColorFromHEX(0x6e6e6e);
    
//    self.houseLabel.layer.borderWidth=1;
//    self.houseLabel.layer.cornerRadius=4;
//    self.houseLabel.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);

    //房间列表
    self.houseLabel.text=self.model.selectedHouse[0].title;
    if( self.model.selectedHouse.count > 0)
    {
        float x = 24;
        float y = 0;
        int i = 0;
        for (selectedHouseModel *sh in self.model.selectedHouse)
        {
            y = i*42 + 9;
            [self ConfigHouselabel:sh.title startx:x starty:y ];
            i++;
        }
    }
    
    self.authcationLabel.layer.borderWidth=1;
    self.authcationLabel.layer.cornerRadius=13;
    if ([self.model.authStatus integerValue]==1) {
        self.authcationLabel.text=@"审核中...";
         self.view.userInteractionEnabled=NO;
        self.confirmBtn.alpha=0;
        self.authcationLabel.textColor=[UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1].CGColor);
    }else if ([self.model.authStatus integerValue]==9){
        self.authcationLabel.text=@"已认证";
         self.view.userInteractionEnabled=NO;
        self.authcationLabel.textColor=[UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
        
         self.confirmBtn.alpha=0;
        
    }else if ([self.model.authStatus integerValue]==-1){
        self.authcationLabel.text=@"未通过";
        [self.confirmBtn setTitle:@"重新认证" forState:UIControlStateNormal];
        self.authcationLabel.textColor=[UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1];
        self.authcationLabel.layer.borderColor=([UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1].CGColor);
    }else{
        self.authcationLabel.alpha=0;
        self.houseLabel.alpha=0;
    }
    if( [self.model.memberType intValue] == 2  )
    {
        self.yezhuLabel.textColor = UIColorFromHEX(0x9accff);
        self.dailirenLabel.textColor = UIColorFromHEX(0x6e6e6e);

    }
    else if( [self.model.memberType intValue] == 5  )
    {
        self.yezhuLabel.textColor = UIColorFromHEX(0x6e6e6e);
        self.dailirenLabel.textColor = UIColorFromHEX(0x9accff);
    }
}
//-(void)drawTextInRect:(CGRect)rect{
//    CGRect newRect = CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width -20, rect.size.height);
//
//    [super drawTextInRect:newRect];
//}

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
    
    [self.houseSelectView addSubview:label];
}


-(void)gainBData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
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
            //NSLog(@"buildName:%@",self.buildMArray);
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

- (IBAction)sureBtn:(id)sender {
    
    if( self.nameFiled.text.length <= 0 )
    {
        [self showHint:@"姓名未填"];
        return;
    }
    if(self.idArray.count <= 0)
    {
        [self showHint:@"房源未选"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@(0) forKey:@"agentCompany"];
    [params setObject:@"" forKey:@"companyName"];
    [params setObject:@"" forKey:@"companyPost"];
    //[params setObject:@(2) forKey:@"memberType"];
    [params setObject:@(self.memberType) forKey:@"memberType"];
    [params setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.mobile forKey:@"mobile"];
    [params setObject:self.nameFiled.text forKey:@"name"];
    [params setObject:self.idArray forKey:@"selectedHouse"];
    for( int i=0; i<self.idArray.count; i++ )
    {
       NSInteger iid = [self.idArray objectAtIndex:i];
        NSLog(@"houseId:%ld", iid );
    }
    
    [params setObject:@"" forKey:@"serviceArea"];
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    [paramsHeader setObject:[GlobalConfigClass shareMySingle].userAndTokenModel.token forKey:@"token"];
    //NSLog(@"token:%@",[GlobalConfigClass shareMySingle].userAndTokenModel.token);
    __weak __typeof__ (self) wself = self;
    //NSLog(@"params:%@",params);
    [MineNetworkService gainSubmitWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        [wself showHint:response];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(id  _Nonnull response) {
         [wself showHint:response];
    }];
}
//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)yezhuBtnClick:(id)sender {
    [self.yezhuBtn setImage:[UIImage imageNamed:@"selected_h"] forState:UIControlStateNormal];
    [self.dailirenBtn setImage:[UIImage imageNamed:@"selected_n"] forState:UIControlStateNormal];
    self.memberType = 2;

}

- (IBAction)dailirenBtnClick:(id)sender {
    [self.yezhuBtn setImage:[UIImage imageNamed:@"selected_n"] forState:UIControlStateNormal];
    [self.dailirenBtn setImage:[UIImage imageNamed:@"selected_h"] forState:UIControlStateNormal];

    self.memberType = 5;

}



#pragma mark - LMJDropdownMenu Delegate

//self.buildingMenu
//buildingNoMenu
//unitNoMenu
//floorNoMenu
//roomNoMenu
//@property(nonatomic,strong)buildingListModel    *buildingData;
//@property(nonatomic,strong)buildingNoListModel  *buildingNoData;
//@property(nonatomic,strong)unitNoListModel      *unitNoListData;
//@property(nonatomic,strong)floorNoListModel     *floorNoListData;
//@property(nonatomic,strong)roomNoListModel      *roomNoListData;

- (void)clearMenuSelect:(LMJDropdownMenu *)menu arrayData:(NSMutableArray *)array;{
    menu.selectNumber = -1;
    [menu setMenuTitles:nil rowHeight:30];
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
                
                NSUInteger n = 0;
                if( self.idArray.count > 0 )
                    n = self.idArray.count - 1;
                
                [ self configHouseLabelImage:rModel.roomName Cnt:n];
                break;
            }
            i++;
        }
    }
}

-(void)configHouseLabelImage:(NSString *)name Cnt:(NSUInteger)n{
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
    [self.houseSelectView addSubview:label];

    UIImageView *deleteImg = [[UIImageView alloc] init];
    [deleteImg setImage:[UIImage imageNamed:@"delete"]];
    deleteImg.userInteractionEnabled = YES;
    float dt = 8;
    deleteImg.frame = CGRectMake( x+expect.width-dt, y-dt, 16, 16 );
    [deleteImg setTag:1000+n];

    UITapGestureRecognizer *imgTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchOn:)];
    //imgTouch.view.tag = 1000+n;
    [deleteImg addGestureRecognizer:imgTouch];
    [self.houseSelectView addSubview:deleteImg];

}

-(void)imgTouchOn:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    //NSLog(@"imgTouchOn:%ld", tag );
    
    tag = tag - 1000;

    NSString * str = [self.nameArray objectAtIndex:tag];
    //NSLog(@"idArray:%@", str );
    
    [self.idArray removeObjectAtIndex:tag];
    [self.nameArray removeObjectAtIndex:tag];

    for (UIView *view in [self.houseSelectView subviews]){
        [view removeFromSuperview];
    }
    
    for( int i=0; i<self.idArray.count; i++ )
    {
        NSString * str = [self.nameArray objectAtIndex:i];
        [ self configHouseLabelImage:str Cnt:i];
    }
 }

- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
//    NSLog(@"selectNumber:%ld", number);
//    NSLog(@"self.buildingMenu.selectNumber:%ld", self.buildingMenu.selectNumber);
//    NSLog(@"menu:%@", menu);
//    NSLog(@"buildingMenu:%@", self.buildingMenu);
    
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

//- (void)dropdownMenu:(LMJDropdownMenu *)menu selectedCellNumber:(NSInteger)number{
//    menu.selectNumber = number;
//    //NSLog(@"number:%ld",self.buildingMenu.selectNumber);
//    if( (self.buildingMenu.selectNumber != -1) &&
//       ([menu isEqual:self.buildingMenu]))
//    {
//        [self.buildNoArray removeAllObjects];
//        [self.buildingNoMenu setMenuTitles:nil rowHeight:30];
//
//        [self.unitNoArray removeAllObjects];
//        [self.unitNoMenu setMenuTitles:nil rowHeight:30];
//
//        [self.floorNoArray removeAllObjects];
//        [self.floorNoMenu setMenuTitles:nil rowHeight:30];
//
//        [self.roomNoArray removeAllObjects];
//        [self.roomNoMenu setMenuTitles:nil rowHeight:30];
//
//        buildingListModel *blmodel = self.array[self.buildingMenu.selectNumber];
//        for (buildingNoListModel *nmodel in blmodel.buildingNoList) {
//            [self.buildNoArray addObject:nmodel.buildingNo];
//        }
//        [self.buildingNoMenu setMenuTitles:self.buildNoArray rowHeight:30];
//        //[self.view addSubview:self.buildingNoMenu];
//    }
//    if( (self.buildingNoMenu.selectNumber != -1) &&
//       ([menu isEqual:self.buildingNoMenu]))
//    {
//        [self.unitNoArray removeAllObjects];
//        [self.unitNoMenu setMenuTitles:nil rowHeight:30];
//
//        [self.floorNoArray removeAllObjects];
//        [self.floorNoMenu setMenuTitles:nil rowHeight:30];
//
//        [self.roomNoArray removeAllObjects];
//        [self.roomNoMenu setMenuTitles:nil rowHeight:30];
//       // NSLog(@"buildingNoMenu enter");
//        self.unitNoMenu.selectNumber = -1;
//        self.floorNoMenu.selectNumber = -1;
//        self.roomNoMenu.selectNumber = -1;
////        NSLog(@"buildingMenu.selectNumber:%ld",self.buildingMenu.selectNumber);
////        NSLog(@"buildingNoMenu.selectNumber:%ld",self.buildingNoMenu.selectNumber);
////        NSLog(@"unitNoMenu.selectNumber:%ld",self.unitNoMenu.selectNumber);
////        NSLog(@"floorNoMenu.selectNumber:%ld",self.floorNoMenu.selectNumber);
////        NSLog(@"roomNoMenu.selectNumber:%ld",self.roomNoMenu.selectNumber);
//
//        buildingListModel *blmodel = self.array[self.buildingMenu.selectNumber];
//        NSInteger i=0;
//       // NSLog(@"blmodel:%@",blmodel);
//        for (buildingNoListModel *nmodel in blmodel.buildingNoList) {
//           // NSLog(@"buildingNoList:%@",nmodel.unitNoList);
//            if (i==self.buildingNoMenu.selectNumber) {
//                for (unitNoListModel *uModel in nmodel.unitNoList)
//                {
//                    [self.unitNoArray addObject:uModel.unitNo];
//                    //NSLog(@"unitNoArray:%@",self.unitNoArray);
//                }
//                [self.unitNoMenu setMenuTitles:self.unitNoArray rowHeight:30];
//                break;
//            }
//            i++;
//        }
//    }
//    //NSLog(@"buildingNoMenu over");
//
//    if( (self.unitNoMenu.selectNumber != -1) &&
//       ([menu isEqual:self.unitNoMenu]))
//    {
//        [self.floorNoArray removeAllObjects];
//        [self.floorNoMenu setMenuTitles:self.floorNoArray rowHeight:30];
//
//        [self.roomNoArray removeAllObjects];
//        [self.roomNoMenu setMenuTitles:self.roomNoArray rowHeight:30];
//
//
//        buildingListModel *blmodel = self.array[self.buildingMenu.selectNumber];
//        NSInteger i=0;
//        //NSLog(@"8888");
//        for (buildingNoListModel *nmodel in blmodel.buildingNoList) {
//            if (i==self.buildingNoMenu.selectNumber) {
//                NSInteger j=0;
//                for (unitNoListModel *uModel in nmodel.unitNoList)
//                {
//                    if(j==self.unitNoMenu.selectNumber)
//                    {
//                        for ( floorNoListModel *fModel in uModel.floorNoList)
//                        {
//                            [self.floorNoArray addObject:fModel.floorNo];
//                            //NSLog(@"floorNoArray:%@",self.floorNoArray);
//                        }
//                        [self.floorNoMenu setMenuTitles:self.floorNoArray rowHeight:30];
//                        break;
//                    }
//                    j++;
//                 }
//                break;
//            }
//            i++;
//        }
//    }
//
//    if( (self.floorNoMenu.selectNumber != -1) &&
//       ([menu isEqual:self.floorNoMenu]))
//    {
//        [self.roomNoArray removeAllObjects];
//        [self.roomNoMenu setMenuTitles:self.roomNoArray rowHeight:30];
//
//        buildingListModel *blmodel = self.array[self.buildingMenu.selectNumber];
//        NSInteger i=0;
//        //NSLog(@"8888");
//        for (buildingNoListModel *nmodel in blmodel.buildingNoList) {
//            if (i==self.buildingNoMenu.selectNumber) {
//                NSInteger j=0;
//                for (unitNoListModel *uModel in nmodel.unitNoList)
//                {
//                    if(j==self.unitNoMenu.selectNumber)
//                    {
//                        NSInteger k=0;
//                        for ( floorNoListModel *fModel in uModel.floorNoList)
//                        {
//                            if(k==self.floorNoMenu.selectNumber)
//                            {
//                                for ( roomNoListModel *rModel in fModel.roomNoList)
//                                {
//                                    [self.roomNoArray addObject:rModel.roomNo];
//                                }
//                                [self.roomNoMenu setMenuTitles:self.roomNoArray rowHeight:30];
//                                break;
//                            }
//                            k++;
//                        }
//                        break;
//                    }
//                    j++;
//                }
//                break;
//            }
//            i++;
//        }
//    }
//    if( (self.roomNoMenu.selectNumber != -1) &&
//       ([menu isEqual:self.roomNoMenu])){
////        NSLog(@"buildingMenu.selectNumber:%ld",self.buildingMenu.selectNumber);
////        NSLog(@"buildingNoMenu.selectNumber:%ld",self.buildingNoMenu.selectNumber);
////        NSLog(@"unitNoMenu.selectNumber:%ld",self.unitNoMenu.selectNumber);
////        NSLog(@"floorNoMenu.selectNumber:%ld",self.floorNoMenu.selectNumber);
////        NSLog(@"roomNoMenu.selectNumber:%ld",self.roomNoMenu.selectNumber);
//        self.houseId=-1;
//        //[self.array removeAllObjects];
//        buildingListModel *blmodel = self.array[self.buildingMenu.selectNumber];
//        NSInteger i=0;
//         for (buildingNoListModel *nmodel in blmodel.buildingNoList) {
//
//             if (self.buildingNoMenu.selectNumber==i) {
//                 NSInteger j=0;
//                 for (unitNoListModel *uModel in nmodel.unitNoList){
//                     if (self.unitNoMenu.selectNumber==j) {
//                         NSInteger k=0;
//                         for ( floorNoListModel *fModel in uModel.floorNoList){
//                             if (self.floorNoMenu.selectNumber==k) {
//                                 NSInteger l=0;
//                                 for ( roomNoListModel *rModel in fModel.roomNoList)
//                                 {
//                                     if (self.roomNoMenu.selectNumber==l) {
//                                         //roomNoListModel *roomModel=self.roomNoArray[l];
//                                         self.houseId=[rModel.houseId integerValue];
//                                        // NSLog(@"houseId:%ld",self.houseId);
//                                         self.houseLabel.text=rModel.roomName;
//                                         [self.idArray removeAllObjects];
//                                         [self.idArray addObject:@(self.houseId)];
//                                         break;
//                                     }
//                                     l++;
//                                 }
//                                 break;
//                             }
//                             k++;
//                          }
//                         break;
//                     }
//                     j++;
//                 }
//                 break;
//             }
//             i++;
//         }
//    }
//
//    //NSLog(@"你选择了：%ld",number);
//}

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//        CGFloat offsetY = scrollView.contentOffset.y;
//
//        if( offsetY > self.customNavBar.height )
//        {
//            scrollView.contentInset = UIEdgeInsetsMake(self.customNavBar.height, 0, 0, 0);
//            //self.sectionView.backgroundColor = [UIColor whiteColor];
//
//        }
//        else
//        {
//            //self.sectionView.backgroundColor = [UIColor whiteColor];
//            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//
//        }
    NSLog(@"contentOffset:%lf,%lf", scrollView.contentOffset.x,scrollView.contentOffset.y);
}

@end
