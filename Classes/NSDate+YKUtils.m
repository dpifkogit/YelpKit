//
//  NSDate+YKUtils.m
//  YelpKit
//
//  Created by Nader Akoury on 3/5/13.
//  Copyright (c) 2013 Yelp. All rights reserved.
//

#import "NSDate+YKUtils.h"

@implementation NSDate(YKUtils)

- (NSInteger)yk_dayDelta:(NSDate *)date {
  return [self yk_dayDelta:date timeZone:nil];
}

- (NSInteger)yk_dayDelta:(NSDate *)date timeZone:(NSTimeZone *)timeZone {
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSUInteger flags = (NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit);
  NSDate *ourDate = [cal dateFromComponents:[self gh_dateComponentsFromFlags:flags timeZone:timeZone]];
  NSDate *theirDate = [cal dateFromComponents:[date gh_dateComponentsFromFlags:flags timeZone:timeZone]];
  
  return [[cal components:NSDayCalendarUnit fromDate:ourDate toDate:theirDate options:0] day];
}

- (BOOL)yk_isSameDay:(NSDate *)date {
  return [self yk_isSameDay:date timeZone:nil];
}

- (BOOL)yk_isSameDay:(NSDate *)date timeZone:(NSTimeZone *)timeZone{
  return [self yk_dayDelta:date timeZone:timeZone] == 0;
}

@end