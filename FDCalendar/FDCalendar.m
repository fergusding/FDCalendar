//
//  FDCalendar.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDCalendar.h"
#import "FDCalendarItem.h"

#define Weekdays @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"]

static NSDateFormatter *dateFormattor;

@interface FDCalendar () <UIScrollViewDelegate, FDCalendarItemDelegate>

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FDCalendarItem *leftCalendarItem;
@property (strong, nonatomic) FDCalendarItem *centerCalendarItem;
@property (strong, nonatomic) FDCalendarItem *rightCalendarItem;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIView *datePickerView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation FDCalendar

- (instancetype)initWithCurrentDate:(NSDate *)date {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1.0];
        self.date = date;
        
        [self setupTitleBar];
        [self setupWeekHeader];
        [self setupCalendarItems];
        [self setupScrollView];
        [self setFrame:CGRectMake(0, 0, DeviceWidth, CGRectGetMaxY(self.scrollView.frame))];
        
        [self setCurrentDate:self.date];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame: self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDatePickerView)];
        [_backgroundView addGestureRecognizer:tapGesture];
    }
    
    [self addSubview:_backgroundView];
    
    return _backgroundView;
}

- (UIView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, 0)];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.clipsToBounds = YES;
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 32, 20)];
        cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:cancelButton];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 52, 10, 32, 20)];
        okButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(selectCurrentDate) forControlEvents:UIControlEventTouchUpInside];
        [_datePickerView addSubview:okButton];
        
        [_datePickerView addSubview:self.datePicker];
    }
    
    [self addSubview:_datePickerView];
    
    return _datePickerView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"Chinese"];
        CGRect frame = _datePicker.frame;
        frame.origin = CGPointMake(0, 32);
        _datePicker.frame = frame;
    }
    
    return _datePicker;
}

#pragma mark - Private

- (NSString *)stringFromDate:(NSDate *)date {
    if (!dateFormattor) {
        dateFormattor = [[NSDateFormatter alloc] init];
        [dateFormattor setDateFormat:@"MM-yyyy"];
    }
    return [dateFormattor stringFromDate:date];
}

// 设置上层的titleBar
- (void)setupTitleBar {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 44)];
    titleView.backgroundColor = [UIColor redColor];
    [self addSubview:titleView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 32, 24)];
    [leftButton setImage:[UIImage imageNamed:@"icon_previous"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(setPreviousMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(titleView.frame.size.width - 37, 10, 32, 24)];
    [rightButton setImage:[UIImage imageNamed:@"icon_next"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setNextMonthDate) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:rightButton];
    
    UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleButton.titleLabel.textColor = [UIColor whiteColor];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleButton.center = titleView.center;
    [titleButton addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:titleButton];
    
    self.titleButton = titleButton;
}

// 设置星期文字的显示
- (void)setupWeekHeader {
    NSInteger count = [Weekdays count];
    CGFloat offsetX = 5;
    for (int i = 0; i < count; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, 50, (DeviceWidth - 10) / count, 20)];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.text = Weekdays[i];
        
        if (i == 0 || i == count - 1) {
            weekdayLabel.textColor = [UIColor redColor];
        } else {
            weekdayLabel.textColor = [UIColor grayColor];
        }
        
        [self addSubview:weekdayLabel];
        offsetX += weekdayLabel.frame.size.width;
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 74, DeviceWidth - 30, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
}

// 设置包含日历的item的scrollView
- (void)setupScrollView {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setFrame:CGRectMake(0, 75, DeviceWidth, self.centerCalendarItem.frame.size.height)];
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    [self addSubview:self.scrollView];
}

// 设置3个日历的item
- (void)setupCalendarItems {
    self.scrollView = [[UIScrollView alloc] init];
    
    self.leftCalendarItem = [[FDCalendarItem alloc] init];
    [self.scrollView addSubview:self.leftCalendarItem];
    
    CGRect itemFrame = self.leftCalendarItem.frame;
    itemFrame.origin.x = DeviceWidth;
    self.centerCalendarItem = [[FDCalendarItem alloc] init];
    self.centerCalendarItem.frame = itemFrame;
    self.centerCalendarItem.delegate = self;
    [self.scrollView addSubview:self.centerCalendarItem];
    
    itemFrame.origin.x = DeviceWidth * 2;
    self.rightCalendarItem = [[FDCalendarItem alloc] init];
    self.rightCalendarItem.frame = itemFrame;
    [self.scrollView addSubview:self.rightCalendarItem];
}

// 设置当前日期，初始化
- (void)setCurrentDate:(NSDate *)date {
    self.centerCalendarItem.date = date;
    self.leftCalendarItem.date = [self.centerCalendarItem previousMonthDate];
    self.rightCalendarItem.date = [self.centerCalendarItem nextMonthDate];
    
    [self.titleButton setTitle:[self stringFromDate:self.centerCalendarItem.date] forState:UIControlStateNormal];
}

// 重新加载日历items的数据
- (void)reloadCalendarItems {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x > self.scrollView.frame.size.width) {
        [self setNextMonthDate];
    } else {
        [self setPreviousMonthDate];
    }
}

- (void)showDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0.4;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 250);
    }];
}

- (void)hideDatePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 0;
        self.datePickerView.frame = CGRectMake(0, 44, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.datePickerView removeFromSuperview];
    }];
}

#pragma mark - SEL

// 跳到上一个月
- (void)setPreviousMonthDate {
    [self setCurrentDate:[self.centerCalendarItem previousMonthDate]];
}

// 跳到下一个月
- (void)setNextMonthDate {
    [self setCurrentDate:[self.centerCalendarItem nextMonthDate]];
}

- (void)showDatePicker {
    [self showDatePickerView];
}

// 选择当前日期
- (void)selectCurrentDate {
    [self setCurrentDate:self.datePicker.date];
    [self hideDatePickerView];
}

- (void)cancelSelectCurrentDate {
    [self hideDatePickerView];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadCalendarItems];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
}

#pragma mark - FDCalendarItemDelegate

- (void)calendarItem:(FDCalendarItem *)item didSelectedDate:(NSDate *)date {
    self.date = date;
    [self setCurrentDate:self.date];
}

@end
