//
//  DelegateToSaleCollectionCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/16.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "DelegateToSaleCollectionCell.h"


@interface DelegateToSaleCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end


@implementation DelegateToSaleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = UIColorFromHEX(0x6E6E6E).CGColor;
    // Initialization code
}
#pragma mark - setters
- (void)setHouseModel:(DelegateHouseModel *)houseModel{
    _houseModel = houseModel;
    
    if (houseModel.isSelect) {//选中
        self.layer.borderWidth = 0;
        self.backgroundColor = UIColorFromHEX(0x73b8fd);
        self.titleLabel.textColor = UIColorFromHEX(0xffffff);
    } else {
        self.layer.borderWidth = 1;
        self.backgroundColor = UIColorFromHEX(0xffffff);
        self.titleLabel.textColor = UIColorFromHEX(0x6e6e6e);
    }
    self.titleLabel.text = houseModel.houseName;
}

@end
