//
//  MyRefundCell.m
//  Building
//
//  Created by Mac on 2019/3/11.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyRefundCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyRefundCell()
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation MyRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(RefundItemModel *)model{
    _model=model;
    self.orderSnLabel.text=[NSString stringWithFormat:@"订单编号：%@",model.orderSn];
    //订单状态  0：待审核，1：已同意，2：已拒绝 3：待打款 4：已打款
    
    if ([model.refundStatus integerValue] == 0) {
        self.orderStatuLabel.text = @"待审核";
        self.cannelBtn.alpha=1;
         [self.cannelBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
    } else if ([model.refundStatus integerValue] == 1) {
        self.orderStatuLabel.text = @"已同意";
    } else if([model.refundStatus integerValue] ==2){
         self.orderStatuLabel.text = @"已拒绝";
    }else if([model.refundStatus integerValue] ==3){
        self.orderStatuLabel.text = @"待打款";
         //self.cannelBtn.alpha=1;
        //[self.cannelBtn setTitle:@"撤销申请" forState:UIControlStateNormal];
    }else{
         self.orderStatuLabel.text = @"已打款";
        self.cannelBtn.alpha=0;
        [self.cannelBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        self.confirmBtn.alpha=0;
        
    }

    NSURL *url = [NSURL URLWithString:model.productDetailImg];
    [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.nameLabel.text=model.productName;
    self.skuLabel.text=model.productSku;
    self.skuLabel.numberOfLines=0;
    self.companyLabel.text=model.supplierName;
    self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
    self.countLabel.text=model.quantity;
    self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
    
    
}
- (IBAction)cannelBtn:(id)sender {
    if (self.cannelBlock) {
        self.cannelBlock(sender);
        //NSLog(@"cancelBlock");
    }
    
}


- (IBAction)confirmBtn:(id)sender {
    if (self.confirmBlock) {
        self.confirmBlock(sender);
    }
}


@end
