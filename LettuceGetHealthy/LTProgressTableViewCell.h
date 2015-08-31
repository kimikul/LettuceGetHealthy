//
//  LTProgressTableViewCell.h
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LTProgressTableViewCellTypeWorkout,
    LTProgressTableViewCellTypeSalad,
} LTProgressTableViewCellType;

@class LTUserWeekLog;

@interface LTProgressTableViewCell : UITableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)cellHeight;

- (void)setupCellWithWeekLog:(LTUserWeekLog*)userWeekLog type:(LTProgressTableViewCellType)type;

@end
