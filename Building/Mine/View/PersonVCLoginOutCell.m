//
//  PersonVCLoginOutCell.m
//  Building
//
//  Created by Macbook Pro on 2019/2/26.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "PersonVCLoginOutCell.h"

@interface PersonVCLoginOutCell()
@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;

@end

@implementation PersonVCLoginOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)loginOutButton:(id)sender {
    if (self.logOutBlock) {
        self.logOutBlock(sender);
    }
}

@end
