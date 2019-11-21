//
//  ServiceBuyView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceBuyViewDelegate <NSObject>
//- (void)doneSelectTradingId:(NSInteger)tradingId;;
- (void)toPayBtnAction;//
//- (void)doneSelectMeroRow:(NSInteger)row;//
- (void)coverViewTapAction;//
@optional

@end

NS_ASSUME_NONNULL_BEGIN

@interface ServiceBuyView : UIView
@property (nonatomic, weak) id<ServiceBuyViewDelegate>   delegate;
@property (strong, nonatomic) ServiceDetailModel *detailModel;

- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
