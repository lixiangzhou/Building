//
//  FYServiceOrderScanHouseVC.m
//  Building
//
//  Created by Macbook Pro on 2019/2/20.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FYServiceOrderScanHouseVC.h"
#import "RRTextView.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "ZHPickView.h"
#import "MonthTimePicker.h"

@interface FYServiceOrderScanHouseVC ()<UITextViewDelegate>
@property (strong, nonatomic) FYServiceDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeFloorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
    @property (weak, nonatomic) IBOutlet UILabel *serverMoneyTitleLabel;
    @property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;//显示textView剩余可输入字数，已隐藏
@property (weak, nonatomic) IBOutlet RRTextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic, strong)MonthTimePicker *pickDateview;
@property (nonatomic, strong)NSDate *selectDate;

@end

@implementation FYServiceOrderScanHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"预约服务";
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    [_myTextView setBackgroundColor:UIColorFromHEX(0xf7f7f7)];
    [_myTextView setUserInteractionEnabled:YES];
    _myTextView.delegate = self;
    [_myTextView setFont:UIFontWithSize(13)];
    [_myTextView setPlaceholderOriginY:6 andOriginX:2.5];
    _myTextView.placeholder = @"留言信息（最多300字）";
    [_myTextView setPlaceholderColor:UIColorFromHEX(0xbababa)];
    _myTextView.contentInset = UIEdgeInsetsMake(15, 18, 15, 18);
    
    self.pickDateview = [MonthTimePicker new];
    MJWeakSelf
    self.pickDateview.confirmBlock = ^(NSDate * _Nonnull date, NSString *dateString) {
        [weakSelf.view endEditing:YES];
        weakSelf.selectDate = date;
        weakSelf.timeField.text = dateString;
    };
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfViewTapAction:)];
    //gesture.delegate = self;
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];

    if (self.model) {
        [self setData:self.model];
    } else {
        [self gainFYServiceSecondLevelVCData];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)textViewDidChange:(UITextView *)textView
{
    long currentLen = (long)textView.text.length;
    //NSLog(@"currentLen:%ld", currentLen );
    
    if( currentLen >= 300 )
    {
        self.countLabel.text = [NSString stringWithFormat:@"还可输入%ld字",0];
        //textView.editable = NO;
        textView.text = [textView.text substringToIndex:300];
        //return NO;
    }
    else
    {
        //还可输入300字
        self.countLabel.text = [NSString stringWithFormat:@"还可输入%ld字",300-currentLen];
        //textView.editable = YES;
    }
    //return YES;
}

#pragma mark - Actions
//提交按钮
- (IBAction)commitButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        [[UIApplication sharedApplication].delegate performSelector:@selector(jumpToLoginVCWithVC:) withObject:self];
    } else {
        [self orderFYServiceHouse];
    }
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    //NSLog(@"handleBackgroundTap");
    [self.myTextView resignFirstResponder];
    

}

//点击别的区域隐藏虚拟键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //NSLog(@"touchesBegan");
    [self.myTextView resignFirstResponder];
    

    //_myTextView.placeholder.
}
//选择时间
- (IBAction)timeViewTap:(id)sender {
    [self.view endEditing:YES];
    [_pickDateview show];
}

//tap响应函数
- (void)selfViewTapAction:(UITapGestureRecognizer *)tapGesture
{
    //    UIView *itemView = tapGesture.view;
    //    NSLog(@"%ld", (long)itemView.tag);
    
    [self.view endEditing:YES];
    
}


#pragma mark - requests
//获取房源服务房间详情
- (void)gainFYServiceSecondLevelVCData{
    __weak typeof(self) weakSelf = self;
    [HomeNetworkService gainFYServiceHouseDetailHouseId:self.houseId success:^(FYServiceDetailModel *detail) {
        weakSelf.detailModel = detail;
        
        NSURL *url = [NSURL URLWithString:detail.houseInfo.picList[0]];
        [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
        self.nameLabel.text = detail.houseInfo.name;//房间名称
        self.sizeFloorLabel.text = [NSString stringWithFormat:@"%@㎡ | %@层", detail.houseInfo.acreage, detail.houseInfo.floor];////平米/楼层
        self.addressLabel.text = detail.buildInfo.address;//地址
        self.moneyLabel.text = [NSString stringWithFormat:@"%@", detail.houseInfo.price];//租金
        
        self.serverMoneyLabel.text = detail.houseInfo.commission;
        
        if (!self.serverMoneyLabel.text.length) {
            self.serverMoneyTitleLabel.text = nil;
        }
        
        self.phoneField.text = [GlobalConfigClass shareMySingle].userAndTokenModel.mobile;
    } failure:^(id response) {
        [self showHint:response];
    }];
}

//预约房间
- (void)orderFYServiceHouse{
    if ([self.nameField.text isEqualToString:@""] ) {
        [self showHint:self.view text:@"请填写您的姓名"];
        return;
    } else if  ([self.phoneField.text isEqualToString:@""]) {
        [self showHint:self.view text:@"请填写您的手机号"];
        return;
    } else if  ([self.timeField.text isEqualToString:@""]) {
        [self showHint:self.view text:@"请选择您要预约的时间"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSDateFormatter *format = [NSDateFormatter new];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    [HomeNetworkService orderFYServiceHouse:[self.detailModel.houseInfo.houseId integerValue] contact:self.nameField.text contactNumber:self.phoneField.text message:self.myTextView.text subscribeTime:[format stringFromDate:self.selectDate] success:^(NSInteger code) {
        [weakSelf showHint:@"预约成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(id response) {
        [weakSelf showHint:response];
    }];
}
    
- (void)setData:(ServiceDetailModel *)detail {
    
    
    NSURL *url = [NSURL URLWithString:detail.productInfo.detailImg[0]];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.nameLabel.text = detail.productInfo.name;//房间名称
    self.sizeFloorLabel.text = detail.productInfo.supplierName;////平米/楼层
//    self.addressLabel.text = detail.productInfo.label;//地址
    self.moneyLabel.text = detail.productInfo.price;

    self.serverMoneyLabel.text = nil;
    self.serverMoneyTitleLabel.text = nil;

    self.phoneField.text = [GlobalConfigClass shareMySingle].userAndTokenModel.mobile;
}

@end
