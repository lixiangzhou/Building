//
//  FYServiceMoreViewController.m
//  Building
//
//  Created by Macbook Pro on 2019/4/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceMoreViewController.h"

@interface FYServiceMoreViewController ()

@end

@implementation FYServiceMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *txtView = [UITextView new];
    
    txtView.editable = NO;
    [self.view addSubview:txtView];
    
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@10);
        make.bottom.right.equalTo(@-10);
    }];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[self.data dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, str.length)];
    txtView.attributedText = str;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
