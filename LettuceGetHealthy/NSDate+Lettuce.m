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
        return [startOfTheWeek sixDaysAgo];
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
        return [endOfWeek sixDaysAgo];
    } else {
        return [endOfWeek dateByAddingOneDay];
    }
}

- (NSDate*)dateByAddingOneDay {
    NSDate *oneDayLater = [self dateByAddingTimeInterval:60*60*24];
    return oneDayLater;
}

- (NSDate*)sixDaysAgo {
    NSDate *sixDaysAgo = [self dateByAddingTimeInterval:-1*60*60*24*6];
    return sixDaysAgo;
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

@end
