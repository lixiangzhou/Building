//
//  AuthenticationController.m
//  Building
//
//  Created by Mac on 2019/3/7.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "AuthenticationController.h"
#import "AgentController.h"
#import "AuthHeaderView.h"
#import "ProprietorController.h"
#import "HouseController.h"
#import "AgentController.h"
#import "proprietorCon.h"
#import "proprietorCCViewControl.h"


#define authentionHeaderViewHeight 50

@interface AuthenticationController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) int navBarHeight;
@property (nonatomic,strong)proprietorCon *proVC;
@property(nonatomic,strong)HouseController *houseVC;
@property(nonatomic,strong)AgentController *agentVC;
@property (weak, nonatomic) IBOutlet UIButton *proBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
@property (weak, nonatomic) IBOutlet UIButton *agentBtn;
@property (weak, nonatomic) IBOutlet UILabel *proLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;



@property(nonatomic,strong)AuthInfoModel *infoModel;
@end

@implementation AuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    NSLog(@"实名认证");
    [self.navigationItem setTitle:@"实名认证"];
    if (kDevice_Is_iPhoneX) {
        self.navBarHeight = 44 + 44;
    } else {
        self.navBarHeight = 44 + 20;
    }
     __weak typeof(self) weakSelf = self;
    [MineNetworkService gainAuthinfoWithSuccess:^(id  _Nonnull response) {
        NSLog(@"response:%@",response);
       
        weakSelf.infoModel=response;
        
//        if( weakSelf.infoModel.selectedHouse.count > 0)
//        {
//            NSLog(@"selectedHouse.count:%ld", weakSelf.infoModel.selectedHouse.count );
//            for (selectedHouseModel *sh in weakSelf.infoModel.selectedHouse)
//            {
//                NSLog(@"sh.title:%@", sh.title);
//            }
//        }
        NSLog( @"memberType:%@, authStatus:%@", weakSelf.infoModel.memberType, weakSelf.infoModel.authStatus );
//        for (selectedHouseModel *sh in weakSelf.infoModel.selectedHouse)
//        {
//            NSLog(@"title:%@, id:%@", sh.title, sh.houseId);
//        }

        if( ([ weakSelf.infoModel.memberType integerValue]==2)  || ([ weakSelf.infoModel.memberType integerValue]==5))  {
            //业主
            [self getProInfo];
        }else if([ weakSelf.infoModel.memberType integerValue]==3){
            //住户
            [self getHouseInfo];
        } else if ([ weakSelf.infoModel.memberType integerValue]==4){
            //经纪人
            [self getAgentInfo];
        }else{
            //游客
             [self getProInfo];
        }
        

       
    } failure:^(id  _Nonnull response) {
    
    }];
    
    
    UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(proLabelClick:)];
    [self.proLabel addGestureRecognizer:tapGesture0];
    self.proLabel.userInteractionEnabled= YES;

    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(houseLabelClick:)];
    [self.houseLabel addGestureRecognizer:tapGesture1];
    self.houseLabel.userInteractionEnabled= YES;

    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agentLabelClick:)];
    [self.agentLabel addGestureRecognizer:tapGesture2];
    self.agentLabel.userInteractionEnabled= YES;
   
     //[self loadingSubViews];
    
}

-(void)proLabelClick:(id)sender{
    [self proClick:sender];
}

-(void)houseLabelClick:(id)sender{
    [self houseClick:sender];
}

-(void)agentLabelClick:(id)sender{
    [self agentClick:sender];

}



-(void)getProInfo{
    
    [self.proBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
     [self.houseBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
     [self.agentBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    self.proLabel.textColor = UIColorFromHEX(0x9accff);
    self.houseLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.agentLabel.textColor = UIColorFromHEX(0x6e6e6e);
    
    self.proVC=[[proprietorCon alloc] init];
    self.proVC.model=self.infoModel;
    
    //[self.view setBackgroundColor:[UIColor blackColor]];
    [self.proVC willMoveToParentViewController:self];
    [self addChildViewController:self.proVC];
    [self.proVC didMoveToParentViewController:self];
    self.proVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
    [self.view addSubview:self.proVC.view];

}

-(void)getHouseInfo{
    
    [self.proBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.houseBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    [self.agentBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    self.proLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.houseLabel.textColor = UIColorFromHEX(0x9accff);
    self.agentLabel.textColor = UIColorFromHEX(0x6e6e6e);

    self.houseVC=[[HouseController alloc] init];
    self.houseVC.model=self.infoModel;
    NSLog(@"houseMobile:%@",self.houseVC.model.mobile);
    [self.houseVC willMoveToParentViewController:self];
    [self addChildViewController:self.houseVC];
    [self.houseVC didMoveToParentViewController:self];
    self.houseVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
    [self.view addSubview:self.houseVC.view];
    
}

-(void)getAgentInfo{
    
    [self.proBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.houseBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.agentBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    self.proLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.houseLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.agentLabel.textColor = UIColorFromHEX(0x9accff);


    self.agentVC=[[AgentController alloc] init];
    self.agentVC.model=self.infoModel;
    [self.agentVC willMoveToParentViewController:self];
    [self addChildViewController:self.agentVC];
    [self.agentVC didMoveToParentViewController:self];
    self.agentVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
    [self.view addSubview:self.agentVC.view];
    NSLog(@"agent");
    
}



- (void)loadingSubViews {
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setDelegate:self];
    _scrollView.frame = CGRectMake(0, self.navBarHeight + 50, ScreenWidth, ScreenHeight-114);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(ScreenWidth * 3, 0)];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.x/ScreenWidth;
    //self.topBarView.progress = progress;
}
- (IBAction)proClick:(id)sender {
    if( ([self.infoModel.authStatus integerValue ]==1) || ([self.infoModel.authStatus integerValue ]==9) ){
        return;
    }
    [self.proBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    [self.houseBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.agentBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    self.proLabel.textColor = UIColorFromHEX(0x9accff);
    self.houseLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.agentLabel.textColor = UIColorFromHEX(0x6e6e6e);

    self.proVC=[[proprietorCon alloc] init];
     self.proVC.model=self.infoModel;
    
    //[self.view setBackgroundColor:[UIColor blackColor]];
    [self addChildViewController:self.proVC];
    self.proVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
    [self.view addSubview:self.proVC.view];

    //NSLog(@"pro");
    
}

//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //NSLog(@"touchesBegan");
}




- (IBAction)houseClick:(id)sender {
    if( ([self.infoModel.authStatus integerValue ]==1) || ([self.infoModel.authStatus integerValue ]==9) ){
        return;
    }
    [self.proBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.houseBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    [self.agentBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    
    self.proLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.houseLabel.textColor = UIColorFromHEX(0x9accff);
    self.agentLabel.textColor = UIColorFromHEX(0x6e6e6e);
    //NSLog(@"houseClick:(id)sender");
    self.houseVC=[[HouseController alloc] init];
     self.houseVC.model=self.infoModel;
    [self addChildViewController:self.houseVC];
     //NSLog(@"houseClick:(id)sender,addChildViewController");
    self.houseVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
     //NSLog(@"house");
    [self.view addSubview:self.houseVC.view];
   
    
}
- (IBAction)agentClick:(id)sender {
    if( ([self.infoModel.authStatus integerValue ]==1) || ([self.infoModel.authStatus integerValue ]==9) ){
        return;
    }
    [self.proBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.houseBtn setImage:[UIImage imageNamed:@"selected_n" ]forState:UIControlStateNormal];
    [self.agentBtn setImage:[UIImage imageNamed:@"selected_h" ]forState:UIControlStateNormal];
    self.proLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.houseLabel.textColor = UIColorFromHEX(0x6e6e6e);
    self.agentLabel.textColor = UIColorFromHEX(0x9accff);

    self.agentVC=[[AgentController alloc] init];
     self.agentVC.model=self.infoModel;
    [self addChildViewController:self.agentVC];
    self.agentVC.view.frame=CGRectMake(0, self.navBarHeight + 50,ScreenWidth,ScreenHeight-self.navBarHeight-50);
    [self.view addSubview:self.agentVC.view];
     NSLog(@"agent");
    
    
}


@end
