//
//  LTTodayViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/29/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTTodayViewController.h"
#import "UIColor+Lettuce.h"
#import <Parse/Parse.h>

static NSString *LTDidWorkoutDefaultsKey = @"LTDidWorkoutDefaultsKey";
static NSString *LTSaladCountDefaultsKey = @"LTSaladCountDefaultsKey";

@interface LTTodayViewController ()

@property (weak, nonatomic) IBOutlet UIButton *yesWorkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *noWorkoutButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroSaladsButton;
@property (weak, nonatomic) IBOutlet UIButton *oneSaladButton;
@property (weak, nonatomic) IBOutlet UIButton *twoSaladButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation LTTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtons];
    [self setupTitle];
    [self setupSavedValues];
}

- (void)setupButtons {
    [self setupButton:self.yesWorkoutButton];
    [self setupButton:self.noWorkoutButton];
    [self setupButton:self.zeroSaladsButton];
    [self setupButton:self.oneSaladButton];
    [self setupButton:self.twoSaladButton];
    [self setupButton:self.doneButton];
}

- (void)setupSavedValues {
    NSNumber *savedSaladCount = [self savedSaladCount];
    NSNumber *savedWorkout = [self savedWorkout];
    
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
}

- (void)setupTitle {
    NSString *title = [self spelledOutDate:[NSDate date]];
    self.title = title;
}

#pragma mark - title helper

- (NSString*)spelledOutDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eeee, MMMM d"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

#pragma mark - button helpers

- (void)setupButton:(UIButton*)button {
    button.layer.cornerRadius = 4.0;
    button.layer.masksToBounds = NO;
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
    [self saveWorkout:YES];
}

- (IBAction)nopeWorkoutButtonTapped:(id)sender {
    [self selectButton:self.noWorkoutButton];
    [self unselectButton:self.yesWorkoutButton];
    [self saveWorkout:NO];
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

#pragma mark - user defaults

- (NSNumber*)savedSaladCount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *count = [defaults objectForKey:LTSaladCountDefaultsKey];
    return count;
}

- (NSNumber*)savedWorkout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *didWorkout = [defaults objectForKey:LTDidWorkoutDefaultsKey];
    return didWorkout;
}

- (void)saveSaladCount:(NSInteger)count {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(count) forKey:LTSaladCountDefaultsKey];
    [defaults synchronize];
}

- (void)saveWorkout:(BOOL)didWorkout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(didWorkout) forKey:LTDidWorkoutDefaultsKey];
    [defaults synchronize];
}

@end
