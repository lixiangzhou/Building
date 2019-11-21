//
//  SelectAreaView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAreaViewDelegate <NSObject>
//- (void)doneSelectTradingId:(NSInteger)tradingId;;
- (void)cancelSelectArea;//
- (void)doneSelectOneComponentRow:(NSInteger)oneRow twoComponentRow:(NSInteger)twoRow threeComponentRow:(NSInteger)threeRow;//
- (void)coverViewTapAction;//
@optional

@end

NS_ASSUME_NONNULL_BEGIN

@interface SelectAreaView : UIView
@property (nonatomic, weak) id<SelectAreaViewDelegate>   delegate;
@property (strong, nonatomic) NSArray <FYProvinceModel *> *provinceList;
    
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
