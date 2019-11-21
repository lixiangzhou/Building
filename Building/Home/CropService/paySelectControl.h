//
//  paySelectControl.h
//  Building
//
//  Created by Mac on 2019/4/8.
//  Copyright © 2019年 Macbook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol paySelectControlDelegate <NSObject>
- (void)coverViewTapActionOfpsView;
- (void)coverViewTapActionOfpsOkView;


@optional

@end


NS_ASSUME_NONNULL_BEGIN

@interface paySelectControl : UIView
@property (nonatomic, weak) id<paySelectControlDelegate> pscd;
@property (nonatomic, copy)  NSString  * idStr;//地址ID
@property (nonatomic, copy)  NSString  * message;//地址ID
@property (nonatomic, copy)  NSString  * number;//地址ID
@property (nonatomic, copy)  NSString  * productId;//地址ID
@property (nonatomic, copy)  NSString  * productSaleId;

@property (nonatomic, copy)  NSString *orderSn;//订单编号
@property (nonatomic, assign)  NSInteger paymode;
//@property (strong, nonatomic) DelegateModel *delegateModel;
    
- (void)showFrom:(UIViewController *)controller completion:(nullable void (^)(BOOL))completion;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
