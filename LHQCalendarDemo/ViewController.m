//
//  ViewController.m
//  LHQCalendarDemo
//
//  Created by WaterWorld on 2019/4/17.
//  Copyright © 2019年 linhuaqin. All rights reserved.
//

#import "ViewController.h"
#import "LHQCalendarView.h"
#import "NSDate+Utilities.h"

@interface ViewController () <LHQCalendarViewDelegate>

@property (nonatomic, strong) LHQCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.calendarView];
}

#pragma mark - LHQCalendarViewDelegate
- (void)showMessageListWithDateString:(NSString *)selectDate{
    NSLog(@"date = %@",selectDate);
    [self.calendarView reloadCalendar];
}

- (LHQCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[LHQCalendarView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, [UIScreen mainScreen].bounds.size.width, 360)];
        _calendarView.delegate = self;
        NSDate *date1 = [NSDate stringToDate:@"2019-04-25" format:YMD];
        NSDate *date2 = [NSDate stringToDate:@"2019-04-01" format:YMD];
        NSDate *date3 = [NSDate stringToDate:@"2019-02-21" format:YMD];
        _calendarView.signArray = @[date1,date2,date3];
        NSDate *date4 = [NSDate stringToDate:@"2018-11-21" format:YMD];
        _calendarView.pastDate = date4;
    }
    return _calendarView;
}


@end
