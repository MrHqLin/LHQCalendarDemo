//
//  WTCalendarCell.m
//  GeeLockApp
//
//  Created by water on 2018/8/28.
//  Copyright © 2018年 water. All rights reserved.
//

#import "LHQCalendarCell.h"
#import <Masonry.h>

#define KStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
#define kW(x)  ceilf((x) * kScreenWidthRatio)
#define kH(x)  ceilf((x) * kScreenHeightRatio)

@implementation LHQWeekCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _weekLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_weekLabel];
    _weekLabel.font = [UIFont systemFontOfSize:14];
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.textColor = [UIColor grayColor];
}

@end

@implementation LHQDateCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.dateButton];
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(kW(1));
        make.top.equalTo(self.contentView.mas_top).with.offset(kW(1));
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-kW(1));
        make.right.equalTo(self.contentView.mas_right).with.offset(-kW(1));
    }];
    self.dateButton.titleEdgeInsets = UIEdgeInsetsMake(-20, -20, 0, 0);
}

#pragma mark - Action method
- (void)choseDate:(UIButton *)btn {
    if ([self.cellDelegate respondsToSelector:@selector(clickDateWith:indexpath:)]) {
        [self.cellDelegate clickDateWith:self indexpath:self.indexpath];
    }
}

#pragma mark - lazy load
- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_dateButton setBackgroundColor:[UIColor whiteColor]];
        _dateButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _dateButton.layer.cornerRadius = kW(2);
        [_dateButton addTarget:self action:@selector(choseDate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateButton;
}

@end

