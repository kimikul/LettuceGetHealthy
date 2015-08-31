//
//  LTThisWeekTableSectionHeaderView.h
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LTProgressTableViewHeaderTypeWorkout,
    LTProgressTableViewHeaderTypeSalad,
} LTProgressTableViewHeaderType;

@interface LTThisWeekTableSectionHeaderView : UIView

+ (NSString*)reuseIdentifier;
+ (CGFloat)headerHeight;
- (void)setupWithType:(LTProgressTableViewHeaderType)headerType;

@end
