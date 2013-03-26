//
//  NSDate+YKUtils.h
//  YelpKit
//
//  Created by Nader Akoury on 3/5/13.
//  Copyright (c) 2013 Yelp. All rights reserved.
//

@interface NSDate (YKUtils)

/*!
 Returns the number of days delta between this date and the passed in date.

 @param date Date to compare to
 @result NSInteger number of days delta (negative means in the past)
 */
- (NSInteger)yk_dayDelta:(NSDate *)date;

/*!
 Returns the number of days delta between this date and the passed in date.

 @param date Date to compare to
 @param timeZone Time zone
 @result NSInteger number of days delta (negative means in the past)
 */
- (NSInteger)yk_dayDelta:(NSDate *)date timeZone:(NSTimeZone *)timeZone;

/*!
 Whether this day is equal to the passed in day.

 @param date Date to compare to
 @result YES if days are equal
 */
- (BOOL)yk_isSameDay:(NSDate *)date;

/*!
 Whether this day is equal to the passed in day.

 @param date Date to compare to
 @param timeZone Time zone
 @result YES if days are equal
 */
- (BOOL)yk_isSameDay:(NSDate *)date timeZone:(NSTimeZone *)timeZone;

@end