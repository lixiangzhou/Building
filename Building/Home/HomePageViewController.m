//
//  HomePageViewController.m
//  YouYi
//
//  Created by Macbook Pro on 2019/1/29.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomeChoiceCell.h"
#import "FYServiceSecondLevelVC.h"
#import "BuildServiceSecondLevelVC.h"
#import "CropServiceSecondLevelVC.h"
#import "WRCustomNavigationBar.h"
#import "WRNavigationBar.h"
#import "BuildServiceHouseDetailVC.h"
#import "FYServiceHouseDetailVC.h"
#import <CoreLocation/CoreLocation.h>
#import <BMKLocationkit/BMKLocationComponent.h>
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "SelectLocationCityVC.h"
#import "WMDragView.h"//拖拽视图
#import "DelegateToSaleView.h"
#import "LoginViewController.h"
#import "EmptyView.h"

#define HomeServiceMaxCount       3
#define HomeServiceCellHeight       120
#define HomeChoiceCellXibName       @"HomeChoiceCell"



//#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 280
#define NAV_HEIGHT 64

@interface HomePageViewController ()<UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate, BMKLocationManagerDelegate, DelegateToSaleViewDelegate>//CLLocationManagerDelegate
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *bannerModelArr;
@property (nonatomic, assign) float cycleScrollViewheight;

@property (weak, nonatomic) IBOutlet UITableView *choiceFYTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceFYTableViewHeight;
@property (nonatomic, strong) NSMutableArray *choiceFYModelArr;
@property (weak, nonatomic) IBOutlet UITableView *choiceLYTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceLYTableViewHeight;
@property (nonatomic, strong) NSMutableArray *choiceLYModelArr;
@property (weak, nonatomic) IBOutlet UITableView *choiceQYTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceQYTableViewHeight;
@property (nonatomic, strong) NSMutableArray *choiceQYModelArr;

@property (nonatomic, strong) WRCustomNavigationBar *customNavBar;

@property (nonatomic, strong) BMKLocationManager *locationManager;//百度地图定位
@property (nonatomic, copy) NSString *cityName;
@property (strong, nonatomic) NSArray <FYProvinceModel *> *provinceList;
@property (strong, nonatomic) NSMutableDictionary *cityDic;//城市分组

@property(nonatomic, strong) WMDragView *dragView;//拖拽视图

@property (nonatomic, strong) DelegateToSaleView *delegateView;//委托视图
@property (weak, nonatomic) IBOutlet UIButton *moreFangYuanButon;
@property (weak, nonatomic) IBOutlet UIButton *moreLouYuButon;
@property (weak, nonatomic) IBOutlet UIButton *moreiYeButon;

@property (weak, nonatomic) IBOutlet UIImageView *moreFyimg;
@property (weak, nonatomic) IBOutlet UIImageView *moreLyImg;
@property (weak, nonatomic) IBOutlet UIImageView *moreQyImg;
//@property (weak, nonatomic) IBOutlet UIImageView *locationImg;
//@property (weak, nonatomic) IBOutlet UILabel *locationCityLabal;
@property (nonatomic, strong ) UILabel *mapCityLabal;
@property (assign, nonatomic) int navBarHeight;
    
@property (weak, nonatomic) IBOutlet UIView *choiceFYInfoView;
@property (weak, nonatomic) IBOutlet UIView *choiceLYInfoView;
@property (weak, nonatomic) IBOutlet UIView *choiceQYInfoView;

@property (weak, nonatomic) EmptyView *emptyView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *productView;

/// 房源
@property (weak, nonatomic) IBOutlet UIView *houseView;
/// 楼宇
@property (weak, nonatomic) IBOutlet UIView *serviceView1;
/// 楼通
@property (weak, nonatomic) IBOutlet UIView *serviceView2;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (kDevice_Is_iPhoneX) {
        self.navBarHeight = 44 + 44;
    } else {
        self.navBarHeight = 44 + 20;
    }
    
    //数据初始化
    self.bannerModelArr = [[NSMutableArray alloc] init];
    self.choiceFYModelArr = [[NSMutableArray alloc] init];
    self.choiceLYModelArr = [[NSMutableArray alloc] init];
    self.choiceQYModelArr = [[NSMutableArray alloc] init];
    self.cityName = nil;
    self.provinceList = [[NSMutableArray alloc] init];
    self.cityDic = [[NSMutableDictionary alloc] init];
    self.cycleScrollViewheight = ScreenWidth * 56 / 75;

    
    [self.moreFyimg setImage:[UIImage imageNamed:@"list_icon_more.png"]];
    [self.moreLyImg setImage:[UIImage imageNamed:@"list_icon_more.png"]];
    [self.moreQyImg setImage:[UIImage imageNamed:@"list_icon_more.png"]];
    
    EmptyView *emptyView = [EmptyView new];
    self.emptyView = emptyView;
    [self.contentView addSubview:emptyView];
    
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productView.mas_bottom).offset(65);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@(self.emptyView.width));
        make.height.equalTo(@(self.emptyView.height));
    }];
    
    [GlobalConfigClass shareMySingle].LoginStatus = NO;
    [GlobalConfigClass shareMySingle].serviceType = nil;

    //NSLog(@"LoginStatus:%@", [GlobalConfigClass shareMySingle].LoginStatus);
    

   //配置百度定位
    [self configBMKLocation];
    
    //自定义导航条
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

#if 0
    //定位图片
    UIImage *mapImg = [UIImage imageNamed:@"list_icon_map_2.png"];
    UIImageView *mapImage = [[UIImageView alloc] init];
    mapImage.frame = CGRectMake(17, (self.customNavBar.height/2)+12, 20, 20);
    mapImage.image = mapImg;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationClickImage)];
    [mapImage addGestureRecognizer:tapGesture];
    mapImage.userInteractionEnabled = YES;
    [self.view addSubview:mapImage];
    
    self.mapCityLabal = [UILabel new];
    self.mapCityLabal.text = @"";
    self.mapCityLabal.font = [UIFont systemFontOfSize:12];
    self.mapCityLabal.textColor = UIColorFromHEX(0x515b6f);
    
    self.mapCityLabal.frame = CGRectMake(42, (self.customNavBar.height/2)+13, 50, 17);
    [self.view addSubview:self.mapCityLabal];
#endif
    
    self.customNavBar.titleLabelColor = UIColorFromHEX(0x515c6f);//[UIColor whiteColor];
    self.customNavBar.title = @"首页";
    [self.customNavBar wr_setBackgroundAlpha:0];
    
    FYCityModel *cityModel = [GlobalConfigClass shareMySingle].cityModel;
    
    [self.customNavBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"list_icon_map_2"] highlighted:[UIImage imageNamed:@"list_icon_map_2"] title:cityModel.cityName titleColor:UIColorFromHEX(0x515b6f)];
    
    __weak __typeof__ (self) wself = self;
    self.customNavBar.onClickLeftButton = ^{
        SelectLocationCityVC *hoseDetailVC = [[SelectLocationCityVC alloc] init];
        hoseDetailVC.cityDic = wself.cityDic;
        hoseDetailVC.selectCityBlock = ^(FYCityModel *cityModel) {
            [wself.customNavBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"list_icon_map_2"] highlighted:[UIImage imageNamed:@"list_icon_map_2"] title:cityModel.cityName titleColor:UIColorFromHEX(0x515b6f)];
            //[self.view bringSubviewToFront:wself.customNavBar];
            [wself gainBannerData];
            [wself gainHomeServiceList];
            [wself.locationManager stopUpdatingLocation];
        };
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [wself.navigationController pushViewController:hoseDetailVC animated:YES];
    };
    [self.view insertSubview:self.customNavBar aboveSubview:self.myScrollView];

    //轮播图
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = BAR_TINTCOLOR;
    
    //拖拽视图
    //ygz test
    [self configDragView];
    [self configdelegateViewTo];
    
    //请求网络
    //ygz test
    [self gainCityList];

    //图片，图片点击事件
    //[self.locationImg setImage:[UIImage imageNamed:@"ic_telephone.png"]];
    //[self.view bringSubviewToFront:self.locationImg];
    //UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(c)];
    //[self.locationImg addGestureRecognizer:tapGesture];

    //self.locationImg.userInteractionEnabled = YES;

    //ygz test
    //[self gainBannerData];
    //[self gainHomeServiceList];
    
    self.myScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self gainHomeServiceList];
        [self gainBannerData];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [GlobalConfigClass shareMySingle].serviceType = nil;

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    [self gainBannerData];
    [self gainHomeServiceList];
    
    // 拖拽视图
    //ygz test
    [self configDragView];
    [self configdelegateViewTo];
    
}

- (void)configdelegateViewTo{
    //委托视图
    self.delegateView = [[DelegateToSaleView alloc] init];
    self.delegateView.hidden = YES;
    self.delegateView.delegate = self;
    //self.delegateView.backgroundColor = [UIColor redColor];
    self.delegateView.frame = CGRectMake(0, 0, ScreenWidth, 430);
    [self.view addSubview:self.delegateView];
    [self.delegateView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.mas_equalTo(weakSelf.cycleSuperView);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    self.dragView.hidden=YES;
}

#pragma mark - requests
- (void)gainBannerData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService getBannerInfoWithType:@"POST_INDEX" Success:^(NSArray *banners) {
        //NSLog(@"getBannerInfoWithType:%@", banners);
        [weakSelf.bannerModelArr removeAllObjects];
        for (BannerModel * banner in banners) {
            //NSLog(@"BannerModel:%@", banner);
            if([banner.image hasPrefix:@"http"]) {
                [weakSelf.bannerModelArr addObject:banner];
            }
        }
        
        NSMutableArray * bannersTemp = [NSMutableArray arrayWithCapacity:6];
        for (BannerModel *banner in weakSelf.bannerModelArr) {
            //NSLog(@"banner.image:%@", banner.image);
            [bannersTemp addObject:banner.image];
        }
        
        weakSelf.cycleScrollView.imageURLStringsGroup = bannersTemp;
    } failure:^(id response) {
        [self showHint:response];
    }];
}

//首页服务列表
- (void)gainHomeServiceList{
    //NSLog(@"gainHomeServiceList");
    //NSLog(@"gainHomeServiceList cityId:%@", [GlobalConfigClass shareMySingle].cityModel.cityId );
    __weak typeof(self) weakSelf = self;
//    [weakSelf.choiceFYModelArr removeAllObjects];
//    [weakSelf.choiceLYModelArr removeAllObjects];
//    [weakSelf.choiceQYModelArr removeAllObjects];

    [HomeNetworkService getHomeServiceListSuccess:^(HomeServiceModel *serviceInfo) {
        [self.myScrollView.mj_header endRefreshing];
        [self.myScrollView.mj_footer endRefreshing];
        
        HomeServiceShowModel *serviceShow = serviceInfo.serviceAuth;
        
        BOOL showHouse = serviceShow.showHouse && serviceInfo.houseServiceList.count;
        BOOL showBuild = serviceShow.showBuild && serviceInfo.buildServiceList.count;
        BOOL showCorp = serviceShow.showCorp && serviceInfo.corpServiceList.count;
        
        weakSelf.choiceFYInfoView.hidden = !showHouse;
        weakSelf.choiceFYTableView.hidden = !showHouse;
        
        weakSelf.choiceLYInfoView.hidden = !showBuild;
        weakSelf.choiceLYTableView.hidden = !showBuild;
        
        weakSelf.choiceQYInfoView.hidden = !showCorp;
        weakSelf.choiceQYTableView.hidden = !showCorp;
        
        NSMutableArray *views = [NSMutableArray new];
        if (serviceShow.showHouse) {
            [views addObject:weakSelf.houseView];
        }
        weakSelf.houseView.hidden = !serviceShow.showHouse;
        
        if (serviceShow.showBuild) {
            [views addObject:weakSelf.serviceView1];
        }
        weakSelf.serviceView1.hidden = !serviceShow.showBuild;
        
        if (serviceShow.showCorp) {
            [views addObject:weakSelf.serviceView2];
        }
        weakSelf.serviceView2.hidden = !serviceShow.showCorp;
        
        for (NSInteger i = 1; i <= views.count; i++) {
            UIView *v = views[i - 1];
            CGFloat offset = (ScreenWidth / 6) * (i * 2 - 1);
            [v mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(v.superview);
                make.centerX.equalTo(v.superview.mas_left).offset(offset);
            }];
        }
        
        
        if (showHouse) {
            //NSLog(@"showHouse");
            NSInteger countMy = [serviceInfo.houseServiceList count] > HomeServiceMaxCount ? HomeServiceMaxCount : [serviceInfo.houseServiceList count];
            [weakSelf.choiceFYModelArr removeAllObjects];
            
            for (int i=0; i < countMy; i++) {
                HouseServiceModel *item = serviceInfo.houseServiceList[i];
                [weakSelf.choiceFYModelArr addObject:item];
            }
            
            weakSelf.choiceFYTableViewHeight.constant = countMy * HomeServiceCellHeight;
            [weakSelf.choiceFYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@40);
            }];
            [weakSelf.choiceFYTableView reloadData];
        } else {
            weakSelf.choiceFYTableViewHeight.constant = 0;
            [weakSelf.choiceFYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [weakSelf.choiceFYTableView reloadData];
        }
        
        
        if(showBuild) {
            //NSLog(@"showBuild");
            NSInteger countMy = [serviceInfo.buildServiceList count] > HomeServiceMaxCount ? HomeServiceMaxCount : [serviceInfo.buildServiceList count];
            [weakSelf.choiceLYModelArr removeAllObjects];
            for (int i=0; i < countMy; i++) {
                ServiceItemModel *item = serviceInfo.buildServiceList[i];
                [weakSelf.choiceLYModelArr addObject:item];
            }
            weakSelf.choiceLYTableViewHeight.constant = countMy * HomeServiceCellHeight;
            [weakSelf.choiceLYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@40);
            }];
            [weakSelf.choiceLYTableView reloadData];
        } else {
            weakSelf.choiceLYTableViewHeight.constant = 0;
            [weakSelf.choiceLYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [weakSelf.choiceLYTableView reloadData];
        }
        
        if(showCorp) {
            //NSLog(@"showCorp");
            NSInteger countMy = [serviceInfo.corpServiceList count] > HomeServiceMaxCount ? HomeServiceMaxCount : [serviceInfo.corpServiceList count];
            [weakSelf.choiceQYModelArr removeAllObjects];
            for (int i=0; i < countMy; i++) {
                ServiceItemModel *item = serviceInfo.corpServiceList[i];
                [weakSelf.choiceQYModelArr addObject:item];
            }
            weakSelf.choiceQYTableViewHeight.constant = countMy * HomeServiceCellHeight;
            [weakSelf.choiceQYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@40);
            }];
            [weakSelf.choiceQYTableView reloadData];
        } else {
            weakSelf.choiceQYTableViewHeight.constant = 0;
            [weakSelf.choiceQYInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [weakSelf.choiceQYTableView reloadData];
        }
        
        BOOL hasNOEmpty = showHouse || showBuild || showCorp;
        self.emptyView.hidden = hasNOEmpty;
        
        NSMutableArray *resources = [NSMutableArray new];
        [resources addObject:[CYLTabBarControllerConfig shared].homeResource];
        if (serviceShow.showHouse) {
            [resources addObject:[CYLTabBarControllerConfig shared].houseResource];
        }
        if (serviceShow.showCorp || serviceShow.showBuild) {
            [resources addObject:[CYLTabBarControllerConfig shared].serviceResource];
        }
        [resources addObject:[CYLTabBarControllerConfig shared].mineResource];
        [[CYLTabBarControllerConfig shared] setRootControllerWithChildResources:resources];
        
        
    } failure:^(id response) {
        [self showHint:response];
    }];
}

//获取城市列表
- (void)gainCityList{
    __weak typeof(self) weakSelf = self;
    [FangYuanNetworkService getHomeCityListSuccess:^(NSArray * _Nonnull citys) {
        weakSelf.provinceList = citys;
        
        NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
        for (FYProvinceModel *provinceItem in citys) {
            for (FYCityModel *cityItem in provinceItem.cityList) {
                NSString *firstChar = [self gainFirstCharWithString:cityItem.cityName];
                NSMutableArray *cityTempArr = [cityDic objectForKey:firstChar];
                if (cityTempArr == nil) {
                    cityTempArr = [[NSMutableArray alloc] init];
                }
                [cityTempArr addObject:cityItem];
                [cityDic setObject:cityTempArr forKey:firstChar];
            }
        }
        self.cityDic = cityDic;
        
        if ( self.cityName != nil ) {//已经定位到城市
            for (FYProvinceModel *provinceItem in citys) {
                for (FYCityModel *cityItem in provinceItem.cityList) {
                    if ([self.cityName containsString:cityItem.cityName]) {
                        GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
                        configer.cityModel = cityItem;
                        self.mapCityLabal.text = cityItem.cityName;
                        [self gainBannerData];
                        [self gainHomeServiceList];
                        break;
                    }
                }
            }
        }
        //ygz test 2019-3-28
        else{
            //未定位到位置，初始化北京
            self.cityName = @"南京市";
            FYCityModel *cityItem = [[FYCityModel alloc] init] ;
            cityItem.cityId = @"102";
            cityItem.cityName = @"南京市";
            cityItem.pinyin = @"nanjing";
            GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
            configer.cityModel = cityItem;
            //[GlobalConfigClass shareMySingle].cityModel.cityId = @"1";
            //[GlobalConfigClass shareMySingle].cityModel.cityName = @"北京";
            //[GlobalConfigClass shareMySingle].cityModel.pinyin = @"beijing";
            //NSLog(@"configer.cityModel:%@", [GlobalConfigClass shareMySingle].cityModel.cityId );
            self.mapCityLabal.text = cityItem.cityName;
            [self gainBannerData];
            [self gainHomeServiceList];
        }
    } failure:^(id  _Nonnull response) {
        
    }];
}

//获取委托的可选数据
- (void)gainDelegateHouseData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainDelegateHouseDataSuccess:^(DelegateModel *response) {
        weakSelf.delegateView.hidden = NO;
        weakSelf.tabBarController.tabBar.hidden = YES;
        weakSelf.delegateView.delegateModel = response;
        //NSLog(@"delegateModel:%@", weakSelf.delegateView.delegateModel );
    } failure:^(NSString *response) {
        [self showHint:response];
    }];
}

//增加新的委托
- (void)requestCreateDelegateHouseData:(NSMutableDictionary *)params{
    __weak __typeof__ (self) wself = self;
    [HomeNetworkService requestCreateDelegateHouseData:params Success:^(NSInteger code) {
        [wself showHint:@"\n委托成功!\n请在个人中心及时关注委托状态\n"];
    } failure:^(id response) {
        [wself showHint:response];
    }];
}

#pragma mark - DelegateToSaleViewDelegate
- (void)doneBtnActionOfDelegateToSaleView:(NSMutableDictionary *)params{
//    BuildAndCropServiceYuYueVC *hoseDetailVC = [[BuildAndCropServiceYuYueVC alloc] init];
//    hoseDetailVC.detailModel = self.detailModel;
//    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:hoseDetailVC animated:YES];
//    NSLog(@"doneBtnActionOfDelegateToSaleView:%@", params);
    [self requestCreateDelegateHouseData:params];
    
    self.delegateView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    //[self.delegateView removeFromSuperview];
    //NSLog(@"doneBtnActionOfDelegateToSaleView");
    [self configdelegateViewTo];
}

- (void)cancelBtnActionOfDelegateToSaleView{
    self.delegateView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    //[self.delegateView removeFromSuperview];
    //NSLog(@"cancelBtnActionOfDelegateToSaleView");
    [self configdelegateViewTo];
}

- (void)coverViewTapActionOfDelegateToSaleView{
    self.delegateView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    //NSLog(@"coverViewTapActionOfDelegateToSaleView");
    
    [self configdelegateViewTo];
    //[self.delegateView removeFromSuperview];
}


#pragma mark - BMKLocationManagerDelegate
-(void) locationClickImage{
    self.mapCityLabal.text =
    [GlobalConfigClass shareMySingle].cityModel.cityName;
    //NSLog(@"locationClickImage");
}


- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error
{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
//            NSLog(@"CLLocation = %@",location.location);
//            NSString *latitude = [NSString stringWithFormat:@"%f",location.location.coordinate.latitude];
//            NSString *longitude = [NSString stringWithFormat:@"%f",location.location.coordinate.longitude];
        }
        if (location.rgcData) {
//            NSLog(@"rgc = %@",[location.rgcData description]);
//            NSLog(@"city = %@", location.rgcData.city);
            self.cityName = location.rgcData.city;
            [self.customNavBar wr_setLeftButtonWithNormal:[UIImage imageNamed:@"list_icon_map_2"] highlighted:[UIImage imageNamed:@"list_icon_map_2"] title:location.rgcData.city titleColor:UIColorFromHEX(0x666666)];
            
            if (self.provinceList.count > 0) {//已获取到城市列表
                for (FYProvinceModel *provinceItem in self.provinceList) {
                    for (FYCityModel *cityItem in provinceItem.cityList) {
                        if ([self.cityName containsString:cityItem.cityName]) {
                            GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
                            configer.cityModel = cityItem;
                            self.mapCityLabal.text = cityItem.cityName;
                            [self gainBannerData];
                            [self gainHomeServiceList];
                            break;
                        }
                    }
                }
            }
            //ygz add 2019-04-08
            //定位完成，停止使用定位
            [self.locationManager stopUpdatingLocation];
        }
    }
}
    
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT(IMAGE_HEIGHT))
    {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT(IMAGE_HEIGHT)) / NAV_HEIGHT;
        [self.customNavBar wr_setBackgroundAlpha:alpha];
        [self.customNavBar wr_setTintColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
        [self wr_setStatusBarStyle:UIStatusBarStyleDefault];
    }
    else
    {
        [self.customNavBar wr_setBackgroundAlpha:0];
        [self.customNavBar wr_setTintColor:UIColorFromHEX(0x707070)];
        [self wr_setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    if (-offsetY > 50) {
        NSLog(@"offsetY:%lf, 下拉刷新", offsetY );

        // 调用下拉刷新方法
//        [self gainBannerData];
//        [self gainHomeServiceList];
        
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; {
    if (self.bannerModelArr.count > index) {
//        BannerModel *bannerModel = self.bannerModelArr[index];
//
//        //统 计banner点击率
//        [HomeNetworkService StatisticBannerClickRateWithBannerid:bannerModel.idStr Success:^(id response) {
//        } failure:^(id response) {
//        }];
//
//        //跳转对应的链接页
//        self.webBrowser.navigationItem.title = bannerModel.title;
//        self.webBrowser.KINWebType = CustomKINWebBrowserTypeHomeBanner;
//        [self.navigationController pushViewController:self.webBrowser animated:YES];
//        [self.webBrowser loadURLString:bannerModel.linkUrl];
    }
}

#pragma mark - Actions
//房源服务
- (IBAction)fangYuanServiceTapAction:(id)sender {
    //NSLog(@"FYServiceSecondLevelVC");
    FYServiceSecondLevelVC * serviceVC = [[FYServiceSecondLevelVC alloc] init];
    [serviceVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:serviceVC animated:YES];
}
//楼宇服务
- (IBAction)louYuServiceTapAction:(id)sender {
    //NSLog(@"louYuServiceTapAction");
    BuildServiceSecondLevelVC * serviceVC = [[BuildServiceSecondLevelVC alloc] init];
    [serviceVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:serviceVC animated:YES];
}
//企业服务
- (IBAction)qiYeServiceTapAction:(id)sender {
    //NSLog(@"qiYeServiceTapAction");
    CropServiceSecondLevelVC * serviceVC = [[CropServiceSecondLevelVC alloc] init];
    [serviceVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:serviceVC animated:YES];
}

- (IBAction)moreFangYuanAction:(id)sender {
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)moreLouYuAction:(id)sender {
    [GlobalConfigClass shareMySingle].serviceType = @"buildService";

    self.tabBarController.selectedIndex = 2;
    
    //self.navigationController.
    //self.tabBarController.
}
- (IBAction)moreiYeAction:(id)sender {
    [GlobalConfigClass shareMySingle].serviceType = @"corpService";
    self.tabBarController.selectedIndex = 2;
}




#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.choiceFYTableView) {
        return [self.choiceFYModelArr count];
    } else if (tableView == self.choiceLYTableView) {
        return [self.choiceLYModelArr count];
    } else {
        return [self.choiceQYModelArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.choiceFYTableView) {
        HomeChoiceCell *cell = (HomeChoiceCell *)[self getCellFromXibName:HomeChoiceCellXibName dequeueTableView:tableView];
        HouseServiceModel *model = self.choiceFYModelArr[indexPath.row];
        cell.houseModel = model;
        
        return cell;
    } else if (tableView == self.choiceLYTableView) {
        HomeChoiceCell *cell = (HomeChoiceCell *)[self getCellFromXibName:HomeChoiceCellXibName dequeueTableView:tableView];
        ServiceItemModel *model = self.choiceLYModelArr[indexPath.row];
        cell.buildModel = model;
        
        return cell;
    } else {
        HomeChoiceCell *cell = (HomeChoiceCell *)[self getCellFromXibName:HomeChoiceCellXibName dequeueTableView:tableView];
        ServiceItemModel *model = self.choiceQYModelArr[indexPath.row];
        cell.corpModel = model;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HomeServiceCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.choiceFYTableView) {
        //NSLog(@"ygz test choiceFYTableView");
        HouseServiceModel *model = self.choiceFYModelArr[indexPath.row];
        FYServiceHouseDetailVC *hoseDetailVC = [[FYServiceHouseDetailVC alloc] init];
        hoseDetailVC.houseId = [model.houseId integerValue];
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:hoseDetailVC animated:YES];
    } else if (tableView == self.choiceLYTableView) {
        //NSLog(@"ygz test choiceLYTableView");
        ServiceItemModel *model = self.choiceLYModelArr[indexPath.row];
        BuildServiceHouseDetailVC *hoseDetailVC = [[BuildServiceHouseDetailVC alloc] init];
        hoseDetailVC.productId = [model.productId integerValue];
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:hoseDetailVC animated:YES];
        
    } else {
        //NSLog(@"ygz test else");
        ServiceItemModel *model = self.choiceQYModelArr[indexPath.row];
        BuildServiceHouseDetailVC *hoseDetailVC = [[BuildServiceHouseDetailVC alloc] init];
        hoseDetailVC.productId = [model.productId integerValue];
        [hoseDetailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:hoseDetailVC animated:YES];
    }
}

#pragma mark - getters and setters
- (WRCustomNavigationBar *)customNavBar
{
    if (_customNavBar == nil) {
        _customNavBar = [WRCustomNavigationBar CustomNavigationBar];
    }
    return _customNavBar;
}

#pragma mark - Private
//配置百度定位
- (void)configBMKLocation{
    //初始化实例
    self.locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    self.locationManager.delegate = self;
    //设置返回位置的坐标系类型
    self.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //设置应用位置类型
    self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    self.locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    self.locationManager.reGeocodeTimeout = 10;
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)gainFirstCharWithString:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

- (void)configDragView{
    //创建拖拽视图
    if ([GlobalConfigClass shareMySingle].userAndTokenModel.token!=nil && ([[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqualToString:@"2"] || [[GlobalConfigClass shareMySingle].userAndTokenModel.memberType isEqual:@"5"]) && [[GlobalConfigClass shareMySingle].userAndTokenModel.authStatus isEqual:@"9"]) {
        
        if (self.dragView == nil) {
            self.dragView = [[WMDragView alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
            //    [self.dragView.button setImage:[UIImage imageNamed:@"btn_weituochuzu"] forState:UIControlStateNormal];
            [self.dragView.button setBackgroundImage:[UIImage imageNamed:@"btn_weituochuzu"] forState:UIControlStateNormal];
            self.dragView.layer.cornerRadius = 25;
            self.dragView.isKeepBounds = YES;
            self.dragView.freeRect = CGRectMake(0, 88, ScreenWidth, ScreenHeight-180);
            [self.view addSubview:self.dragView];
            __weak typeof(self) weakSelf = self;
            self.dragView.clickDragViewBlock = ^(WMDragView *dragView){
                [weakSelf gainDelegateHouseData];
            };
        } else {
            [self.view bringSubviewToFront:self.dragView];
        }
    } else {
        [self.dragView removeFromSuperview];
        self.dragView = nil;
    }
}
@end
