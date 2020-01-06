//
//  BuildServiceHouseDetailVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/19.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "BuildServiceHouseDetailVC.h"
#import "SDCycleScrollView.h"
#import "FYServiceOrderScanHouseVC.h"
#import "ServiceBuyView.h"
#import "ServiceYuYueView.h"
#import "BuildAndCropServiceOrderVC.h"
#import "BuildAndCropServiceYuYueVC.h"
#import "bsDescription.h"
#import "FYServiceMoreViewController.h"
#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/tree.h>
#import "WMDragViewManager.h"

@interface BuildServiceHouseDetailVC ()<SDCycleScrollViewDelegate, ServiceBuyViewDelegate, ServiceYuYueViewDelegate>
@property (strong, nonatomic) ServiceDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIView *cycleSuperView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;//名称
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//租金
@property (weak, nonatomic) IBOutlet UILabel *gongsiNameLabel;//楼盘名称
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagLabels;
@property (weak, nonatomic) IBOutlet UILabel *serviceJieShaoTitleLabel;//服务介绍
@property (weak, nonatomic) IBOutlet UILabel *serviceJieShaoLabel;//服务介绍
@property (weak, nonatomic) IBOutlet UIView *serviceLine;
@property (weak, nonatomic) IBOutlet UIButton *buyServiceButton;//预约看房
@property (weak, nonatomic) IBOutlet UIWebView *desview;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *desImage;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) ServiceBuyView *buyView;
@property (nonatomic, strong) ServiceYuYueView *yuyueView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (nonatomic, copy)  NSString  * mydescriptionStr;//产品描述
@property (nonatomic, strong) WMDragViewManager *dragViewManager;

@end

@implementation BuildServiceHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务详情";
    self.mydescriptionStr = nil;

    self.cycleScrollView = [[SDCycleScrollView alloc] init];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.pageDotColor = [UIColor whiteColor];
    self.cycleScrollView.currentPageDotColor = BAR_TINTCOLOR;
    [self.cycleSuperView addSubview:self.cycleScrollView];
    __weak typeof(self) weakSelf = self;
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(weakSelf.cycleSuperView);
    }];
    
    self.buyView = [[ServiceBuyView alloc] init];
    self.buyView.delegate = self;
    
    self.yuyueView = [[ServiceYuYueView alloc] init];
    self.yuyueView.delegate = self;
    
    self.desImage.userInteractionEnabled=YES;
    [self.desImage setImage:[UIImage imageNamed:@"list_icon_more.png"]];
    UITapGestureRecognizer *imgTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.desImage addGestureRecognizer:imgTouch];

    
    self.desLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.desLabel addGestureRecognizer:labelTapGestureRecognizer];


    //UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 300, ScreenWidth, 0)];
    //self.desview.frame =
//    self.desview.delegate = self.view;
    self.desview.scrollView.bounces = NO;
    self.desview.scrollView.showsHorizontalScrollIndicator = NO;
    self.desview.scrollView.scrollEnabled = NO;
    [self.desview sizeToFit];
    //获取数据
    [self gainBuildServiceDetailVCData];
    self.dragViewManager = [WMDragViewManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dragViewManager showDragViewFrom:self];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; {

}

#pragma mark - Actions
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    //NSLog(@"%@被点击了",self.desLabel.text);
   bsDescription *bsd = [[bsDescription alloc] init];
    bsd.mydescription = self.mydescriptionStr;
    [bsd setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:bsd animated:YES];
}
//立即购买
- (IBAction)buyServiceButtonAction:(id)sender {
    //ygz test
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil){
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
        return;
    }
    
    
    if (self.detailModel.productInfo.saleWay == 1) {//售卖方式1购买2预约
        [self.buyView show];
    } else {
        [self.yuyueView show];
    }
}
- (void)lookMoreAction {
    FYServiceMoreViewController *vc = [FYServiceMoreViewController new];
    vc.title = @"服务介绍";
    vc.data = self.mydescriptionStr;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - requests
//获取楼宇服务房间详情
- (void)gainBuildServiceDetailVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainServiceDetailProductIda:self.productId success:^(ServiceDetailModel *detail) {
        weakSelf.detailModel = detail;
        
        self.navigationItem.title = detail.productInfo.name;

        weakSelf.cycleScrollView.imageURLStringsGroup = detail.productInfo.detailImg;
        weakSelf.serviceNameLabel.text = detail.productInfo.name;//名称
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%@", detail.productInfo.price];//租金
        weakSelf.gongsiNameLabel.text = detail.productInfo.supplierName;//
        NSArray *tagsArray = [detail.productInfo.label componentsSeparatedByString:@" "];//以“ ”切割
        NSInteger tagsCount = tagsArray.count < weakSelf.tagLabels.count ? tagsArray.count : weakSelf.tagLabels.count;
        for (int i = 0; i < tagsCount; i++) {
            UILabel *tagLabel = weakSelf.tagLabels[i];
            NSString *tagStr = [NSString stringWithFormat:@" %@ ", tagsArray[i]];
            tagLabel.text = tagStr;
            [tagLabel setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
        }
        //weakSelf.serviceJieShaoLabel.text = detail.productInfo.mydescription;//房源介绍
        weakSelf.mydescriptionStr = detail.productInfo.mydescription;//房源介绍
        
        //NSLog(@"mydescription:%@", detail.productInfo.mydescription);
        
        if (detail.productInfo.mydescription.length) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[detail.productInfo.mydescription dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
            style.lineSpacing = 6;
            [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:self.serviceJieShaoLabel.textColor range:NSMakeRange(0, str.length)];
            [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
            
            self.serviceJieShaoLabel.attributedText = str;
            
//            CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
//            
//            [self.serviceJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(MIN(size.height, 60)));
//            }];
            
//            [self.view layoutIfNeeded];
//            [self.serviceJieShaoLabel sizeToFit];
//
//            [self.serviceJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(self.serviceJieShaoLabel.height));
//            }];
            
//            if (str.length > 1) {
                UIButton *btn = [[UIButton alloc] init];
                [btn setTitle:@"查看详情" forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromHEX(0x999999) forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
                [self.contentView addSubview:btn];
                [btn sizeToFit];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.serviceJieShaoLabel.mas_bottom).offset(20);
                    make.width.equalTo(@(btn.size.width + 10));
                    make.height.equalTo(@(btn.size.height + 10));
                }];
                
                UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
                arrow.userInteractionEnabled = YES;
                [self.contentView addSubview:arrow];
                
                [arrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMoreAction)]];
                
                [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMoreAction)]];
                
                [btn addTarget:self action:@selector(lookMoreAction) forControlEvents:UIControlEventTouchUpInside];
                
                [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.serviceJieShaoLabel);
                    make.centerY.equalTo(btn);
                    make.width.equalTo(@4);
                    make.height.equalTo(@9);
                    make.left.equalTo(btn.mas_right).offset(0);
                }];
//            } else {
//                self.serviceJieShaoTitleLabel.hidden = YES;
//                self.serviceLine.hidden = YES;
//                self.serviceJieShaoLabel.text = nil;
//            }
        } else {
            self.serviceJieShaoTitleLabel.hidden = YES;
            self.serviceLine.hidden = YES;
            self.serviceJieShaoLabel.text = nil;
            [self.serviceJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
        
//        [weakSelf.desview loadHTMLString:detail.productInfo.mydescription baseURL:nil];
        //[self htmlParseToString:detail.productInfo.mydescription];

        if (detail.productInfo.saleWay == 1) {//售卖方式1购买2预约
            [self.buyServiceButton setTitle:@"立即购买" forState:UIControlStateNormal];
        } else {
            [self.buyServiceButton setTitle:@"立即预约" forState:UIControlStateNormal];
        }
        
        weakSelf.buyView.detailModel = detail;
        weakSelf.yuyueView.detailModel = detail;
        
        
        [self.view layoutIfNeeded];
        
        CGFloat maxY = CGRectGetMaxY(self.serviceJieShaoLabel.frame);
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(maxY + 50));
        }];
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, maxY + 50);
    } failure:^(id response) {
        [weakSelf showHint:response];
    }];
}

#pragma mark - ServiceBuyViewDelegate
- (void)coverViewTapAction{
    [self.buyView hide];
}

- (void)toPayBtnAction{
    BuildAndCropServiceOrderVC *hoseDetailVC = [[BuildAndCropServiceOrderVC alloc] init];
    hoseDetailVC.detailModel = self.detailModel;
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
    
    [self.buyView hide];
}

#pragma mark - ServiceYuYueViewDelegate
- (void)toPayBtnActionOfServiceYuYueView{
    BuildAndCropServiceYuYueVC *hoseDetailVC = [[BuildAndCropServiceYuYueVC alloc] init];
    hoseDetailVC.detailModel = self.detailModel;
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
    
    [self.yuyueView hide];
}
- (void)coverViewTapActionOfServiceYuYueView{
    
    self.yuyueView.hidden = YES;
}
@end
