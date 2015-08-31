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

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (_dateArray.count == 0) {
//        return [[UIView alloc] initWithFrame:CGRectZero];
//    } else if (self.canPaginate && (section == _dateArray.count)) {
//        return [[UIView alloc] initWithFrame:CGRectZero];
//    }
//    
//    NSString *date = [_dateArray objectAtIndex:section];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,34)];
//    headerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//    headerView.layer.borderColor = [UIColor whiteColor].CGColor;
//    headerView.layer.borderWidth = 3.0;
//    
//    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,34)];
//    dateLabel.text = date;
//    dateLabel.font = [UIFont fontWithName:@"Thonburi" size:17.0];
//    
//    dateLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
//    [headerView addSubview:dateLabel];
//    
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LTProgressTableViewCellType cellType = indexPath.row == LTThisWeekTableViewSectionTypeWorkout ? LTProgressTableViewCellTypeWorkout : LTProgressTableViewCellTypeSalad;
    LTUserWeekLog *userWeekLog = [self.userWeekLogs objectAtIndex:indexPath.row];
    
    LTProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTProgressTableViewCell reuseIdentifier]];
    [cell setupCellWithWeekLog:userWeekLog type:cellType];
    
    return cell;
}


@end
