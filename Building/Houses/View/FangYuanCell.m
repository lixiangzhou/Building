//
//  FangYuanCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "FangYuanCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FangYuanCell()
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1Label;
@property (weak, nonatomic) IBOutlet UILabel *tag2Label;
@property (weak, nonatomic) IBOutlet UILabel *tag3Label;
@property(nonatomic, assign) UIEdgeInsets edgeInsets;
@end

@implementation FangYuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tag1Label setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
    [self.tag2Label setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
    [self.tag3Label setBorderWidthColor:UIColorFromHEX(0x73B8FD)];
    
    
}

#pragma mark - setters
- (void)setModel:(FYItemModel *)model{
    _model = model;
    
    NSURL *url = [NSURL URLWithString:model.pic];
    [self.myImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"url_no_access_image"]];
    self.titleLabel.text = model.name;
    self.selectLabel.text = [NSString stringWithFormat:@"%@㎡ | %@层",model.acreage, model.floor];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", model.price];
    //NSLog(@"address:%@", model.address );
    self.addressLabel.text = [NSString stringWithFormat:@"%@", model.address];
    //NSLog(@"self.addressLabel.text:%@", self.addressLabel.text );
    
    if (model.label.length > 0) {
        NSArray *tagsArray = [model.label componentsSeparatedByString:@" "];//以“ ”切割
        NSInteger tagsCount = tagsArray.count < 3 ? tagsArray.count : 3;
        self.tag1Label.hidden = tagsCount < 1;
        self.tag2Label.hidden = tagsCount < 2;
        self.tag3Label.hidden = tagsCount < 3;
        if (1 <= tagsCount) {
            self.tag1Label.text = [NSString stringWithFormat:@"%@", tagsArray[0]];
        }
        if (2 <= tagsCount) {
            self.tag2Label.text = [NSString stringWithFormat:@"%@", tagsArray[1]];
        }
        if (3 <= tagsCount) {
            self.tag3Label.text = [NSString stringWithFormat:@"%@", tagsArray[2]];
        }
    } else {
        self.tag1Label.hidden = YES;
        self.tag2Label.hidden = YES;
        self.tag3Label.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
