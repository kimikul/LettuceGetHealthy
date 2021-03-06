//
//  NSDate+Lettuce.h
//  LettuceGetHealthy
//
//  Created by Kimberly Hsiao on 8/30/15.
//  Copyright (c) 2015 hsiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Lettuce)

+ (NSDate*)startDateOfWeek;
+ (NSDate*)endDateOfWeek;
+ (NSDate*)startDateOfLastWeek;
+ (NSDate*)endDateOfLastWeek;

+ (BOOL)date:(NSDate*)firstDate isSameDayAsDate:(NSDate*)secondDate;
+ (NSString*)dayOfTheWeek;
+ (NSInteger)numDaysTilDate:(NSDate*)date;

@end
