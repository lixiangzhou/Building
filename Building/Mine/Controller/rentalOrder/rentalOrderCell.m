//
//  rentalOrderCell.m
//  Building
//
//  Created by Mac on 2019/3/25.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "rentalOrderCell.h"
@interface rentalOrderCell()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cannelButon;

@end

@implementation rentalOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, CELL_HIGHT)];
    // Initialization code
    //self.width = ScreenWidth;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(rentalOrderItemModel *)model{
    //NSLog(@"setModel:(rentalOrderItemModel *)model");
    //NSLog(@"setModel-model:%@", model.orderId );
    _model=model;
    self.orderIdLabel.text=[NSString stringWithFormat:@"订单编号：%@",model.orderSn];
    switch( [model.orderStatus integerValue] )
    {
        case 0:
            self.orderStatusLabel.text=[NSString stringWithFormat:@"待受理"];
            self.cannelButon.layer.borderWidth = 1;
            self.cannelButon.layer.cornerRadius = 3;
            self.cannelButon.layer.borderColor = ([UIColor colorWithRed:255/255.0 green:99/255.0 blue:77/255.0 alpha:1].CGColor);
            self.cannelButon.alpha = 1;
            //[self.cannelButon addTarget:self action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>];
            self.cannelButon.userInteractionEnabled = YES;
            
            
            break;
        case 1:
            self.orderStatusLabel.text=[NSString stringWithFormat:@"已受理"];
            self.cannelButon.alpha = 0;
            break;
            
        case 2:
        default:
            self.orderStatusLabel.text=[NSString stringWithFormat:@"已取消"];
            self.cannelButon.alpha = 0;
            break;
    }
    //NSLog(@"出租房间:%@", model.houseName );
    self.houseNameLabel.text=[NSString stringWithFormat:@"出租房间：%@",model.houseName];
    self.buildingNameLabel.text=[NSString stringWithFormat:@"所属楼盘：%@",model.buildingName];
    
    //NSLog(@"佣金:%@%@", model.commission, model.commissionUnit );
    if( [model.commission isEqualToString:@""] || ([model.commission intValue]==0) || [model.commissionUnit isEqualToString:@""] )
    {
        self.amountLabel.text=[NSString stringWithFormat:@"出租价格：%@%@",model.amount, model.amountUnit];
    }
    else
        self.amountLabel.text=[NSString stringWithFormat:@"出租价格：%@%@ (佣金:%@%@)",model.amount, model.amountUnit, model.commission, model.commissionUnit ];
}

- (IBAction)cancelClick:(id)sender {
    //NSLog(@"cancelBlock1" );
    if (self.cancelBlock) {
        //NSLog(@"cancelBlock" );
        self.cancelBlock(sender);
        
    }
}


@end
