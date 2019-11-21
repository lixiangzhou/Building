//
//  AboutMeVC.m
//  Building
//
//  Created by Mac on 2019/3/14.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "AboutMeVC.h"
#import "UserVC.h"

@interface AboutMeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *aboutImg;

@end

@implementation AboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于我们"];
    [self.aboutImg setImage:[UIImage imageNamed:@"launchlogo.png"]];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)aboutBtn:(id)sender {
    UserVC *ac=[[UserVC alloc] init];
    [ac setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ac animated:YES];
}

@end
