//
//  WTCalendarView.h
//  ApartmentLocksApp
//
//  Created by WaterWorld on 2019/4/11.
//  Copyright © 2019年 linhuaqin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHQCalendarViewDelegate <NSObject>

- (void)showMessageListWithDateString:(NSString *)selectDate;

@end

@interface LHQCalendarView : UIView

@property (nonatomic, weak) id<LHQCalendarViewDelegate> delegate;

@property (nonatomic, strong) NSArray <NSDate *>*signArray;
// 限制记录最初月份，之后不可再翻日历
@property (nonatomic, strong) NSDate  *pastDate;

- (void)reloadCalendar;

@end

NS_ASSUME_NONNULL_END
