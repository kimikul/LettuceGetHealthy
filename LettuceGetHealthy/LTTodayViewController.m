//
//  LTTodayViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/29/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTTodayViewController.h"
#import "LTHelper.h"

static NSString *LTDidWorkoutDefaultsKey = @"LTDidWorkoutDefaultsKey";
static NSString *LTSaladCountDefaultsKey = @"LTSaladCountDefaultsKey";

@interface LTTodayViewController ()

@property (weak, nonatomic) IBOutlet UIButton *yesWorkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *noWorkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroSaladsButton;
@property (weak, nonatomic) IBOutlet UIButton *oneSaladButton;
@property (weak, nonatomic) IBOutlet UIButton *twoSaladButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *allDoneView;
@property (weak, nonatomic) IBOutlet UILabel *allDoneWorkoutsLabel;
@property (weak, nonatomic) IBOutlet UILabel *allDoneSaladsLabel;
@property (weak, nonatomic) IBOutlet UIView *allDoneHeaderView;
@property (weak, nonatomic) IBOutlet UIView *allDoneWorkoutsView;
@property (weak, nonatomic) IBOutlet UIView *allDoneSaladsView;
@property (weak, nonatomic) IBOutlet UIImageView *dumbellIcon;
@property (weak, nonatomic) IBOutlet UIImageView *saladBowlIcon;
@property (weak, nonatomic) IBOutlet UIView *dumbbellCircleView;
@property (weak, nonatomic) IBOutlet UIView *saladCircleView;

@end

@implementation LTTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupObservers];
    [self setupButtons];
    [self setupAllDoneView];
    [self refreshView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self clearPreviousLogsIfNecessary];
}

#pragma mark - setup

- (void)setupObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)setupButtons {
    [self addRoundedCornersToView:self.yesWorkoutButton];
    [self addRoundedCornersToView:self.noWorkoutButton];
    [self addRoundedCornersToView:self.zeroSaladsButton];
    [self addRoundedCornersToView:self.oneSaladButton];
    [self addRoundedCornersToView:self.twoSaladButton];
    [self addRoundedCornersToView:self.doneButton];
}

- (void)setupAllDoneView {
    [self addRoundedCornersToView:self.allDoneHeaderView];
    [self addRoundedCornersToView:self.allDoneWorkoutsView];
    [self addRoundedCornersToView:self.allDoneSaladsView];
    
    UIImage *saladBowlIcon = [UIImage imageNamed:@"icon-salad"];
    [saladBowlIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.saladBowlIcon.tintColor = [UIColor lettuceGreen];
    [self.saladBowlIcon setImage:saladBowlIcon];
    
    UIImage *dumbbellIcon = [UIImage imageNamed:@"icon-workout"];
    [dumbbellIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dumbellIcon.tintColor = [UIColor orangeColor];
    [self.dumbellIcon setImage:dumbbellIcon];
    
    self.dumbbellCircleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dumbbellCircleView.layer.borderWidth = 2.0;
    self.dumbbellCircleView.backgroundColor = [UIColor darkGrayColor];
    self.saladCircleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.saladCircleView.layer.borderWidth = 2.0;
    self.saladCircleView.backgroundColor = [UIColor darkGrayColor];
}

- (void)setupTitle {
    NSString *title = [self spelledOutDate:[NSDate date]];
    self.title = title;
}

#pragma mark - fetch saved values

- (void)processSavedValues {
    NSNumber *hasSubmittedToday = [self savedSubmittedSetting];
    if ([hasSubmittedToday isEqualToNumber:@(1)]) {
        [self showAllDoneForTodayViewWorkoutCount:[self savedWorkoutCount] saladCount:[self savedSaladCount] animation:NO];
    } else {
        [self showSavedCounts];
    }
}

- (void)showSavedCounts {
    NSNumber *savedSaladCount = [self savedSaladCount];
    NSNumber *savedWorkout = [self savedWorkoutCount];
    
    if (savedSaladCount) {
        NSInteger count = savedSaladCount.integerValue;
        if (count == 0) {
            [self selectButton:self.zeroSaladsButton];
        } else if (count == 1) {
            [self selectButton:self.oneSaladButton];
        } else if (count == 2) {
            [self selectButton:self.twoSaladButton];
        }
    }
    
    if (savedWorkout) {
        NSInteger didWorkout = savedWorkout.integerValue;
        if (didWorkout == 0) {
            [self selectButton:self.noWorkoutButton];
        } else if (didWorkout == 1) {
            [self selectButton:self.yesWorkoutButton];
        }
    }
    
    self.allDoneView.hidden = YES;
}

#pragma mark - title helper

- (NSString*)spelledOutDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM d"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

#pragma mark - view

- (void)refreshView {
    [self setupTitle];
    [self processSavedValues];
}

- (void)showAllDoneForTodayViewWorkoutCount:(NSNumber*)workoutCount saladCount:(NSNumber*)saladCount animation:(BOOL)animate {
    NSString *workoutModifier = workoutCount.integerValue != 1 ? @"S" : @"";
    NSString *saladsModifier = saladCount.integerValue != 1 ? @"S" : @"";
    
    self.allDoneWorkoutsLabel.text = [NSString stringWithFormat:@"%@ WORKOUT%@",workoutCount,workoutModifier];
    self.allDoneSaladsLabel.text = [NSString stringWithFormat:@"%@ SALAD%@",saladCount,saladsModifier];
    
    double duration = animate ? 0.3 : 0.0;
    [self.allDoneView fadeInWithDuration:duration completion:nil];
}

#pragma mark - notification handlers

- (void)didEnterForeground:(NSNotification*)note {
    [self clearPreviousLogsIfNecessary];
}

#pragma mark - button helpers

- (void)addRoundedCornersToView:(UIView*)view {
    view.layer.cornerRadius = 4.0;
    view.layer.masksToBounds = NO;
}

- (void)selectButton:(UIButton*)button {
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lettuceGreen];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
}

- (void)unselectButton:(UIButton*)button {
    [button setTitleColor:[UIColor lettuceGreen] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
}

#pragma mark - ibactions

- (IBAction)yupWorkoutButtonTapped:(id)sender {
    [self selectButton:self.yesWorkoutButton];
    [self unselectButton:self.noWorkoutButton];
    [self saveWorkout:1];
}

- (IBAction)nopeWorkoutButtonTapped:(id)sender {
    [self selectButton:self.noWorkoutButton];
    [self unselectButton:self.yesWorkoutButton];
    [self saveWorkout:0];
}

- (IBAction)zeroSaladsButtonTapped:(id)sender {
    [self selectButton:self.zeroSaladsButton];
    [self unselectButton:self.oneSaladButton];
    [self unselectButton:self.twoSaladButton];
    [self saveSaladCount:0];
}

- (IBAction)oneSaladButtonTapped:(id)sender {
    [self selectButton:self.oneSaladButton];
    [self unselectButton:self.zeroSaladsButton];
    [self unselectButton:self.twoSaladButton];
    [self saveSaladCount:1];
}

- (IBAction)twoSaladsButtonTapped:(id)sender {
    [self selectButton:self.twoSaladButton];
    [self unselectButton:self.zeroSaladsButton];
    [self unselectButton:self.oneSaladButton];
    [self saveSaladCount:2];
}

- (IBAction)doneTapped:(id)sender {
    NSDate *today = [NSDate date];
    PFObject *currentUser = [LTHelper currentUser];
    
    PFObject *dayLog = [PFObject objectWithClassName:@"DayLog"];
    dayLog[@"saladCount"] = [self savedSaladCount] ?: @(0);
    dayLog[@"workoutCount"] = [self savedWorkoutCount] ?: @(0);
    dayLog[@"date"] = today;
    dayLog[@"user"] = currentUser;
    
    [dayLog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self saveSubmittedSetting:@(1)];
            [self saveSubmittedDate:today];
            [self showAllDoneForTodayViewWorkoutCount:dayLog[@"workoutCount"] saladCount:dayLog[@"saladCount"] animation:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error saving your entry. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

#pragma mark - clear log when day changes

- (void)clearPreviousLogsIfNecessary {
    NSDate *lastSubmittedDate = [self savedSubmittedDate];
    if (lastSubmittedDate && ![NSDate date:lastSubmittedDate isSameDayAsDate:[NSDate date]]) {
        [self clearOutPreviousSettings];
        [self setupTitle];
        [self processSavedValues];
    }
}

- (void)clearOutPreviousSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LTDidWorkoutDefaultsKey];
    [defaults removeObjectForKey:LTSaladCountDefaultsKey];
    [defaults removeObjectForKey:LTHasSubmittedTodayDefaultsKey];
    [defaults removeObjectForKey:LTLastSubmittedDateKey];
    [defaults synchronize];
}

#pragma mark - user defaults

- (NSNumber*)savedSubmittedSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *hasSubmitted = [defaults objectForKey:LTHasSubmittedTodayDefaultsKey];
    return hasSubmitted;
}

- (NSNumber*)savedSaladCount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *count = [defaults objectForKey:LTSaladCountDefaultsKey];
    return count;
}

- (NSNumber*)savedWorkoutCount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *didWorkout = [defaults objectForKey:LTDidWorkoutDefaultsKey];
    return didWorkout;
}

- (NSDate*)savedSubmittedDate {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastSubmittedDate = [defaults objectForKey:LTLastSubmittedDateKey];
    return lastSubmittedDate;
}

- (void)saveSubmittedSetting:(NSNumber*)submitted {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:submitted forKey:LTHasSubmittedTodayDefaultsKey];
    [defaults synchronize];
}

- (void)saveSubmittedDate:(NSDate*)date {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date forKey:LTLastSubmittedDateKey];
    [defaults synchronize];
}

- (void)saveSaladCount:(NSInteger)count {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(count) forKey:LTSaladCountDefaultsKey];
    [defaults synchronize];
}

- (void)saveWorkout:(NSInteger)didWorkout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(didWorkout) forKey:LTDidWorkoutDefaultsKey];
    [defaults synchronize];
}

@end
