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
#import "LTHelper.h"

typedef enum {
    LTThisWeekTableViewSectionTypeWorkout,
    LTThisWeekTableViewSectionTypeSalad,
    LTThisWeekTableViewSectionTypeCount,
} LTThisWeekTableViewSectionType;

@interface LTThisWeekViewController ()

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *userWeekLogs;
@property (nonatomic, strong) LTUserWeekLog *currentUserWeekLog;

@end

@implementation LTThisWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"This Week";
    
    [self setupObservers];
    [self setupTable];
    [self fetchData];
}

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:LTDidSubmitLogNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)setupTable {
    [self.tableView registerNib:[UINib nibWithNibName:[LTProgressTableViewCell reuseIdentifier] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[LTProgressTableViewCell reuseIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[LTThisWeekTableSectionHeaderView reuseIdentifier] bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:[LTThisWeekTableSectionHeaderView reuseIdentifier]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupSummaryLabel {
    NSInteger remainingDays = [self remainingDaysInWeek];
    NSString *daysModifier = remainingDays == 1 ? @"" : @"s";
    NSString *daysString = [NSString stringWithFormat:@"%@ more day%@", @(remainingDays), daysModifier];
    
    NSInteger remainingWorkouts = 4 - self.currentUserWeekLog.totalWorkoutsThisWeek;
    NSString *workoutModifier = (remainingWorkouts == 1) ? @"" : @"s";
    NSString *workoutString = [NSString stringWithFormat:@"%@ workout%@", @(remainingWorkouts), workoutModifier];

    NSInteger remainingSalads = [self.currentUserWeekLog.user[@"saladsOwedThisWeek"] integerValue] - self.currentUserWeekLog.totalSaladsThisWeek;
    NSString *saladModifier = (remainingSalads == 1) ? @"" : @"s";
    NSString *saladString = [NSString stringWithFormat:@"%@ salad%@", @(remainingSalads), saladModifier];
    
    NSString *text = [NSString stringWithFormat:@"You have %@ to complete %@ and eat %@", daysString, workoutString, saladString];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]}];
    
    NSRange daysRange = [text rangeOfString:daysString];
    NSRange workoutsRange = [text rangeOfString:workoutString];
    NSRange saladsRange = [text rangeOfString:saladString];
    
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.8 alpha:1.0] range:daysRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:workoutsRange];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor lettuceGreen] range:saladsRange];

    self.summaryLabel.attributedText = attrString;
}

- (NSInteger)remainingDaysInWeek {
    NSInteger remainingDays = [NSDate numDaysTilDate:[NSDate endDateOfWeek]];
    NSNumber *hasSubmittedToday = [[NSUserDefaults standardUserDefaults] objectForKey:LTHasSubmittedTodayDefaultsKey];
    if (![hasSubmittedToday isEqualToNumber:@(1)]) {
        remainingDays++;
    }
    
    return remainingDays;
}

#pragma mark - data 

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
            [self setupSummaryLabel];
            [self.tableView reloadData];
        }
    }];
}

- (void)processAllDayLogs:(NSArray*)objects {
    NSMutableArray *aggregatedUserDayLogs = [NSMutableArray new];
    
    for (PFObject *dayLog in objects) {
        PFObject* user = dayLog[@"user"];
        
        LTUserWeekLog *userDayLog = [self aggregatedUserDayLogForUser:user inArray:aggregatedUserDayLogs];
             
        if (!userDayLog) {
            LTUserWeekLog *aggregatedUserDayLog = [LTUserWeekLog new];
            aggregatedUserDayLog.user = user;
            aggregatedUserDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            aggregatedUserDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
            
            [aggregatedUserDayLogs addObject:aggregatedUserDayLog];
        } else {
            userDayLog.totalSaladsThisWeek += ([dayLog[@"saladCount"] integerValue]);
            userDayLog.totalWorkoutsThisWeek += ([dayLog[@"workoutCount"] integerValue]);
        }
        
        if ([LTHelper userIsMe:user]) {
            self.currentUserWeekLog = userDayLog;
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

#pragma mark - notification handlers

- (void)didSubmitLog:(NSNotification*)note {
    [self fetchData];
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
