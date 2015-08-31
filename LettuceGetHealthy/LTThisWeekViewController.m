//
//  LTThisWeekViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTThisWeekViewController.h"
#import "LTUserWeekLog.h"
#import "LTProgressTableViewCell.h"
#import "M13ProgressViewBar.h"
#import "LTThisWeekTableSectionHeaderView.h"

typedef enum {
    LTThisWeekTableViewSectionTypeWorkout,
    LTThisWeekTableViewSectionTypeSalad,
    LTThisWeekTableViewSectionTypeCount,
} LTThisWeekTableViewSectionType;

@interface LTThisWeekViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *userWeekLogs;
@end

@implementation LTThisWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"This Week";
    
    [self setupTable];
    [self fetchData];
}

- (void)setupTable {
    [self.tableView registerNib:[UINib nibWithNibName:[LTProgressTableViewCell reuseIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[LTProgressTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[LTThisWeekTableSectionHeaderView reuseIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[LTThisWeekTableSectionHeaderView reuseIdentifier]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
            [self.tableView reloadData];
            
        }
    }];
}

- (void)processAllDayLogs:(NSArray*)objects {
    NSMutableArray *aggregatedUserDayLogs = [NSMutableArray new];
    
    for (PFObject *dayLog in objects) {
        LTUserWeekLog *userDayLog = [self aggregatedUserDayLogForUser:dayLog[@"user"] inArray:aggregatedUserDayLogs];
        
        if (!userDayLog) {
            LTUserWeekLog *aggregatedUserDayLog = [LTUserWeekLog new];
            aggregatedUserDayLog.user = dayLog[@"user"];
            aggregatedUserDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            aggregatedUserDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
            
            [aggregatedUserDayLogs addObject:aggregatedUserDayLog];
        } else {
            userDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            userDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
        }
    }
    
    self.userWeekLogs = aggregatedUserDayLogs;
}

- (LTUserWeekLog*)aggregatedUserDayLogForUser:(PFObject*)user inArray:(NSArray*)aggregatedUserDayLogsArray {
    for (LTUserWeekLog *dayLog in aggregatedUserDayLogsArray) {
        if ([dayLog.user.objectId isEqualToString:user.objectId]) {
            return dayLog;
        }
    }
    
    return nil;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return LTThisWeekTableViewSectionTypeCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userWeekLogs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LTProgressTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [LTThisWeekTableSectionHeaderView headerHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LTProgressTableViewHeaderType headerType = section == LTThisWeekTableViewSectionTypeWorkout ? LTProgressTableViewHeaderTypeWorkout : LTProgressTableViewHeaderTypeSalad;

    LTThisWeekTableSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[LTThisWeekTableSectionHeaderView reuseIdentifier]];
    [headerView setupWithType:headerType];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTProgressTableViewCellType cellType = indexPath.section == LTThisWeekTableViewSectionTypeWorkout ? LTProgressTableViewCellTypeWorkout : LTProgressTableViewCellTypeSalad;
    LTUserWeekLog *userWeekLog = [self.userWeekLogs objectAtIndex:indexPath.row];
    
    LTProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTProgressTableViewCell reuseIdentifier]];
    [cell setupCellWithWeekLog:userWeekLog type:cellType];
    
    return cell;
}


@end
