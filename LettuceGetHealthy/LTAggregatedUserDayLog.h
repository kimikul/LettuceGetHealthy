//
//  LTAggregatedUserDayLog.h
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTAggregatedUserDayLog : NSObject

@property (nonatomic, strong) PFObject *user;
@property (nonatomic, assign) NSInteger totalSaladsThisWeek;
@property (nonatomic, assign) NSInteger totalWorkoutsThisWeek;

@end
