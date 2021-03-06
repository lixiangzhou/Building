//
//  MyToBePayCell.m
//  Building
//
//  Created by Mac on 2019/3/17.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "MyToBePayCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyToBePayCell()
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end


@implementation MyToBePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(MyOrderItemModel *)model{
    _model=model;
    self.orderSnLabel.text=[NSString stringWithFormat:@"订单编号：%@",model.orderSn];
    NSURL *url = [NSURL URLWithString:model.productDetailImg];
    [self.productView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.nameLabel.text=model.productName;
    self.skuLabel.text=model.productSku;
    self.skuLabel.numberOfLines=0;
    self.skuLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //设置一个行高上限
    CGSize size = CGSizeMake(self.skuLabel.frame.size.width, self.skuLabel.frame.size.height*2);
    CGSize expect = [self.skuLabel sizeThatFits:size];
    self.skuLabel.frame = CGRectMake( self.skuLabel.frame.origin.x, self.skuLabel.frame.origin.y, expect.width, expect.height );
    self.companyLabel.text=model.supplierName;
    self.priceLabel.text=[NSString stringWithFormat:@"%@%@",model.price,model.priceUnit];
    self.countLabel.text=model.quantity;
    self.amountLabel.text=[NSString stringWithFormat:@"总价: ¥%@",model.amount ];
    self.cannelBtn.layer.borderWidth=1;
    self.cannelBtn.layer.cornerRadius=3;
    self.cannelBtn.layer.borderColor=([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1].CGColor);
    self.payBtn.layer.borderWidth=1;
    self.payBtn.layer.cornerRadius=3;
    self.payBtn.layer.borderColor=([UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor);
    
}

- (IBAction)cannelClick:(id)sender {
    if (self.cannelBlock) {
        self.cannelBlock(sender);
       
    }
}

- (IBAction)payClick:(id)sender {
    if (self.payBlock) {
        self.payBlock(sender);
       
    }
}

@end
