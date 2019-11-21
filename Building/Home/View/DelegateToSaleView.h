//
//  DelegateToSaleView.h
//  Building
//
//  Created by Macbook Pro on 2019/2/14.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DelegateToSaleViewDelegate <NSObject>
//- (void)doneSelectTradingId:(NSInteger)tradingId;;
- (void)doneBtnActionOfDelegateToSaleView:(NSMutableDictionary *)params;//
- (void)cancelBtnActionOfDelegateToSaleView;//
- (void)coverViewTapActionOfDelegateToSaleView;//
@optional

@end

NS_ASSUME_NONNULL_BEGIN

@interface DelegateToSaleView : UIView
@property (nonatomic, weak) id<DelegateToSaleViewDelegate> delegate;
@property (strong, nonatomic) DelegateModel *delegateModel;
@end

NS_ASSUME_NONNULL_END
