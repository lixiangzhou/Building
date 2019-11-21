//
//  proprietorConcelll.m
//  Building
//
//  Created by Mac on 2019/4/15.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import "proprietorConcelll.h"

@implementation proprietorConcelll

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSh:(selectedHouseModel *)sh{
    _sh=sh;
   
    NSLog(@"configHouseLabelImage:%@", self.sh.title);
    float x = 24;
    float y = 12;
    
    UILabel * label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"  %@  ", sh.title];
    
    label.textColor = UIColorFromHEX(0x6e6e6e);
    label.font = [UIFont systemFontOfSize:13];
    CGSize maxSize = CGSizeMake(300, 30);
    CGSize expect = [label sizeThatFits:maxSize];
    label.layer.borderWidth = 1;
    label.layer.cornerRadius = 4;
    label.layer.borderColor = [UIColor colorWithRed:154/255.0 green:204/255.0 blue:255/255.0 alpha:1].CGColor;
    label.backgroundColor = UIColorFromHEX(0xeff7ff);
    label.numberOfLines = 0;
    label.lineBreakMode =NSLineBreakByTruncatingTail;
    //label.textAlignment = UITextAlignmentLeft;
    if( expect.width >= (ScreenWidth - x - 4) ){
        expect.width = (ScreenWidth - x - 4);
        expect.height = 60;
    }
    else{
        expect.height = 30;
    }
    label.frame = CGRectMake( x, y, expect.width, expect.height );
    [self addSubview:label];
    
    if( self.isimage )
    {
        UIImageView *deleteImg = [[UIImageView alloc] init];
        [deleteImg setImage:[UIImage imageNamed:@"delete"]];
        deleteImg.userInteractionEnabled = YES;
        float dt = 8;
        deleteImg.frame = CGRectMake( x+expect.width-dt, y-dt, 16, 16 );
        [deleteImg setTag:1000];
        
        UITapGestureRecognizer *imgTouch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTouchOn:)];
        //imgTouch.view.tag = 1000+n;
        [deleteImg addGestureRecognizer:imgTouch];
        [self addSubview:deleteImg];
    }
}

-(void)imgTouchOn:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
//    //NSLog(@"imgTouchOn:%ld", tag );
//
//    tag = tag - 1000;
//
//    NSString * str = [self.nameArray objectAtIndex:tag];
//    //NSLog(@"idArray:%@", str );
//
//    [self.idArray removeObjectAtIndex:tag];
//    [self.nameArray removeObjectAtIndex:tag];
    
//    for (UIView *view in [self.houseSelView subviews]){
//        [view removeFromSuperview];
//    }
//
//    for( int i=0; i<self.idArray.count; i++ )
//    {
//        NSString * str = [self.nameArray objectAtIndex:i];
//        [ self configHouseLabelImage:str Cnt:i];
//    }
    NSLog(@"imgTouchOn:%ld", tag );
    if (self.delectBlock) {
        self.delectBlock(views);
    }
}


@end
