//
//  NSDate+Lettuce.m
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import "NSDate+Lettuce.h"

@implementation NSDate (Lettuce)

+ (NSDate*)startDateOfWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    NSTimeInterval interval;
    
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    
    if ([NSDate date:startOfTheWeek isSameDayAsDate:now]) {
        return [startOfTheWeek nDaysAgo:6];
    } else {
        return [startOfTheWeek dateByAddingOneDay];
    }
}


+ (NSDate*)endDateOfWeek {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startOfTheWeek;
    
    NSTimeInterval interval;
    [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
           startDate:&startOfTheWeek
            interval:&interval
             forDate:now];
    
    NSDate *endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
    
    if ([NSDate date:startOfTheWeek isSameDayAsDate:now]) {
        return [endOfWeek nDaysAgo:6];
    } else {
        return [endOfWeek dateByAddingOneDay];
    }
}

+ (NSDate*)startDateOfLastWeek {
    NSDate *startDateOfThisWeek = [NSDate startDateOfWeek];
    NSDate *startDateOFLastWeek = [startDateOfThisWeek nDaysAgo:7];
    return startDateOFLastWeek;
}

+ (NSDate*)endDateOfLastWeek {
    NSDate *endDateOfThisWeek = [NSDate endDateOfWeek];
    NSDate *endDateOFLastWeek = [endDateOfThisWeek nDaysAgo:7];
    return endDateOFLastWeek;
}

- (NSDate*)dateByAddingOneDay {
    NSDate *oneDayLater = [self dateByAddingTimeInterval:60*60*24];
    return oneDayLater;
}

- (NSDate*)nDaysAgo:(NSInteger)daysAgo {
    NSDate *nDays = [self dateByAddingTimeInterval:-1*60*60*24*daysAgo];
    return nDays;
}

+ (BOOL)date:(NSDate*)firstDate isSameDayAsDate:(NSDate*)secondDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *componentsForFirstDate = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:firstDate];
    
    NSDateComponents *componentsForSecondDate = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:secondDate];
    
    if (componentsForFirstDate.year == componentsForSecondDate.year && componentsForFirstDate.month == componentsForSecondDate.month && componentsForFirstDate.day == componentsForSecondDate.day) {
        return YES;
    }
    
    return NO;
}

+ (NSString*)dayOfTheWeek {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSInteger)numDaysTilDate:(NSDate*)date {
    NSTimeInterval numberOfSecondsUntilSelectedDate = [date timeIntervalSinceNow];
    NSInteger numberOfDays = numberOfSecondsUntilSelectedDate / (60*60*24);
    return numberOfDays;
}

@end
