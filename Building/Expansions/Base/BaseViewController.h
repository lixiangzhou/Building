//
//  BaseViewController.h
//  QSWeibo
//
//  Created by qingsong on 16/5/31.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  设置导航栏的Title
 *
 *  @param title
 */
- (void)setNavBarTitle:(NSString *)title;

/**
 *  根据Xib，返回Cell
 *
 *  @param xibName   cell的名字
 *  @param tableView Tableview
 *
 *  @return UITableView对象
 */
- (UITableViewCell *)getCellFromXibName:(NSString *)xibName
                       dequeueTableView:(UITableView *)tableView;

// 多一个cellIdentifier 参数
- (UITableViewCell *)getCellFromXibName:(NSString *)xibName
                         cellIdentifier:(NSString *)cellIdentifier
                       dequeueTableView:(UITableView *)tableView;

/**
 *  快捷跳转的方法
 *
 *  @param className Push
 */
- (void)navigationPushWithClassName:(NSString *)className;
/**
 *  初始化Tab 按钮
 *
 *  @param title    标题
 *  @param selector 选择子
 *
 *  @return Button实例
 */
- (UIButton *)rightBarButtonWithText:(NSString *)title
                            selector:(SEL)selector;
// 设置RightItem 为图片
- (UIButton *)rightBarButtonWithImage:(NSString *)imageName
                            selector:(SEL)selector;

- (void)popViewControllerWithDelay:(NSTimeInterval)delay;

/**
 设置我的未读标记
 */
- (void)setupMineTabbarBadge;

@end
