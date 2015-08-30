//
//  LTTodayViewController.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/29/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTTodayViewController.h"
#import "UIColor+Lettuce.h"

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

    [self setupButton:self.yesWorkoutButton];
    [self setupButton:self.noWorkoutButton];
    [self setupButton:self.zeroSaladsButton];
    [self setupButton:self.oneSaladButton];
    [self setupButton:self.twoSaladButton];
    [self setupButton:self.doneButton];
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
}

- (IBAction)nopeWorkoutButtonTapped:(id)sender {
    [self selectButton:self.noWorkoutButton];
    [self unselectButton:self.yesWorkoutButton];
}

- (IBAction)zeroSaladsButtonTapped:(id)sender {
    [self selectButton:self.zeroSaladsButton];
    [self unselectButton:self.oneSaladButton];
    [self unselectButton:self.twoSaladButton];
}

- (IBAction)oneSaladButtonTapped:(id)sender {
    [self selectButton:self.oneSaladButton];
    [self unselectButton:self.zeroSaladsButton];
    [self unselectButton:self.twoSaladButton];
}

- (IBAction)twoSaladsButtonTapped:(id)sender {
    [self selectButton:self.twoSaladButton];
    [self unselectButton:self.zeroSaladsButton];
    [self unselectButton:self.oneSaladButton];
}
@end
