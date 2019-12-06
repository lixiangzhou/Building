//
//  AppDelegate.m
//  YouYi
//
//  Created by Macbook Pro on 2019/1/29.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import "WxApi.h"
#import "PayManager.h"
#import "WRNavigationBar.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //导航栏全局配置===现在颜色是蓝色，因为引入的自定义nav 的问题，还没找到怎么设置
//    [[UINavigationBar appearance] setBarTintColor:UIColor.redColor];//设置nav bar背景色
//    [[UINavigationBar appearance] setTintColor:UIColor.redColor];//设置文字、返回按钮颜色
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_icon_back"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_icon_back"]];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];
    [WRNavigationBar wr_widely];
    // WRNavigationBar 不会对 blackList 中的控制器有影响
    [WRNavigationBar wr_setBlacklist:@[@"SpecialController",
                                                                @"TZPhotoPickerController",
                                                                @"TZGifPhotoPreviewController",
                                                                @"TZAlbumPickerController",
                                                                @"TZPhotoPreviewController",
                                                                @"TZVideoPlayerController"]];
    [SVProgressHUD setMaximumDismissTimeInterval:2];
    //百度定位
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BMK_AK authDelegate:nil];
    //要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:BMK_AK  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图启动失败!");
    }
    
    
    //全局数据初始化
//    GlobalConfigClass *configer = [GlobalConfigClass shareMySingle];
//    configer.cityModel = [[FYCityModel alloc] init];
//    configer.cityModel.cityId = @"102";
    
    [self jump2MainRootVC];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 支付
// NOTE: 9.0以后使用新API接口
// 貌似是客户端支付成功后的回调方法，就是的
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.scheme isContainOfString:AliPayScheme]) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^(NSString *msg, BOOL isOK) {
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"AlipaySuccessNotification" object:nil]];
                    [[PayManager shared] showAlert:msg isOK:isOK];
                }];
            }];
        }
        return YES;
    }else if ([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
        
    }
    
    return NO;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"WxpaySuccessNotification" object:nil]];
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                strMsg = @"支付失败";
                break;
        }
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
        [[PayManager shared] showAlert:strMsg isOK:resp.errCode == WXSuccess];
        
        //[self.navigationController popViewControllerAnimated:YES];

    }else {
    }
}

- (void)onReq:(BaseReq *)req {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
    if ([url.scheme isEqualToString:AliPayScheme]) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [HomeNetworkService analysisAlipayWithCallBackResult:resultDic success:^(NSString *msg, BOOL isOK) {
                    [[PayManager shared] showAlert:msg isOK:isOK];
                }];
            }];
        }
    }
    else if([url.host isEqualToString:@"pay"]) {
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

#pragma mark - private
//跳转主界面
-(void)jump2MainRootVC
{
    [[CYLTabBarControllerConfig shared] setRootControllerWithChildResources:@[[CYLTabBarControllerConfig shared].homeResource, [CYLTabBarControllerConfig shared].houseResource, [CYLTabBarControllerConfig shared].serviceResource, [CYLTabBarControllerConfig shared].mineResource]];
    
    //向微信终端注册ID
    [WXApi registerApp:@"wx2b3b6666a7d48a06"  enableMTA:YES];
    NSLog(@"weixin reguster");
}

- (void)jumpToLoginVCWithVC:(UIViewController *)mySelf {
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [loginVC setHidesBottomBarWhenPushed:YES];
    [mySelf.navigationController pushViewController:loginVC animated:YES];
}

@end
