//
//  CJMenuSelectOneConView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CJMenuSelectOneConView;
@protocol CJMenuSelectOneConViewDelegate <NSObject>
- (NSArray *)selectOneConViewTableViewDatasSelfView:(CJMenuSelectOneConView *)oneConView;
- (void)selectOneConViewSelectRow:(NSInteger)row selfView:(CJMenuSelectOneConView *)oneConView;//row从0开始
- (void)selectOneConViewCoverViewTapActionSelfView:(CJMenuSelectOneConView *)oneConView;
@optional

@end


@interface CJMenuSelectOneConView : UIView
@property (nonatomic, assign) NSInteger selectIdx;

@property (nonatomic, weak) id<CJMenuSelectOneConViewDelegate>   delegate;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
