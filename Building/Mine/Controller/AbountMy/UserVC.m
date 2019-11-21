//
//  UserVC.m
//  Building
//
//  Created by Mac on 2019/3/14.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "UserVC.h"

@interface UserVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //读取文本文件
    [self.navigationItem setTitle:@"优易办用户服务协议"];
    [self readFromText];
}

-(void)readFromText{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"readme" ofType:@"txt"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    });
//    if (textFieldContents==nil) {
//        NSLog(@"---error--%@",[error localizedDescription]);
//    }
//    NSArray *lines=[textFieldContents componentsSeparatedByString:@"\n"];
    
    
}

@end
