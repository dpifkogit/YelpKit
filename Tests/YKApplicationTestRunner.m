//
//  YKApplicationTestRunner.m
//  YelpKit
//
//  Created by Allen Cheung on 6/18/13.
//  Copyright (c) 2013 Yelp. All rights reserved.
//

#import "YKApplicationTestRunner.h"
#import "YKUITestApplicationDelegate.h"

@implementation YKApplicationTestRunner

- (id)init {
  if ((self = [super init])) {
    if (getenv("GHUNIT_CLI") && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 6.0) {
      
      // Looks like the app delegate doesn't get init'd until after this method, so do it manually.
      self.delegate = [[YKUITestApplicationDelegate alloc] init];
      
      __block BOOL done = NO;
      NSOperationQueue *queue = [[NSOperationQueue alloc ] init];
      [queue addOperationWithBlock:^{
        NSInteger status = [GHTestRunner run];
        if (status != 0) {
          NSString *reason = [NSString stringWithFormat:@"Failed to test with status: %d", status];
          @throw [NSException exceptionWithName:@"TestFailure" reason:reason userInfo:nil];
        }
        done = YES;
      }];
      
      while (!done) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
      }
    }
  }
  return self;
}

@end
