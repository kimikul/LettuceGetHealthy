//
//  LTThisWeekViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTThisWeekViewController.h"
#import "LTAggregatedUserDayLog.h"

@interface LTThisWeekViewController ()
@property (nonatomic, strong) NSArray *aggregatedUserDaylogs;
@end

@implementation LTThisWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchData];
}

- (void)fetchData {
    NSDate *startDate = [NSDate startDateOfWeek];
    NSDate *endDate = [NSDate endDateOfWeek];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DayLog"];
    [query whereKey:@"date" greaterThanOrEqualTo:startDate];
    [query whereKey:@"date" lessThanOrEqualTo:endDate];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [self processAllDayLogs:objects];
        }
    }];
}

- (void)processAllDayLogs:(NSArray*)objects {
    NSMutableArray *aggregatedUserDayLogs = [NSMutableArray new];
    
    for (PFObject *dayLog in objects) {
        LTAggregatedUserDayLog *userDayLog = [self aggregatedUserDayLogForUser:dayLog[@"user"] inArray:aggregatedUserDayLogs];
        
        if (!userDayLog) {
            LTAggregatedUserDayLog *aggregatedUserDayLog = [LTAggregatedUserDayLog new];
            aggregatedUserDayLog.user = dayLog[@"user"];
            aggregatedUserDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            aggregatedUserDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
            
            [aggregatedUserDayLogs addObject:aggregatedUserDayLog];
        } else {
            userDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            userDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
        }
    }
    
    self.aggregatedUserDaylogs = aggregatedUserDayLogs;
}

- (LTAggregatedUserDayLog*)aggregatedUserDayLogForUser:(PFObject*)user inArray:(NSArray*)aggregatedUserDayLogsArray {
    for (LTAggregatedUserDayLog *dayLog in aggregatedUserDayLogsArray) {
        if ([dayLog.user.objectId isEqualToString:user.objectId]) {
            return dayLog;
        }
    }
    
    return nil;
}

@end
