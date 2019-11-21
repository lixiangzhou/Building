//
//  CropServiceHouseDetailVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/19.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "CropServiceHouseDetailVC.h"
#import "SDCycleScrollView.h"
#import "FYServiceOrderScanHouseVC.h"
#import "ServiceBuyView.h"
#import "BuildAndCropServiceOrderVC.h"
#import "ServiceYuYueView.h"
#import "BuildAndCropServiceYuYueVC.h"

@interface CropServiceHouseDetailVC ()<SDCycleScrollViewDelegate, ServiceBuyViewDelegate, ServiceYuYueViewDelegate>
@property (strong, nonatomic) ServiceDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIView *cycleSuperView;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;//名称
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//租金
@property (weak, nonatomic) IBOutlet UILabel *gongsiNameLabel;//楼盘名称
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagLabels;
@property (weak, nonatomic) IBOutlet UILabel *serviceJieShaoLabel;//房源介绍
@property (weak, nonatomic) IBOutlet UIButton *buyServiceButton;//预约看房

@property (nonatomic, strong) ServiceBuyView *buyView;
@property (nonatomic, strong) ServiceYuYueView *yuyueView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@end

@implementation CropServiceHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.buyView.hidden = YES;
    self.buyView.delegate = self;
    [self.view addSubview:self.buyView];
    [self.buyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(weakSelf.cycleSuperView);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    self.yuyueView = [[ServiceYuYueView alloc] init];
    self.yuyueView.hidden = YES;
    self.yuyueView.delegate = self;
    [self.view addSubview:self.yuyueView];
    [self.yuyueView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.mas_equalTo(weakSelf.cycleSuperView);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
    }];
    
    //获取数据
    [self gainBuildServiceDetailVCData];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; {

}

#pragma mark - Actions
//立即购买
- (IBAction)buyServiceButtonAction:(id)sender {
    if (self.detailModel.productInfo.saleWay == 1) {//售卖方式1购买2预约
        self.buyView.hidden = NO;
    } else {
        self.yuyueView.hidden = NO;
    }
}

#pragma mark - requests
//获取楼宇服务房间详情
- (void)gainBuildServiceDetailVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainServiceDetailProductIda:self.productId success:^(ServiceDetailModel *detail) {
        NSLog(@"gainBuildServiceDetailVCData:%@", detail);
        weakSelf.detailModel = detail;
        
        self.navigationItem.title = detail.productInfo.name;

        weakSelf.cycleScrollView.imageURLStringsGroup = detail.productInfo.detailImg;
        weakSelf.serviceNameLabel.text = detail.productInfo.name;//名称
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%@", detail.productInfo.price];//租金
        weakSelf.gongsiNameLabel.text = detail.productInfo.supplierName;//
        NSArray *tagsArray = [detail.productInfo.label componentsSeparatedByString:@" "];//以“ ”切割
        NSInteger tagsCount = tagsArray.count < weakSelf.tagLabels.count ? tagsArray.count : weakSelf.tagLabels.count;
        for (int i = 0; i < tagsCount; i++) {
            UILabel *tagLabel = [NSString stringWithFormat:@" %@ ", weakSelf.tagLabels[i]];
            NSString *tagStr = tagsArray[i];
            tagLabel.text = tagStr;
            //tagLabel.frame = CGRectMake(10, 20, 100, 16);
            [tagLabel setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
        }
        weakSelf.serviceJieShaoLabel.text = detail.productInfo.mydescription;//房源介绍
        NSLog(@"mydescription:%@", detail.productInfo.mydescription);
        if (detail.productInfo.saleWay == 1) {//售卖方式1购买2预约
            [weakSelf.buyServiceButton setTitle:@"立即购买" forState:UIControlStateNormal];
        } else {
            [weakSelf.buyServiceButton setTitle:@"立即预约" forState:UIControlStateNormal];
        }
        
        weakSelf.buyView.detailModel = detail;
        weakSelf.yuyueView.detailModel = detail;
    } failure:^(id response) {
        [weakSelf showHint:response];
    }];
}

#pragma mark - ServiceBuyViewDelegate
- (void)coverViewTapAction{
    self.buyView.hidden = YES;
}

- (void)toPayBtnAction{
    BuildAndCropServiceOrderVC *hoseDetailVC = [[BuildAndCropServiceOrderVC alloc] init];
    hoseDetailVC.detailModel = self.detailModel;
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
    
    self.buyView.hidden = YES;
}

#pragma mark - ServiceYuYueViewDelegate
- (void)toPayBtnActionOfServiceYuYueView{
    BuildAndCropServiceYuYueVC *hoseDetailVC = [[BuildAndCropServiceYuYueVC alloc] init];
    hoseDetailVC.detailModel = self.detailModel;
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
    
    self.yuyueView.hidden = YES;
}
- (void)coverViewTapActionOfServiceYuYueView{
    
    self.yuyueView.hidden = YES;
}
@end
