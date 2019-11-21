//
//  rentalOderDetail.m
//  Building
//
//  Created by Mac on 2019/3/26.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "rentalOderDetail.h"

@interface rentalOderDetail ()
@property (weak, nonatomic) IBOutlet UILabel *housNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *canelTimeLabel;

@property(nonatomic,copy)NSString *token;


@end

@implementation rentalOderDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"委托出租单"];
    //NSLog(@"rentalOderDetail");
    if ([GlobalConfigClass shareMySingle].userAndTokenModel == nil) {//未登录
        self.token = nil;
    } else {
        self.token = [GlobalConfigClass shareMySingle].userAndTokenModel.token;
    }
    [self gainData];
    // Do any additional setup after loading the view from its nib.
}

-(void)gainData{
    
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.orderId forKey:@"orderId"];

    __weak __typeof__ (self) wself = self;
    [MineNetworkService gainRentalOrderDetailWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        rentalOrderDetailModel *model=response;
        wself.housNameLabel.text=[NSString stringWithFormat:@"出租房间：%@",model.houseName];
        wself.buildingNameLabel.text=[NSString stringWithFormat:@"所属楼盘：%@",model.buildingName];
        
        //NSLog(@"佣金:%@%@", model.commission, model.commissionUnit );
        if( [model.commission isEqualToString:@""] || ([model.commission intValue]==0) || [model.commissionUnit isEqualToString:@""] )
        {
            wself.amoutLabel.text=[NSString stringWithFormat:@"出租价格：%@%@",model.amount, model.amountUnit];
        }
        else
            wself.amoutLabel.text=[NSString stringWithFormat:@"出租价格：%@%@ (佣金:%@%@)",model.amount, model.amountUnit, model.commission, model.commissionUnit ];
        wself.orderIdLabel.text=[NSString stringWithFormat:@"订单编号：%@",model.orderSn];
        //NSLog(@"下单:%@,受理:%@,取消:%@",model.createTime,model.acceptTime,model.cancelTime);
        switch( [model.orderStatus integerValue] )
        {
            case 0:
                self.orderStatusLabel.text=[NSString stringWithFormat:@"订单状态:  待受理"];
                self.cancelButton.layer.borderWidth = 1;
                self.cancelButton.layer.cornerRadius = 3;
                self.cancelButton.layer.borderColor = ([UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1].CGColor);
                self.cancelButton.alpha = 1;
                self.cancelButton.userInteractionEnabled = YES;
                if([model.createTime isEqualToString:@""] )
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间: "];
                else
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",model.createTime];
                
                self.acceptTimeLabel.alpha = 0;
                self.canelTimeLabel.alpha = 0;
                break;
                
            case 1:
                self.orderStatusLabel.text=[NSString stringWithFormat:@"订单状态:  已受理"];
                self.cancelButton.alpha = 0;
                
                if([model.createTime isEqualToString:@""] )
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间: "];
                else
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",model.createTime];
                
                if([model.acceptTime isEqualToString:@""] )
                    self.acceptTimeLabel.text =[NSString stringWithFormat:@"受理时间："];
                else
                    self.acceptTimeLabel.text =[NSString stringWithFormat:@"受理时间：%@",model.acceptTime];
                
                self.canelTimeLabel.alpha = 0;
                break;
                
            case 2:
            default:
                self.orderStatusLabel.text=[NSString stringWithFormat:@"订单状态:  已取消"];
                self.cancelButton.alpha = 0;
                
                if([model.createTime isEqualToString:@""] )
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间: "];
                else
                    self.creatTimeLabel.text =[NSString stringWithFormat:@"下单时间：%@",model.createTime];
                
                if([model.cancelTime isEqualToString:@""] )
                    self.acceptTimeLabel.text =[NSString stringWithFormat:@"取消时间："];
                else
                    self.acceptTimeLabel.text =[NSString stringWithFormat:@"取消时间：%@",model.cancelTime];
                //self.canelTimeLabel.text =[NSString stringWithFormat:@"取消时间：%@",model.cancelTime];
                self.canelTimeLabel.alpha = 0;
                break;
        }
    }failure:^(id  _Nonnull response) {
        [wself showHint:response];
    }];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)CancelButonclick:(id)sender {
    //头参数
    NSMutableDictionary* paramsHeader = [[NSMutableDictionary alloc] init];
    if (self.token != nil) {
        [paramsHeader setObject:self.token forKey:@"token"];
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:self.orderId forKey:@"orderId"];
    
    //NSLog(@"headerParams:%@",paramsHeader);
    __weak __typeof__ (self) wself = self;
    [MineNetworkService disCancelRentalOrderWithParams:params headerParams:paramsHeader Success:^(id  _Nonnull response) {
        [wself showHint:response];
        [wself.navigationController popViewControllerAnimated:YES];
        //NSLog(@"disCancelRentalOrderWithParams:%@",response);
    } failure:^(id  _Nonnull response) {
        [wself showHint:@"取消委托失败"];
    }];
}

@end
