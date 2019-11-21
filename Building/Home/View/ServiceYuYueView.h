//
//  ServiceYuYueView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceYuYueViewDelegate <NSObject>
//- (void)doneSelectTradingId:(NSInteger)tradingId;;
- (void)toPayBtnActionOfServiceYuYueView;//
//- (void)doneSelectMeroRow:(NSInteger)row;//
- (void)coverViewTapActionOfServiceYuYueView;//
@optional

@end

NS_ASSUME_NONNULL_BEGIN

@interface ServiceYuYueView : UIView
@property (nonatomic, weak) id<ServiceYuYueViewDelegate>   delegate;
@property (strong, nonatomic) ServiceDetailModel *detailModel;
    
- (void)show;
- (void)hide;
    
    
@end

NS_ASSUME_NONNULL_END
