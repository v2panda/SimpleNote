//
//  NSDate+Conversion.m
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "NSDate+Conversion.h"

@implementation NSDate(Conversion)

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
  return [NSDate daysBetweenDate:firstDate andDate:secondDate] == 0 ? YES : NO;
}

+ (NSInteger)daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
  if (firstDate == nil || secondDate == nil) {
    return NSIntegerMax;
  }
  NSCalendar *currentCalendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay
                                                    fromDate:firstDate
                                                      toDate:secondDate
                                                     options:0];
  NSInteger days = [components day];
  return days;
}

@end
