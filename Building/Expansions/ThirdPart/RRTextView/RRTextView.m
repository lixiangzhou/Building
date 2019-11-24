
#import "RRTextView.h"

@interface RRTextView()

@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation RRTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setPlaceholderColor:(UIColor *)color {
    
    if (self.placeholderLabel) {
        [self.placeholderLabel setTextColor:color];
    }
}

- (void)setup
{
    // 1.创建UILabel
    UILabel *label = [[UILabel alloc] init];
    label.text = @"输入您感兴趣的内容...";
    label.font = [UIFont systemFontOfSize:15];
    label.numberOfLines = 0;
    [label sizeToFit];
    [self addSubview:label];
    self.placeholderLabel = label;
    [self.placeholderLabel setTextColor:RGB(98, 98, 98)];
    // 2.监听自己有没有输入内容, 监听自己内容的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholderOriginY:(CGFloat)orginY andOriginX:(CGFloat)originX{

    if (self.placeholderLabel) {
        CGRect frame = self.placeholderLabel.frame;
        frame.origin.y = orginY;
        frame.origin.x = originX;
        self.placeholderLabel.frame = frame;
        
//        [self.placeholderLabel sizeToFit];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textChange
{
//    DDLogInfo(@"%@", self.text);
    self.placeholderLabel.hidden = (self.fullTextStr.length > 0);
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    // 每次设置完提示文本 , 应该重新计算frame
    CGSize size = [self.placeholderLabel sizeThatFits:CGSizeMake(ScreenWidth-26, self.height)];
    CGRect frame = self.placeholderLabel.frame;
    frame.size = size;
    self.placeholderLabel.frame = frame;
//    [self.placeholderLabel sizeToFit];
    
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    // 重新设置提示文本的字体大小
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}




- (NSString *)fullTextStr
{
    // 定义个字符串保存最终需要发送的文本
    NSMutableString *temp = [NSMutableString string];
    // 遍历属性字符串
    NSRange range = NSMakeRange(0, self.attributedText.length);
    [self.attributedText enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        if (attrs[@"NSAttachment"] == nil) {
            NSString *norStr = [self.text substringWithRange:range];
            // 拼接字符串
            [temp appendString:norStr];
        }
    }];
    return temp;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChange];
}

- (void)clear {
    self.text = @"";
    [self textChange];
}
@end
