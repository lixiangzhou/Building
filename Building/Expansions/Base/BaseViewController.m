//
//  BaseViewController.m
//  QSWeibo
//
//  Created by qingsong on 16/5/31.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "BaseViewController.h"

#import "AppDelegate.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.view setBackgroundColor:UIColorFromHEX(0xf2f2f2)];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *backBtn = [[UIButton alloc] init];
        [backBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popViewControllerDelay) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    }
}
    
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear - > %@", self.class);
}

- (void)setNavBarTitle:(NSString *)title {
    
    self.navigationItem.title = title;
}

- (void)navigationPushWithClassName:(NSString *)className {
    
    Class class_name = NSClassFromString(className);
    if (class_name) {
        UIViewController *ctrl = class_name.new;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (UIButton *)rightBarButtonWithText:(NSString *)title
                            selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 65, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:UIFontWithSize(17)];
    [button setTintColor:UIColorFromHEX(0xd0fffe)];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    return button;
}

- (UIButton *)rightBarButtonWithImage:(NSString *)imageName
                            selector:(SEL)selector {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 65, 44)];
    [button setImage:UIImageWithName(imageName) forState:UIControlStateNormal];
    [button setImage:UIImageWithName(imageName) forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -35)];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    return button;
}

- (void)popViewControllerWithDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(popViewControllerDelay) withObject:self afterDelay:delay];
}

- (void)popViewControllerDelay {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/**
 设置我的未读标记
 */
- (void)setupMineTabbarBadge {

//    [LoginNetworkService gainBubbleInfoOfPersonViewPuid:[GlobalConfigClass shareMySingle].uid success:^(id response) {
//        
//        PersonBubbleInfoModel *badgeModel = (PersonBubbleInfoModel *)response;
//        
//        AppDelegate *delegate = APP_DELEGATE;
//        if ([delegate.window.rootViewController isKindOfClass:[CYLTabBarController class]]) {
//            
//            CYLTabBarController *rootVC = (CYLTabBarController *)delegate.window.rootViewController;
//            if (rootVC && rootVC.tabBar.items.count > 0) {
//                UITabBarItem *firstItem = rootVC.tabBar.items.lastObject;
//                if ((badgeModel.doctor && badgeModel.doctorRed)
//                    || badgeModel.reportRed) {
//                    
//                    //it is necessary to adjust badge position
//                    firstItem.badgeCenterOffset = CGPointMake(0, 0);
//                    [firstItem showBadge];
//                } else {
//                    [firstItem clearBadge];
//                }
//            }
//        }
//        
//    } failure:^(id response) {
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gain cell
- (UITableViewCell *)getCellFromXibName:(NSString *)xibName cellIdentifier:(NSString *)cellIdentifier dequeueTableView:(UITableView *)tableView {
    
    static NSString *identifier ;
    identifier = cellIdentifier;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (UITableViewCell *)getCellFromXibName:(NSString *)xibName dequeueTableView:(UITableView *)tableView {
    
    return [self getCellFromXibName:xibName cellIdentifier:xibName dequeueTableView:tableView];
}
@end
