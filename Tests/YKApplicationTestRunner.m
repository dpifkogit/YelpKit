//
//  YKApplicationTestRunner.m
//  YelpKit
//
//  Created by Allen Cheung on 6/18/13.
//  Copyright (c) 2013 Yelp. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
