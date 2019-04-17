//
//  WTCalendarCell.h
//  GeeLockApp
//
//  Created by water on 2018/8/28.
//  Copyright © 2018年 water. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHQDateCell;

@interface LHQWeekCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *weekLabel;

@end

@protocol LHQDateCellDelegate <NSObject>

- (void)clickDateWith:(LHQDateCell *)cell indexpath:(NSIndexPath *)indexpath;

@end

@interface LHQDateCell : UICollectionViewCell

@property (nonatomic, weak) id<LHQDateCellDelegate> cellDelegate;
@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) NSIndexPath *indexpath;

@end


