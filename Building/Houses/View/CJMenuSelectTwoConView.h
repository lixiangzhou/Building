//
//  CJMenuSelectTwoConView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CJMenuSelectTwoConViewDelegate <NSObject>
- (NSArray *)leftTableViewDatas;
- (void)resetButtonAction:(id)data;
- (void)doneButtonActionSelectCity:(FYCityModel *)city selectCountryArr:(NSArray *)countryArr;
- (void)coverViewTapAction;
@optional

@end


@interface CJMenuSelectTwoConView : UIView
@property (nonatomic, weak) id<CJMenuSelectTwoConViewDelegate>   delegate;


- (void)showView;

- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
