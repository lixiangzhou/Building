//
//  CJMenuSelectThreeConView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/9.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//@protocol CJMenuSelectThreeConViewDelegate <NSObject>
//- (void)doneSelectTradingId:(NSInteger)tradingId;;
//- (void)doneSelectBuXian;//
//- (void)doneSelectMeroRow:(NSInteger)row;//
//- (void)coverViewTapAction;//
//@optional
//
//@end


@interface CJMenuSelectThreeConView : UIView
//@property (nonatomic, weak) id<CJMenuSelectThreeConViewDelegate>   delegate;
@property (strong, nonatomic) FYShangQuanCityModel *currentCityModel;

@property (copy, nonatomic) void (^selectedBlock) (void);

@property (copy, nonatomic) NSString *metro;
@property (strong, nonatomic) FYShangQuanCountryModel *countryModel;
@property (strong, nonatomic) FYShangQuanTradingModel *tradingModel;

- (void)showView;

- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
