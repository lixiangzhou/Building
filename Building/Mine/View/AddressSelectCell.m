//
//  AddressSelectCell.m
//  Building
//
//  Created by Macbook Pro on 2019/3/10.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "AddressSelectCell.h"

@interface AddressSelectCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectedImage;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation AddressSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.addressLabel setNumberOfLines:0];
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;

    // Initialization code
}
#pragma mark - Actions
- (IBAction)moRenAddressTapAction:(id)sender {
    if (self.defaultBtnBlock)
    {
        self.defaultBtnBlock(sender);
    }
}
- (IBAction)editButtonAction:(id)sender {
    if (self.editBtnBlock)
    {
        self.editBtnBlock(sender);
    }
}

#pragma mark - setters
- (void)setAddressModel:(AddressModel *)addressModel{
    _addressModel = addressModel;
    
    self.nameLabel.text = addressModel.receiver;
    self.telLabel.text = addressModel.contact;
    if (addressModel.defaultBool) {//
        self.isSelectedImage.image = [UIImage imageNamed:@"selected_h"];
    } else {
        self.isSelectedImage.image = [UIImage imageNamed:@"selected_n"];
    }
    self.addressLabel.text = [NSString stringWithFormat:@"收获地址：%@%@%@%@", addressModel.provinceName, addressModel.cityName, addressModel.countyName, addressModel.address];
    
    //设置一个行高上限
    //self.addressLabel.numberOfLines = 0;
    float w = ScreenWidth * 300 / 375 - 50;
    CGSize size = CGSizeMake(w, self.addressLabel.frame.size.height*2);
    CGSize expect = [self.addressLabel sizeThatFits:size];
    self.addressLabel.frame = CGRectMake( self.addressLabel.frame.origin.x, self.addressLabel.frame.origin.y, expect.width, expect.height );
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
