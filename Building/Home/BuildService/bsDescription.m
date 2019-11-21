//
//  bsDescription.m
//  Building
//
//  Created by Mac on 2019/4/2.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "bsDescription.h"
#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/tree.h>

@interface bsDescription ()

@end

@implementation bsDescription

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"服务介绍";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.scrollEnabled = YES;
    
    [webView sizeToFit];

    //NSLog(@"bsDescription:%@", self.mydescription );
    [webView loadHTMLString:self.mydescription baseURL:nil];
    
    [self.view addSubview:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js=@"var script = document.createElement('script');"
   "script.type = 'text/javascript';"
   "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];


    //NSLog(@"webViewDidFinishLoad:%@", webView );
        //获取页面高度（像素）
//        NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//        float clientheight = [clientheight_str floatValue];
//        //设置到WebView上
//        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, clientheight);
//        //获取WebView最佳尺寸（点）
//        CGSize frame = [webView sizeThatFits:webView.frame.size];
//        //获取内容实际高度（像素）
//        NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
//        float height = [height_str floatValue];
//        //内容实际高度（像素）* 点和像素的比
//        height = height * frame.height / clientheight;
//        //再次设置WebView高度（点）
//        webView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
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
