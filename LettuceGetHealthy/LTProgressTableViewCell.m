//
//  LTProgressTableViewCell.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "LTProgressTableViewCell.h"
#import "LTUserWeekLog.h"
#import "LTFileSystemImageCache.h"
#import "LTHelper.h"
#import "M13ProgressViewBar.h"

@interface LTProgressTableViewCell ()

@property (nonatomic, strong) LTUserWeekLog *userWeekLog;
@property (nonatomic, assign) LTProgressTableViewCellType cellType;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet M13ProgressViewBar *progressBar;

@end

@implementation LTProgressTableViewCell

+ (NSString*)reuseIdentifier {
    return @"LTProgressTableViewCell";
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setupCellWithWeekLog:(LTUserWeekLog*)userWeekLog type:(LTProgressTableViewCellType)type {
    _userWeekLog = userWeekLog;
    _cellType = type;
    
    [self setupProgressLabel];
    [self setupNameLabel];
    [self setupProgressBar];
    [self loadProfPic];
}

- (void)setupProgressLabel {
    NSString *noun;
    NSInteger countSoFar;
    NSInteger totalOwed;
    
    if (self.cellType == LTProgressTableViewCellTypeWorkout) {
        noun = @"workouts";
        countSoFar = self.userWeekLog.totalWorkoutsThisWeek;
        totalOwed = 4;
    } else {
        noun = @"salads";
        countSoFar = self.userWeekLog.totalSaladsThisWeek;
        totalOwed = [self.userWeekLog.user[@"saladsOwedThisWeek"] integerValue];
    }
    
    self.progressLabel.text = [NSString stringWithFormat:@"%@ of %@ %@", @(countSoFar), @(totalOwed), noun];
}

- (void)setupNameLabel {
    NSString *nameText = [LTHelper userIsMe:self.userWeekLog.user] ? @"You" : self.userWeekLog.user[@"firstName"];
    self.nameLabel.text = nameText;
}

- (void)setupProgressBar {
    self.progressBar.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
    self.progressBar.progressBarThickness = 20;
    self.progressBar.successColor = [UIColor orangeColor];
    self.progressBar.showPercentage = NO;
    
    CGFloat countSoFar;
    CGFloat totalOwed;
    
    if (self.cellType == LTProgressTableViewCellTypeWorkout) {
        countSoFar = self.userWeekLog.totalWorkoutsThisWeek;
        totalOwed = 4;
    } else {
        countSoFar = self.userWeekLog.totalSaladsThisWeek;
        totalOwed = [self.userWeekLog.user[@"saladsOwedThisWeek"] integerValue];
    }

    [self.progressBar setProgress:countSoFar/totalOwed animated:YES];
}

- (void)loadProfPic {
    NSString *photoURL = self.userWeekLog.user[@"photoURL"];
    UIImage *profPic = [[LTFileSystemImageCache shared] objectForKey:photoURL];
    if (profPic) {
        self.profilePicImageView.image = profPic;
    } else if (photoURL) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        
        dispatch_async(queue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.profilePicImageView.image = image;
                [self.profilePicImageView fadeInWithDuration:0.2 completion:nil];
                [[LTFileSystemImageCache shared] setObject:image forKey:photoURL];
            });
        });
    }
}

@end
