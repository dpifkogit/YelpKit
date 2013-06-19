//
//  YKUIButtonViewTest.m
//  YelpKit
//
//  Created by Allen Cheung on 6/19/13.
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

#import "YKViewTestCase.h"
#import <YelpKit/YelpKit.h>

@interface YKUIButtonViewTest : YKViewTestCase {
  UIView *_superView;
  YKUIListView *_listView;
  YKUIListView *_pressedListView;
}
@end

@implementation YKUIButtonViewTest

- (void)setUp {
  [super setUp];
  _superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
  _listView = [[YKUIListView alloc] init];
  _listView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  _listView.frame = CGRectMake(0, 0, 320, 100);
  [_superView addSubview:_listView];
  [_listView release];
  _pressedListView = [[YKUIListView alloc] init];
  _pressedListView.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  _pressedListView.frame = CGRectMake(0, 100, 320, 100);
  [_superView addSubview:_pressedListView];
  [_pressedListView release];
}

- (void)tearDown {
  [_superView release];
  [super tearDown];
}

- (YKUIButton *)_button {
  YKUIButton *button = [[YKUIButton alloc] init];
  button.title = @"Button";
  button.titleColor = [UIColor darkGrayColor];
  button.titleFont = [UIFont boldSystemFontOfSize:15];
  button.color = [UIColor whiteColor];
  button.borderColor = [UIColor darkGrayColor];
  button.insets = UIEdgeInsetsMake(10, 10, 10, 10);
  button.borderStyle = YKUIBorderStyleRounded;
  button.cornerRadius = 10.0f;
  button.borderWidth = 1.0f;
  button.highlightedColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
  button.shadingType = YKUIShadingTypeLinear;
  button.highlightedShadingType = YKUIShadingTypeLinear;
  button.disabledShadingType = YKUIShadingTypeNone;
  button.disabledTitleShadowColor = [UIColor colorWithWhite:0 alpha:0]; // Disables title shadow if set
  button.disabledColor = [UIColor colorWithWhite:239.0f/255.0f alpha:1.0f];
  button.disabledTitleColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  button.disabledBorderColor = [UIColor colorWithWhite:216.0f/255.0f alpha:1.0f];
  [button setTarget:self action:@selector(_buttonSelected:)];
  return [button autorelease];
}

- (YKUIButton *)_buttonOnePressed:(BOOL)pressed {
  YKUIButton *button = [self _button];
  button.title = @"Button (icon, accessory, center, wrapping text)";
  button.titleAlignment = NSTextAlignmentCenter;
  button.titleInsets = UIEdgeInsetsMake(0, 10, 0, 0);
  button.accessoryImage = [UIImage imageNamed:@"button_accessory_image.png"];
  button.highlightedAccessoryImage = [UIImage imageNamed:@"button_accessory_image_selected.png"];
  button.iconImage = [UIImage imageNamed:@"button_icon.png"];
  button.selected = pressed;
  return button;
}

- (void)testButtonOne {
  [_listView addView:[self _buttonOnePressed:NO]];
  [_pressedListView addView:[self _buttonOnePressed:YES]];
  GHVerifyView(_superView);
}

- (YKUIButton *)_facebookButtonPressed:(BOOL)pressed {
  YKUIButton *fbButton = [self _button];
  fbButton.titleShadowColor = [UIColor colorWithWhite:0.2 alpha:0.5];
  fbButton.titleShadowOffset = CGSizeMake(0, -1);
  fbButton.title = @"Facebook";
  fbButton.cornerRadius = 6.0;
  fbButton.titleColor = [UIColor whiteColor];
  fbButton.color = [UIColor colorWithRed:98.0f/255.0f green:120.0f/255.0f blue:170.0f/255.0f alpha:1.0];
  fbButton.color2 = [UIColor colorWithRed:44.0f/255.0f green:70.0f/255.0f blue:126.0f/255.0f alpha:1.0];
  fbButton.highlightedTitleColor = [UIColor whiteColor];
  fbButton.highlightedColor = [UIColor colorWithRed:70.0f/255.0f green:92.0f/255.0f blue:138.0f/255.0f alpha:1.0];
  fbButton.highlightedColor2 = [UIColor colorWithRed:44.0f/255.0f green:70.0f/255.0f blue:126.0f/255.0f alpha:1.0];
  fbButton.disabledColor = [UIColor colorWithWhite:0.6 alpha:1.0];
  fbButton.disabledColor2 = [UIColor colorWithWhite:0.7 alpha:1.0];
  fbButton.disabledBorderColor = [UIColor grayColor];
  fbButton.selected = pressed;
  return fbButton;
}

- (void)testFacebookButton {
  [_listView addView:[self _facebookButtonPressed:NO]];
  [_pressedListView addView:[self _facebookButtonPressed:YES]];
  GHVerifyView(_superView);
}

- (YKUIButton *)_inverseButtonPressed:(BOOL)pressed {
  YKUIButton *inverseButton = [self _button];
  inverseButton.titleShadowColor = [UIColor colorWithWhite:0.2 alpha:0.5];
  inverseButton.titleShadowOffset = CGSizeMake(0, -1);
  inverseButton.title = @"Inverse";
  inverseButton.titleColor = [UIColor whiteColor];
  inverseButton.color = [UIColor colorWithWhite:66.0f/255.0f alpha:1.0];
  inverseButton.color2 = [UIColor colorWithWhite:35.0f/255.0f alpha:1.0];
  inverseButton.borderColor = [UIColor colorWithWhite:48.0f/255.0f alpha:1.0];
  inverseButton.highlightedColor = [UIColor colorWithWhite:30.0f/255.0f alpha:1.0];
  inverseButton.highlightedColor2 = [UIColor colorWithWhite:34.0f/255.0f alpha:1.0];
  inverseButton.selected = pressed;
  return inverseButton;
}

- (void)testInverseButton {
  [_listView addView:[self _inverseButtonPressed:NO]];
  [_pressedListView addView:[self _inverseButtonPressed:YES]];
  GHVerifyView(_superView);
}

- (YKUIButton *)_defaultButtonPressed:(BOOL)pressed {
  YKUIButton *defaultButton = [self _button];
  defaultButton.titleShadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
  defaultButton.titleShadowOffset = CGSizeMake(0, -1);
  defaultButton.title = @"Default";
  defaultButton.titleColor = [UIColor colorWithWhite:51.0f/255.0f alpha:1.0];
  defaultButton.color = [UIColor whiteColor];
  defaultButton.color2 = [UIColor colorWithWhite:0.9 alpha:1.0];
  defaultButton.titleColor = [UIColor colorWithWhite:51.0f/255.0f alpha:1.0];
  defaultButton.borderColor = [UIColor colorWithWhite:184.0f/255.0f alpha:1.0];
  defaultButton.highlightedColor = [UIColor colorWithWhite:203.0f/255.0f alpha:1.0];
  defaultButton.highlightedColor2 = [UIColor colorWithWhite:230.0f/255.0f alpha:1.0];
  defaultButton.selected = pressed;
  return defaultButton;
}

- (void)testDefaultButton {
  [_listView addView:[self _defaultButtonPressed:NO]];
  [_pressedListView addView:[self _defaultButtonPressed:YES]];
  GHVerifyView(_superView);
}

@end
