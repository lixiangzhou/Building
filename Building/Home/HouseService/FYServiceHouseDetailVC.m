//
//  FYServiceHouseDetailVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/19.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceHouseDetailVC.h"
#import "SDCycleScrollView.h"
#import "FYServiceOrderScanHouseVC.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#include <libxml2/libxml/parser.h>
#include <libxml2/libxml/tree.h>
#import "bsDescription.h"
#import "FYServiceMoreViewController.h"
#import "WMDragViewManager.h"

@interface FYServiceHouseDetailVC ()<SDCycleScrollViewDelegate, BMKMapViewDelegate>
@property (strong, nonatomic) FYServiceDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIView *cycleSuperView;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;//房间名称
@property (weak, nonatomic) IBOutlet UILabel *sizeFloorLabel;//平米/楼层
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//租金
@property (weak, nonatomic) IBOutlet UILabel *louPanNameLabel;//楼盘名称
@property (weak, nonatomic) IBOutlet UILabel *serverMoneyLabel;//佣金
@property (weak, nonatomic) IBOutlet UILabel *serverMoneyTitleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *tagLabels;
@property (weak, nonatomic) IBOutlet UILabel *telTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;//联系方式
@property (weak, nonatomic) IBOutlet UILabel *addressTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *houseAreaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaLabel;//房屋面积
@property (weak, nonatomic) IBOutlet UILabel *wuyeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuyeMoneyLabel;//物业管理费
@property (weak, nonatomic) IBOutlet UILabel *floorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *floorLabel;//所在楼层
@property (weak, nonatomic) IBOutlet UILabel *fixStatusTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixStatusLabel;//装修情况
@property (weak, nonatomic) IBOutlet UILabel *areaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//建筑面积
@property (weak, nonatomic) IBOutlet UILabel *buildTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;//建筑年代
@property (weak, nonatomic) IBOutlet UIView *useInfoView;


@property (weak, nonatomic) IBOutlet UILabel *useInfoLabel;//中介操作说明

@property (weak, nonatomic) IBOutlet UILabel *houseJieShaoLabel;//房源介绍
@property (weak, nonatomic) IBOutlet BMKMapView *dituSupperView;
@property (weak, nonatomic) IBOutlet UILabel *gongjiaoLabel;//公交
@property (weak, nonatomic) IBOutlet UILabel *ditieLabel;//地铁
@property (weak, nonatomic) IBOutlet UILabel *buildJieShaoLabel;//楼盘介绍
@property (weak, nonatomic) IBOutlet UIButton *scanHouseButton;//预约看房
@property (weak, nonatomic) IBOutlet UIImageView *phoneCallImg;

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (weak, nonatomic) IBOutlet UIWebView *desview;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *desImage;
@property (nonatomic, copy)  NSString  * mydescriptionStr;//产品描述
    
@property (weak, nonatomic) IBOutlet UILabel *userInfoTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoBottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoTitleTopCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoTitleBottomCons;
    
@property (weak, nonatomic) IBOutlet UIView *houseJieshaoView;
@property (weak, nonatomic) IBOutlet UILabel *houseJieshaoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseZhiNanTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (nonatomic, strong) BMKMapView *mapView;//地图
@property (nonatomic, strong) WMDragViewManager *dragViewManager;
@end

@implementation FYServiceHouseDetailVC

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
    
    [self.ditieLabel setNumberOfLines:0];
    self.ditieLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //self.ditieLabel.adjustsFontSizeToFitWidth = YES;
    //self.ditieLabel.minimumScaleFactor = 0.5;
    //self.ditieLabel.frame.size =
    
    //百度地图
    self.dituSupperView.delegate = self;
    [self.dituSupperView setZoomLevel:15];//设置缩放级别
    self.dituSupperView.showsUserLocation = YES;//展示定位
    
//    self.dituSupperView.zoomLevel =15;
    //图片，图片点击事件
    [self.phoneCallImg setImage:[UIImage imageNamed:@"ic_telephone.png"]];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [self.phoneCallImg addGestureRecognizer:tapGesture];
    self.phoneCallImg.userInteractionEnabled = YES;
    
    self.desImage.userInteractionEnabled=YES;
    [self.desImage setImage:[UIImage imageNamed:@"list_icon_more.png"]];
    UITapGestureRecognizer *imgTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.desImage addGestureRecognizer:imgTouch];
    
    
    self.desLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.desLabel addGestureRecognizer:labelTapGestureRecognizer];

    //self.desview.frame =
    self.desview.scrollView.bounces = NO;
    self.desview.scrollView.showsHorizontalScrollIndicator = NO;
    self.desview.scrollView.scrollEnabled = NO;
    [self.desview sizeToFit];

    //获取数据
    [self gainFYServiceSecondLevelVCData];
    self.dragViewManager = [WMDragViewManager new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.dragViewManager showDragViewFrom:self];
    [self.dituSupperView viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dituSupperView viewWillDisappear];
}

#pragma mark - Actions
-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    //NSLog(@"%@被点击了",self.desLabel.text);
    bsDescription *bsd = [[bsDescription alloc] init];
    bsd.mydescription = self.mydescriptionStr;
    [bsd setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:bsd animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index; {

}

#pragma mark - Actions
- (void)lookMoreAction {
    FYServiceMoreViewController *vc = [FYServiceMoreViewController new];
    vc.title = @"房源介绍";
    vc.data = self.detailModel.houseInfo.descriptionIos;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookMoreAction2 {
    FYServiceMoreViewController *vc = [FYServiceMoreViewController new];
    vc.title = @"楼盘介绍";
    vc.data = self.detailModel.buildInfo.introduction;
    [self.navigationController pushViewController:vc animated:YES];
}
    
-(void)clickImage{
    UIWebView *call = [[UIWebView alloc] init];

    NSMutableString *callSrtr=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.telLabel.text];
    [call loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:callSrtr]]];
    [self.view addSubview:call];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:callSrtr]];
    
    //NSLog(@"clickImage:%@", callSrtr);
}


//预约看房
- (IBAction)scanHouseButtonAction:(id)sender {
    //ygz test
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil){
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        [loginVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    FYServiceOrderScanHouseVC *hoseDetailVC = [[FYServiceOrderScanHouseVC alloc] init];
    hoseDetailVC.houseId = self.houseId;
    [hoseDetailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:hoseDetailVC animated:YES];
}

#pragma mark - requests
//获取房源服务房间详情
- (void)gainFYServiceSecondLevelVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainFYServiceHouseDetailHouseId:self.houseId success:^(FYServiceDetailModel *detail) {
        weakSelf.detailModel = detail;
        
        weakSelf.cycleScrollView.imageURLStringsGroup = detail.houseInfo.picList;
        //房间名称
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        style.lineSpacing = 6;
        NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:detail.houseInfo.name attributes:@{NSParagraphStyleAttributeName: style}];
        self.houseNameLabel.attributedText = nameText;
        
        self.sizeFloorLabel.text = [NSString stringWithFormat:@"%@㎡ | %@层", detail.houseInfo.acreage, detail.houseInfo.floor];////平米/楼层
        self.moneyLabel.text = [NSString stringWithFormat:@"%@", detail.houseInfo.price];//租金
        self.louPanNameLabel.text = detail.buildInfo.name;//楼盘名称
        self.mydescriptionStr = detail.houseInfo.descriptionIos;

        
        if ([detail.houseInfo.commission isEqualToString:@""] || (detail.houseInfo.commission == nil) ) {
            self.serverMoneyLabel.hidden = YES;//佣金
            self.serverMoneyTitleLabel.hidden = YES;
        } else {
            self.serverMoneyLabel.text = [NSString stringWithFormat:@"%@", detail.houseInfo.commission];//佣金
        }
        
        NSArray *tagsArray = [detail.houseInfo.label componentsSeparatedByString:@" "];//以“ ”切割
        NSInteger tagsCount = tagsArray.count < self.tagLabels.count ? tagsArray.count : self.tagLabels.count;
        for (int i = 0; i < tagsCount; i++) {
            UILabel *tagLabel = self.tagLabels[i];
            //NSString *tagStr = tagsArray[i];
            NSString *tagStr = [NSString stringWithFormat:@" %@ ", tagsArray[i]];
            tagLabel.text = tagStr;
            [tagLabel setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
        }
        
        self.telLabel.text = detail.buildInfo.wyPhone;//联系方式
        if (!self.telLabel.text.length) {
            [self.telTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.telTitleLabel.hidden = YES;
            self.telLabel.hidden = YES;
            self.phoneCallImg.hidden = YES;
        }
        
        
        self.addressLabel.text = detail.buildInfo.address;//地址
        if (!self.addressLabel.text.length) {
            [self.addressTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.addressTitleLabel.hidden = YES;
            self.addressLabel.hidden = YES;
        }
        
        self.houseAreaLabel.text = [NSString stringWithFormat:@"%@㎡", detail.houseInfo.acreage];//房屋面积
        if (!detail.houseInfo.acreage.length) {
            [self.houseAreaTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.houseAreaTitleLabel.hidden = YES;
            self.houseAreaLabel.hidden = YES;
        }
        
        self.wuyeMoneyLabel.text = detail.buildInfo.wyFee;//物业管理费
        if (!self.wuyeMoneyLabel.text.length) {
            [self.wuyeTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.wuyeTitleLabel.hidden = YES;
            self.wuyeMoneyLabel.hidden = YES;
        }
        
        self.floorLabel.text = [NSString stringWithFormat:@"%@层", detail.houseInfo.floor];//所在楼层
        if (!detail.houseInfo.floor.length) {
            [self.floorTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.floorTitleLabel.hidden = YES;
            self.floorLabel.hidden = YES;
        }
        
        self.fixStatusLabel.text = detail.houseInfo.decoration;//装修情况
        if (!detail.houseInfo.decoration.length) {
            [self.fixStatusTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.fixStatusTitleLabel.hidden = YES;
            self.fixStatusLabel.hidden = YES;
        }
        
        self.areaLabel.text = [NSString stringWithFormat:@"%@㎡", detail.buildInfo.area];//建筑面积
        if (!detail.buildInfo.area.length) {
            [self.areaTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.areaTitleLabel.hidden = YES;
            self.areaLabel.hidden = YES;
        }
        
        self.buildLabel.text = detail.buildInfo.endTime;//建筑年代
        if (!detail.buildInfo.endTime.length) {
            [self.buildTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            self.buildTitleLabel.hidden = YES;
            self.buildLabel.hidden = YES;
        }

//        self.useInfoView.alpha = 0;
//        self.userInfoTitleLabel.text = nil;
//
//        self.userInfoTopCons.constant = 0;
//        self.userInfoBottomCons.constant = 0;
//        self.userInfoTitleTopCons.constant = 0;
//        self.userInfoTitleBottomCons.constant = 0;
        if( [detail.houseInfo.agencyRemark isEqual:nil] || [detail.houseInfo.agencyRemark isEqualToString:@""] || (detail.houseInfo.agencyRemark == nil) )
        {
            self.useInfoView.hidden = YES;
//            self.userInfoTitleLabel.text = nil;
//
//            self.userInfoTitleTopCons.constant = 0;
//            self.userInfoTitleBottomCons.constant = 0;
            [self.useInfoView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperview];
            }];
            [self.useInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.buildTitleLabel.mas_bottom).offset(0);
            }];
        }
        else
        {
            self.useInfoView.hidden = NO;
            self.useInfoLabel.text = detail.houseInfo.agencyRemark;//中介操作说明
        }
        
        void (^houseJieshaoUpdateBlock)(void) = ^ {
            [self.houseJieshaoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.useInfoView.mas_bottom).offset(0);
//                make.bottom.equalTo(self.houseZhiNanTitleLabel.mas_top).offset(0);
            }];
            [self.houseJieshaoTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            [self.houseJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.height.equalTo(@0);
            }];
            self.houseJieshaoView.hidden = YES;
        };
        
//        NSString *contents = [NSString stringWithContentsOfFile:@"/Users/mbp/Desktop/test" encoding:NSUTF8StringEncoding error:nil];
//        detail.houseInfo.descriptionIos = contents;
        
        if (detail.houseInfo.descriptionIos.length) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[detail.houseInfo.descriptionIos dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:self.buildJieShaoLabel.textColor range:NSMakeRange(0, str.length)];
            [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
            self.houseJieShaoLabel.attributedText = str;
            CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            
            [self.houseJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(MIN(size.height, 60)));
            }];
            
//            if (size.height > 60) {
                UIButton *btn = [[UIButton alloc] init];
                [btn setTitle:@"查看详情" forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromHEX(0x999999) forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
                [self.houseJieShaoLabel.superview.superview addSubview:btn];
                [btn sizeToFit];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.houseJieShaoLabel.superview.mas_bottom);
                    make.width.equalTo(@(btn.size.width + 10));
                    make.height.equalTo(@(btn.size.height + 10));
                }];
                
                UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
                arrow.userInteractionEnabled = YES;
                [btn.superview addSubview:arrow];
                
                [arrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMoreAction)]];
                
                [btn addTarget:self action:@selector(lookMoreAction) forControlEvents:UIControlEventTouchUpInside];
                
                [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.houseJieShaoLabel);
                    make.centerY.equalTo(btn);
                    make.width.equalTo(@4);
                    make.height.equalTo(@9);
                    make.left.equalTo(btn.mas_right).offset(0);
                }];
//            } else {
//                houseJieshaoUpdateBlock();
//            }
        } else {
            houseJieshaoUpdateBlock();
        }
        
        self.gongjiaoLabel.text = detail.buildInfo.busInfo;//公交
        self.ditieLabel.text = detail.buildInfo.metroInfo;//地铁
        
        //设置一个行高上限
//        CGSize size = CGSizeMake(self.ditieLabel.frame.size.width, self.ditieLabel.frame.size.height*2);
//        CGSize expect = [self.ditieLabel sizeThatFits:size];
//        self.ditieLabel.frame = CGRectMake( self.ditieLabel.frame.origin.x, self.ditieLabel.frame.origin.y, expect.width, expect.height );

//        self.buildJieShaoLabel.attributedText =  [[NSMutableAttributedString alloc] initWithString:detail.buildInfo.introduction attributes:@{NSParagraphStyleAttributeName: style}];;//楼盘介绍
        if (detail.buildInfo.introduction.length > 0) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[detail.buildInfo.introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, str.length)];
            [str addAttribute:NSForegroundColorAttributeName value:self.buildJieShaoLabel.textColor range:NSMakeRange(0, str.length)];
            [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
            self.buildJieShaoLabel.attributedText = str;
            
            CGSize size = [str boundingRectWithSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            
            [self.buildJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(MIN(size.height, 60)));
            }];
            
            UIButton *btn = [[UIButton alloc] init];
            [btn setTitle:@"查看详情" forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromHEX(0x999999) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [self.buildJieShaoLabel.superview.superview addSubview:btn];
            [btn sizeToFit];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.buildJieShaoLabel.superview.mas_bottom);
                make.width.equalTo(@(btn.size.width + 10));
                make.height.equalTo(@(btn.size.height + 10));
            }];
            
            UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_more"]];
            arrow.userInteractionEnabled = YES;
            [btn.superview addSubview:arrow];
            
            [arrow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookMoreAction2)]];
            
            [btn addTarget:self action:@selector(lookMoreAction2) forControlEvents:UIControlEventTouchUpInside];
            
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.buildJieShaoLabel);
                make.centerY.equalTo(btn);
                make.width.equalTo(@4);
                make.height.equalTo(@9);
                make.left.equalTo(btn.mas_right).offset(0);
            }];
            
            [self.view layoutIfNeeded];
            
            self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.buildJieShaoLabel.superview.frame) + 40);
        } else {
            self.buildJieShaoLabel.text = nil;
            [self.buildJieShaoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
        
        self.navigationItem.title = detail.buildInfo.name;
        
        
        //更新位置数据
        BMKUserLocation *userLocation = [[BMKUserLocation alloc] init];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[detail.buildInfo.latitude doubleValue] longitude:[detail.buildInfo.longitude doubleValue]];
        userLocation.location = location;
        userLocation.title = detail.buildInfo.name;
        [self.dituSupperView updateLocationData:userLocation];
        [self.dituSupperView setCenterCoordinate:userLocation.location.coordinate animated:YES];//设置用户的坐标
        //设置当前位置小蓝点
//        self.dituSupperView.coordinate = userLocation.location.coordinate;
    } failure:^(id response) {
        [self showHint:response];
    }];
}

@end
