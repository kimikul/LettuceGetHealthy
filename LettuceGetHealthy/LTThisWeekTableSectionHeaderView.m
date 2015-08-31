//
//  LTThisWeekTableSectionHeaderView.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTThisWeekTableSectionHeaderView.h"

@interface LTThisWeekTableSectionHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@end

@implementation LTThisWeekTableSectionHeaderView

+ (NSString*)reuseIdentifier {
    return @"LTThisWeekTableSectionHeaderView";
}

+ (CGFloat)headerHeight {
    return 50;
}

- (void)setupWithType:(LTProgressTableViewHeaderType)headerType {
    if (headerType == LTProgressTableViewHeaderTypeWorkout) {
        self.headerTitle.text = @"WORKOUTS";
        self.iconImageView.image = [UIImage imageNamed:@"icon-workout"];
        self.iconImageView.tintColor = [UIColor orangeColor];
    } else {
        self.headerTitle.text = @"SALADS";
        self.iconImageView.image = [UIImage imageNamed:@"icon-salad"];
        self.iconImageView.tintColor = [UIColor lettuceGreen];
    }
}

@end
