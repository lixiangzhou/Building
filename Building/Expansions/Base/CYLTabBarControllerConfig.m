//
//  CYLTabBarControllerConfig.m
//  DimaPatient
//
//  Created by qingsong on 16/6/15.
//  Copyright © 2016年 certus. All rights reserved.
//

#import "CYLTabBarControllerConfig.h"

@import Foundation;
@import UIKit;
@interface CYLBaseNavigationController : UINavigationController
@end
@implementation CYLBaseNavigationController


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    NSLog(@"PUSH => %@", viewController.class);
    [super pushViewController:viewController animated:animated];
}
    
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [super popViewControllerAnimated:animated];
    NSLog(@"POP <= %@", vc.class);
    return vc;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end




//View Controllers
#import "HouseResourceViewController.h"
#import "ServiceViewController.h"
//#import "MallGoodsListViewController.h"
#import "PersonViewController.h"
#import "HomePageViewController.h"
//首页、房源、服务、我的

@interface CYLTabBarControllerConfig ()

//@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@property (nonatomic, strong) NSDictionary *homeResource;
@property (nonatomic, strong) NSDictionary *houseResource;
@property (nonatomic, strong) NSDictionary *serviceResource;
@property (nonatomic, strong) NSDictionary *mineResource;

@property (nonatomic, strong) NSArray *lastResources;
@end

@implementation CYLTabBarControllerConfig

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CYLTabBarControllerConfig new];
    });
    return instance;
}
/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
//- (CYLTabBarController *)tabBarController {
//    if (_tabBarController == nil) {
//        /**
//         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
//         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
//         * 更推荐后一种做法。
//         */
//        UIEdgeInsets imageInsets = UIEdgeInsetsMake(-1.5, 0, 1.5, 0);
//        UIOffset titlePositionAdjustment = UIOffsetMake(0, -3);//UIOffsetMake(0, MAXFLOAT);
//
//        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment];
//
//        [self customizeTabBarAppearance:tabBarController];
//        _tabBarController = tabBarController;
//    }
//    return _tabBarController;
//}

//- (NSArray *)viewControllers {
//    // 首页
//    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
//    UIViewController *homePageNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:homePageViewController];
//
//    // 房源
//    HouseResourceViewController *houseViewController = [[HouseResourceViewController alloc] init];
//    UIViewController *houseNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:houseViewController];
//
//    // 服务
//    ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
//    UIViewController *serviceNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:serviceViewController];
//
//    // 我的
//    PersonViewController *personViewController = [[PersonViewController alloc] init];
//    UIViewController *personViewNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:personViewController];
//
//
//
//    NSMutableArray *viewControllers = @[homePageNavigationController,
//                                        houseNavigationController,
//                                        serviceNavigationController,
//                                        personViewNavigationController,
//                                        ].mutableCopy;
//
//    return viewControllers;
//}

- (void)setRootControllerWithChildResources:(NSArray *)childResources {
    BOOL isEqual = YES;
    if (self.lastResources.count) {
        if (childResources.count != self.lastResources.count) {
            isEqual = NO;
        } else {
            for (NSDictionary *item in childResources) {
                if([self.lastResources containsObject:item] == NO) {
                    isEqual = NO;
                    break;
                }
            }
        }
    } else {
        isEqual = NO;
    }
    
    if (isEqual == NO) {
        self.lastResources = childResources;
        
        UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        NSInteger index = -1;
        if ([tabBarVC isKindOfClass:[UITabBarController class]]) {
            UIViewController *selectedVC = tabBarVC.selectedViewController;
            
            for (NSInteger i = 0; i < childResources.count; i++) {
                UIViewController *vc = childResources[i][@"vc"];
                if ([selectedVC isEqual:vc]) {
                    index = i;
                }
            }
        }
        
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [self getTabBarControllerWithChildResources:childResources];
        
        if (index >= 0) {
            UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBarVC.selectedIndex = index;
        }
//        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
}

- (CYLTabBarController *)getTabBarControllerWithChildResources:(NSArray *)childResources {
    NSMutableArray *vcs = [NSMutableArray new];
    NSMutableArray *tabs = [NSMutableArray new];
    
    for (NSInteger i = 0; i < childResources.count; i++) {
        UIViewController *vc = childResources[i][@"vc"];
        NSDictionary *tab = childResources[i][@"tab"];
        [vcs addObject:vc];
        [tabs addObject:tab];
    }
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(-1.5, 0, 1.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3);//UIOffsetMake(0, MAXFLOAT);
    
    CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:vcs tabBarItemsAttributes:tabs imageInsets:imageInsets titlePositionAdjustment:titlePositionAdjustment];
    
    [self customizeTabBarAppearance:tabBarController];
    
    return tabBarController;
}

- (NSArray *)tabBarItemsAttributesForController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"tab_icon_home_n",
                            CYLTabBarItemSelectedImage : @"tab_icon_home_h",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"房源",
                            CYLTabBarItemImage : @"tab_icon_fangyuan_n",
                            CYLTabBarItemSelectedImage : @"tab_icon_fangyuan_h",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"服务",
                            CYLTabBarItemImage : @"tab_icon_fuwu_n",
                            CYLTabBarItemSelectedImage : @"tab_icon_fuwu_h",
                            };
    
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"tab_icon_me_n",
                            CYLTabBarItemSelectedImage : @"tab_icon_me_h"
                            };
    NSMutableArray *tabBarItemsAttributes = @[
                                              dict1,
                                              dict2,
                                              dict3,
                                              dict4
                                              ].mutableCopy;

    return tabBarItemsAttributes;
}

- (NSDictionary *)homeResource {
    if (_homeResource == nil) {
        // 首页
        HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
        UIViewController *homePageNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:homePageViewController];
        
        _homeResource = @{@"vc": homePageNavigationController, @"tab": @{
                                  CYLTabBarItemTitle : @"首页",
                                  CYLTabBarItemImage : @"tab_icon_home_n",
                                  CYLTabBarItemSelectedImage : @"tab_icon_home_h",
                                  }};
    }
    return _homeResource;
}

- (NSDictionary *)houseResource {
    if (_houseResource == nil) {
        // 房源
        HouseResourceViewController *houseViewController = [[HouseResourceViewController alloc] init];
        UIViewController *houseNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:houseViewController];
        
        _houseResource = @{@"vc": houseNavigationController, @"tab": @{
                                   CYLTabBarItemTitle : @"房源",
                                   CYLTabBarItemImage : @"tab_icon_fangyuan_n",
                                   CYLTabBarItemSelectedImage : @"tab_icon_fangyuan_h",
                                   }};
    }
    return _houseResource;
}

- (NSDictionary *)serviceResource {
    if (_serviceResource == nil) {
        // 服务
        ServiceViewController *serviceViewController = [[ServiceViewController alloc] init];
        UIViewController *serviceNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:serviceViewController];
        _serviceResource = @{@"vc": serviceNavigationController, @"tab": @{
                                     CYLTabBarItemTitle : @"服务",
                                     CYLTabBarItemImage : @"tab_icon_fuwu_n",
                                     CYLTabBarItemSelectedImage : @"tab_icon_fuwu_h",
                                     }};
    }
    return _serviceResource;
}

- (NSDictionary *)mineResource {
    if (_mineResource == nil) {
        // 服务
        // 我的
        PersonViewController *personViewController = [[PersonViewController alloc] init];
        UIViewController *personViewNavigationController = [[CYLBaseNavigationController alloc] initWithRootViewController:personViewController];
        _mineResource = @{@"vc": personViewNavigationController, @"tab": @{
                                  CYLTabBarItemTitle : @"我的",
                                  CYLTabBarItemImage : @"tab_icon_me_n",
                                  CYLTabBarItemSelectedImage : @"tab_icon_me_h"
                                  }};
    }
    return _mineResource;
}



///**
// *  在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
// */
//- (void)setUpTabBarItemsAttributesForController:(CYLTabBarController *)tabBarController {
//
//    NSDictionary *dict1 = @{
//                            CYLTabBarItemTitle : @"首页",
//                            CYLTabBarItemImage : @"Home",
//                            CYLTabBarItemSelectedImage : @"Home-h",
//                            };
//    NSDictionary *dict2 = @{
//                            CYLTabBarItemTitle : @"房源",
//                            CYLTabBarItemImage : @"Health",
//                            CYLTabBarItemSelectedImage : @"Health-h",
//                            };
//    NSDictionary *dict3 = @{
//                            CYLTabBarItemTitle : @"服务",
//                            CYLTabBarItemImage : @"sunny_store",
//                            CYLTabBarItemSelectedImage : @"sunny_store_h",
//                            };
//
//    NSDictionary *dict4 = @{
//                            CYLTabBarItemTitle : @"我的",
//                            CYLTabBarItemImage : @"person",
//                            CYLTabBarItemSelectedImage : @"person-h"
//                            };
//    NSMutableArray *tabBarItemsAttributes = @[
//                                              dict1,
//                                              dict2,
//                                              dict3,
//                                              dict4
//                                              ].mutableCopy;
//
//    tabBarController.tabBarItemsAttributes = tabBarItemsAttributes.copy;
//}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
//#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = UIColorFromHEX(0x868686);
//    normalAttrs[NSFontAttributeName] = [UIFont fontWithName:@"System Medium" size:12.0f];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = UIColorFromHEX//(0x39c7c5);
    (0x007eff);
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    //    [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight， remove the comment '//'
    //如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    //    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    //remove the bar system shadow image
    //去除 TabBar 自带的顶部阴影
//        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

//- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
//    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
//        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
//            DLog(@"Landscape Left or Right !");
//        } else if (orientation == UIDeviceOrientationPortrait){
//            DLog(@"Landscape portrait!");
//        }
//        [self customizeTabBarSelectionIndicatorImage];
//    };
//    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:deviceOrientationDidChangeBlock];
//}
//
//- (void)customizeTabBarSelectionIndicatorImage {
//    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
//    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
//    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
//    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
//    //Get initialized TabBar if exists.
//    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
//    [tabBar setSelectionIndicatorImage:
//     [[self class] imageWithColor:[UIColor redColor]
//                             size:selectionIndicatorImageSize]];
//}
//
//+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
//    if (!color || size.width <= 0 || size.height <= 0) return nil;
//    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, color.CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
