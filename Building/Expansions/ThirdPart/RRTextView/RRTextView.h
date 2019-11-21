#import <UIKit/UIKit.h>

@interface RRTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

- (NSString *)fullTextStr;
- (void) clear;

- (void)setFont:(UIFont *)font;
/**
 *  设置Placeholder Label 的偏移量
 *
 *  @param orginY  Y偏移量
 *  @param originX X偏移量
 */
- (void)setPlaceholderOriginY:(CGFloat)orginY andOriginX:(CGFloat)originX;

/**
 *  设置Placeholder的字体颜色
 *
 *  @param color UIColor
 */
- (void)setPlaceholderColor:(UIColor *)color;

@end
