//
//  WTCalendarView.m
//  ApartmentLocksApp
//
//  Created by WaterWorld on 2019/4/11.
//  Copyright © 2019年 linhuaqin. All rights reserved.
//

#import "LHQCalendarView.h"
#import "LHQCalendarCell.h"
#import "NSDate+Utilities.h"

#define kWeak(type)  __weak typeof(type) weak##type = type

@interface LHQCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource,LHQDateCellDelegate>

@property (nonatomic, strong) UIButton              *lastMonthButton; // 上个月的按钮
@property (nonatomic, strong) UIButton              *nextMonthButton;// 下个月的按钮
@property (nonatomic, strong) UILabel               *calendarLabel; // 显示当天的时间
@property (nonatomic, strong) UICollectionView      *dataCollectionview;//显示日历的所有时间

@property (nonatomic, strong) NSDate        *nowDate; // 现在的时间
@property (nonatomic, strong) NSDate        *calendarDate; // 日历的日期
@property (nonatomic, strong) NSArray       *weekArray; // 周书久
@property (nonatomic, assign) NSIndexPath   *lastIndex; //
@property (nonatomic, strong) NSDate        *lastDate; // 记录上次选中日期

@end

@implementation LHQCalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupDatas];
        [self setupUI];
    }
    return self;
}

#pragma mark - setupDatas
- (void)setupDatas{
    self.weekArray = [NSArray arrayWithObjects:
                      @"日",
                      @"一",
                      @"二",
                      @"三",
                      @"四",
                      @"五",
                      @"六",
                      nil];
    self.nowDate = [NSDate date];
    self.calendarDate = [NSDate date];
}

- (void)reloadCalendar{
    [self.dataCollectionview reloadData];
}

#pragma mark - setupUI
- (void)setupUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.lastMonthButton];
    [self addSubview:self.calendarLabel];
    [self addSubview:self.nextMonthButton];
    [self addSubview:self.dataCollectionview];
}

#pragma mark - LHQDateCellDelegate
- (void)clickDateWith:(LHQDateCell *)cell indexpath:(NSIndexPath *)indexpath {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *string = [[NSString alloc] initWithFormat:@"%@-%02ld",[formatter stringFromDate:self.calendarDate],[cell.dateButton.titleLabel.text integerValue]];
    self.lastDate = [NSDate stringToDate:string format:YMD];
    if ([self.delegate respondsToSelector:@selector(showMessageListWithDateString:)]) {
        [self.delegate showMessageListWithDateString:string];
    }
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.weekArray.count;
    }
    return 35;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LHQWeekCell *weekCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LHQWeekCell class]) forIndexPath:indexPath];
        [weekCell.weekLabel setText:self.weekArray[indexPath.row]];
        weekCell.backgroundColor = [UIColor whiteColor];
        return weekCell;
    }else{
        LHQDateCell *dateCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LHQDateCell class]) forIndexPath:indexPath];
        [self getDatesWithIndexpath:indexPath cell:dateCell];
        dateCell.indexpath = indexPath;
        dateCell.cellDelegate = self;
        return dateCell;
    }
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((self.frame.size.width-2)/7, 40);
    }
    CGFloat w = (self.frame.size.width-2)/7;
    return CGSizeMake(w, w);
}


#pragma mark - 月份切换
// 上个月
- (void)showLastMonthData:(UIButton *)sender{
    _lastIndex = nil;
    if (!self.nextMonthButton.selected) {
        self.nextMonthButton.userInteractionEnabled = YES;
        self.nextMonthButton.selected = YES;
    }
    kWeak(self);
    [UIView transitionWithView:self.dataCollectionview duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        weakself.calendarDate = [self lastMonthWithDate:weakself.calendarDate];
        weakself.calendarLabel.text = [NSString stringWithFormat:@"%ld月  %ld",[weakself monthWithDate:weakself.calendarDate],[weakself yearWithDate:weakself.calendarDate]];
        // 显示记录最初月份的时候不允许再点击显示下一个月
        BOOL monthEqual = ([weakself monthWithDate:weakself.calendarDate] == [weakself monthWithDate:weakself.pastDate])?YES:NO;
        BOOL yearEqual = ([weakself yearWithDate:weakself.calendarDate] == [weakself yearWithDate:weakself.pastDate])?YES:NO;
        if (monthEqual && yearEqual) {
            weakself.lastMonthButton.userInteractionEnabled = NO;
            weakself.lastMonthButton.selected = NO;
        }
    } completion:^(BOOL finished) {
        [weakself.dataCollectionview reloadData];
    }];
}

// 下个月
- (void)showNextMonthData:(UIButton *)sender{
    kWeak(self);
    _lastIndex = nil;
    if (!self.lastMonthButton.selected) {
        self.lastMonthButton.userInteractionEnabled = YES;
        self.lastMonthButton.selected = YES;
    }
    [UIView transitionWithView:self.dataCollectionview duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        weakself.calendarDate = [weakself nextMonthWithDate:weakself.calendarDate];
        weakself.calendarLabel.text = [NSString stringWithFormat:@"%ld月  %ld年",[weakself monthWithDate:weakself.calendarDate],[weakself yearWithDate:weakself.calendarDate]];
        //显示当前月份的时候不允许再点击显示下一个月
        BOOL monthEqual = ([weakself monthWithDate:weakself.calendarDate] == [weakself monthWithDate:weakself.nowDate])?YES:NO;
        BOOL yearEqual = ([weakself yearWithDate:weakself.calendarDate] == [weakself yearWithDate:weakself.nowDate])?YES:NO;
        if (monthEqual && yearEqual) {
            weakself.nextMonthButton.userInteractionEnabled = NO;
            weakself.nextMonthButton.selected = NO;
        }
    } completion:^(BOOL finished) {
        [weakself.dataCollectionview reloadData];
    }];
}

#pragma mark - setter
- (void)setSignArray:(NSArray<NSDate *> *)signArray{
    _signArray = signArray;
}

- (void)setPastDate:(NSDate *)pastDate{
    _pastDate = pastDate;
}

#pragma mark - private method
- (void)getDatesWithIndexpath:(NSIndexPath *)indexpath cell:(LHQDateCell *)cell {
    NSInteger daysInThisMonth = [self totalDaysInThisMonthWithDate:self.calendarDate];
    NSInteger firstWeekDay = [self firstWeekDayInThisMonthWithDate:self.calendarDate];
    NSInteger day = 0;
    NSInteger i = indexpath.row;
    
    NSInteger nowMonth = [self monthWithDate:self.calendarDate];
    NSInteger nowYear = [self yearWithDate:self.calendarDate];
    
    NSInteger lastMonth = 0;
    NSInteger lastYear = 0;
    
    if (nowMonth == 1) {
        lastMonth = 12;
        lastYear = nowYear-1;
    }else {
        lastMonth = nowMonth-1;
        lastYear = nowYear;
    }
    
    if (i >= firstWeekDay && i < firstWeekDay+daysInThisMonth) {
        day = i-firstWeekDay+1;
        if ((day == [self dayWithDate:self.nowDate]) &&
            ([self monthWithDate:self.nowDate] == [self monthWithDate:self.calendarDate]) &&
            ([self yearWithDate:self.nowDate] == [self yearWithDate:self.calendarDate])) {
            //当前日期
            [cell.dateButton setBackgroundColor:[UIColor yellowColor]];
            cell.dateButton.selected = YES;
        }
        else {
            cell.dateButton.selected = NO;
            [cell.dateButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        [cell.dateButton setTitle:[NSString stringWithFormat:@"%ld",day] forState:UIControlStateNormal];
        cell.dateButton.userInteractionEnabled = YES;
        
        // 上次选择日期替换当前日期
        if (self.lastDate) {
            if (day == [self dayWithDate:self.lastDate] &&
                nowMonth == [self monthWithDate:self.lastDate] &&
                nowYear == [self yearWithDate:self.lastDate]){
                [cell.dateButton setBackgroundColor:[UIColor yellowColor]];
                cell.dateButton.selected = YES;
            }else{
                cell.dateButton.selected = NO;
                [cell.dateButton setBackgroundColor:[UIColor whiteColor]];
            }
        }
        
        // 异常标记
        if (self.signArray.count) {
            [self.signArray enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (day == [self dayWithDate:obj] &&
                    nowMonth == [self monthWithDate:obj] &&
                    nowYear == [self yearWithDate:obj]){
                    [cell.dateButton setBackgroundColor:[UIColor redColor]];
                    cell.dateButton.selected = YES;
                }
            }];
        }
        
    }else {
        // 空白的格子
        [cell.dateButton setBackgroundColor:[UIColor whiteColor]];
        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
        cell.dateButton.userInteractionEnabled = NO;
    }
}

// 计算日期是哪年
- (NSInteger)yearWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.year;
}

// 计算日期是几月
- (NSInteger)monthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.month;
}

// 计算日期是几号
- (NSInteger)dayWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return component.day;
}

// 计算指定月天数
- (NSInteger)getDaysInMonthWithYearAndMonth:(NSInteger)year month:(NSInteger)month{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM";
    
    NSString *monthStr = @"";
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%ld",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%ld",month];
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld-%@",year,monthStr];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    //NSCalendarIdentifierGregorian公历日历的意思
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

// 计算每个月1号对应周几
- (NSInteger)firstWeekDayInThisMonthWithDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    calendar.firstWeekday = 1;
    component.day = 1;
    
    NSDate *firstDate = [calendar dateFromComponents:component];
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDate] - 1;
}

// 计算当前月份天数
- (NSInteger)totalDaysInThisMonthWithDate:(NSDate *)date{
    return [[NSCalendar currentCalendar]rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

// 上一个月
- (NSDate *)lastMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = -1;
    /*
     NSCalendarWrapComponents
     Specifies that the components specified for an NSDateComponents object should be incremented and wrap around to zero/one on overflow, but should not cause higher units to be incremented.
     指定为NSDateComponents对象指定的组件应该递增，并在溢出时循环为零/ 1，但不应导致更高的单位增加。
     NSCalendarMatchStrictly
     Specifies that the operation should travel as far forward or backward as necessary looking for a match.
     指定操作应该根据需要前进或后退，寻找匹配。
     NSCalendarSearchBackwards
     Specifies that the operation should travel backwards to find the previous match before the given date.
     指定操作向后移动以在给定日期之前找到先前的匹配。
     NSCalendarMatchPreviousTimePreservingSmallerUnits
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the previous existing value of the missing unit and preserves the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺失单元的先前存在的值，并保留较低单位的值。
     NSCalendarMatchNextTimePreservingSmallerUnits
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and preserves the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值并保留较低单位的值。
     NSCalendarMatchNextTime
     Specifies that, when there is no matching time before the end of the next instance of the next highest unit specified in the given NSDateComponents object, this method uses the next existing value of the missing unit and does not preserve the lower units' values.
     指定当在给定的NSDateComponents对象中指定的下一个最高单位的下一个实例的结束之前没有匹配的时间时，此方法使用缺少单元的下一个现有值，并且不保留较低单位的值。
     NSCalendarMatchFirst
     Specifies that, if there are two or more matching times, the operation should return the first occurrence.
     指定如果有两个或更多匹配的时间，操作应该返回第一个出现的。
     NSCalendarMatchLast
     Specifies that, if there are two or more matching times, the operation should return the last occurrence.
     指定如果有两个或更多匹配的时间，则操作应返回最后一次出现的。
     */
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}

//下一个月
- (NSDate *)nextMonthWithDate:(NSDate *)date{
    NSDateComponents *component = [[NSDateComponents alloc] init];
    component.month = +1;
    return [[NSCalendar currentCalendar]dateByAddingComponents:component toDate:date options:NSCalendarMatchStrictly];
}

#pragma mark - lazy
- (UIButton *)lastMonthButton {
    if (!_lastMonthButton) {
        _lastMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastMonthButton.frame = CGRectMake(24, 12, 30, 30);
        [_lastMonthButton setImage:[UIImage imageNamed:@"mylocks_arrow_left_unSelect"] forState:UIControlStateNormal];
        [_lastMonthButton setImage:[UIImage imageNamed:@"mylocks_arrow_left_select"] forState:UIControlStateSelected];
        [_lastMonthButton addTarget:self action:@selector(showLastMonthData:) forControlEvents:UIControlEventTouchUpInside];
        _lastMonthButton.selected = YES;
    }
    return _lastMonthButton;
}

- (UILabel *)calendarLabel {
    if (!_calendarLabel) {
        CGFloat x = CGRectGetMaxX(_lastMonthButton.frame)+30;
        CGFloat w = self.frame.size.width-x*2;
        _calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 15, w, 20)];
        _calendarLabel.font = [UIFont systemFontOfSize:17];
        _calendarLabel.textColor = [UIColor grayColor];
        _calendarLabel.textAlignment = NSTextAlignmentCenter;
        _calendarLabel.text = [NSString stringWithFormat:@"%ld月  %ld",[self monthWithDate:self.calendarDate],[self yearWithDate:self.calendarDate]];
    }
    return _calendarLabel;
}

- (UIButton *)nextMonthButton {
    if (!_nextMonthButton) {
        _nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextMonthButton.frame = CGRectMake(CGRectGetMaxX(_calendarLabel.frame)+15, _lastMonthButton.frame.origin.y, 30, 30);
        [_nextMonthButton setImage:[UIImage imageNamed:@"mylocks_arrow_right_unSelect"] forState:UIControlStateNormal];
        [_nextMonthButton setImage:[UIImage imageNamed:@"mylocks_arrow_right_select"] forState:UIControlStateSelected];
        [_nextMonthButton addTarget:self action:@selector(showNextMonthData:) forControlEvents:UIControlEventTouchUpInside];
        _nextMonthButton.selected = NO;
        _nextMonthButton.userInteractionEnabled = NO;
    }
    return _nextMonthButton;
}


- (UICollectionView *)dataCollectionview {
    if (!_dataCollectionview) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        [flowLayOut setMinimumLineSpacing:0];
        [flowLayOut setMinimumInteritemSpacing:0];
        [flowLayOut setSectionInset:UIEdgeInsetsMake(0, 1, 0, 1)];
        CGFloat itemW = (self.frame.size.width-2) / 7;
        flowLayOut.itemSize = CGSizeMake(itemW, itemW);
        
        _dataCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendarLabel.frame)+12, self.frame.size.width, itemW*6) collectionViewLayout:flowLayOut];
        _dataCollectionview.delegate = self;
        _dataCollectionview.dataSource = self;
        [_dataCollectionview registerClass:[LHQWeekCell class] forCellWithReuseIdentifier:NSStringFromClass([LHQWeekCell class])];
        [_dataCollectionview registerClass:[LHQDateCell class] forCellWithReuseIdentifier:NSStringFromClass([LHQDateCell class])];
        _dataCollectionview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _dataCollectionview.scrollEnabled = NO;
    }
    return _dataCollectionview;
}


@end
