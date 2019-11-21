//
//  MonthTimePicker.m
//  Building
//
//  Created by Macbook Pro on 2019/4/28.
//  Copyright © 2019 Macbook Pro. All rights reserved.
//

#import "MonthTimePicker.h"

@interface MonthTimePicker () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *dayMinutes;
@property (nonatomic, strong) NSArray *currentDayMinutes;

@end

@implementation MonthTimePicker

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 264, ScreenWidth)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.backgroundColor = [UIColor whiteColor];
    [self addSubview:picker];
    self.picker = picker;
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:toolBar];
    [toolBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:nil action:nil]];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = UIColorFromHEX(0x6E6E6E);
    titleLabel.text = @"选择预约的时间";
    [toolBar addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn setTitleColor:UIColorFromHEX(0x6E6E6E) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBtn];
    
    UIButton *okBtn = [[UIButton alloc] init];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [okBtn setTitleColor:UIColorFromHEX(0x73B8FD) forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:okBtn];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar.mas_bottom).offset(-10);
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@220);
    }];
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@35);
        make.top.bottom.equalTo(toolBar);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-35);
        make.top.bottom.equalTo(toolBar);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(toolBar);
    }];
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.dataSource.count;
    } else {
        NSInteger idx = [pickerView selectedRowInComponent:0];
        return [self isToday:self.dataSource[idx]] ? self.currentDayMinutes.count : self.dayMinutes.count;
    }
}
    
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ScreenWidth * 0.5;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *dateTime = nil;
//    if (component == 0) {
//        dateTime = self.dataSource[row];
//    } else {
//        dateTime = [self isToday] ? self.currentDayMinutes[row] : self.dayMinutes[row];
//    }
//    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:dateTime attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: UIColorFromHEX(0x525252)}];
//    return attr;
//}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [pickerView reloadComponent:1];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorFromHEX(0x525252);
    label.textAlignment = NSTextAlignmentCenter;
    
    if (component == 0) {
        label.text = [self.formatter stringFromDate:self.dataSource[row]];
    } else {
        NSInteger idx = [pickerView selectedRowInComponent:0];
        label.text = [self isToday:self.dataSource[idx]] ? self.currentDayMinutes[row] : self.dayMinutes[row];
    }
    return label;
}
    
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
    
- (void)cancelAction {
    [self hide];
}
    
- (void)okAction {
    [self hide];
    
    if (self.confirmBlock) {
    
        NSInteger idx1 = [self.picker selectedRowInComponent:0];
        NSDate *date = self.dataSource[idx1];
        
        NSInteger idx2 = [self.picker selectedRowInComponent:1];
        NSString *str = [self isToday:date] ? self.currentDayMinutes[idx2] : self.dayMinutes[idx2];
        
        NSString *dateString = [NSString stringWithFormat:@"%@ %@", [self.formatter stringFromDate:date], str];
        
        NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date];
        
        NSDateFormatter *format = [NSDateFormatter new];
        format.dateFormat = @"yyyy年MM月dd日 HH:mm";
        NSDate *result = [format dateFromString:[NSString stringWithFormat:@"%d年%@", year, dateString]];
        
        self.confirmBlock(result, dateString);
    }
}
    

- (void)hide {
    [self removeFromSuperview];
}
    
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (NSArray *)dataSource {
    if (_dataSource == nil) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans"];
        
        NSDate *date = [NSDate new];
        
        NSMutableArray *data = [NSMutableArray new];
        for (NSInteger i = 0; i < 366; i++) {
            NSDate *tempDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:i toDate:date options:0];
            [data addObject:tempDate];
        }

        _dataSource = [data copy];
    }
    return _dataSource;
}
    
- (NSArray *)dayMinutes {
    if (_dayMinutes == nil) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:48];
        for (NSInteger i = 0; i < 24; i++) {
            NSString *str1 = [NSString stringWithFormat:@"%zd:00", i];
            NSString *str2 = [NSString stringWithFormat:@"%zd:30", i];
            [array addObject:str1];
            [array addObject:str2];
        }
        _dayMinutes = [array copy];
    }
    return _dayMinutes;
}

- (BOOL)isToday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:date];
}
    
- (NSArray *)currentDayMinutes {
    if (_currentDayMinutes == nil) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans"];
        
        NSInteger h = [calendar component:NSCalendarUnitHour fromDate:[NSDate new]];
        NSInteger m = [calendar component:NSCalendarUnitMinute fromDate:[NSDate new]];
        NSString *str = @"";
        if (m < 30) {
            str = [NSString stringWithFormat:@"%d:30", h];
        } else {
            str = [NSString stringWithFormat:@"%d:00", h + 1];
        }
        
        NSArray *array = [self dayMinutes];
        NSInteger idx = [array indexOfObject:str];
        
        _currentDayMinutes = [array subarrayWithRange:NSMakeRange(idx, array.count - idx)];
    }
    return _currentDayMinutes;
}

- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [NSDateFormatter new];
        _formatter.dateFormat = @"MM月dd日";
    }
    return _formatter;
}


@end
