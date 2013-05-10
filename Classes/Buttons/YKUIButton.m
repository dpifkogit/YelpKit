//
//  YKUIButton.m
//  YelpKit
//
//  Created by Gabriel Handford on 12/17/08.
//  Copyright 2008 Yelp. All rights reserved.
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

#import "YKUIButton.h"
#import "YKDefines.h"
#import "YKUIImageView.h"

#define kAccessoryOffsetFromRight (10)

@interface YKUIButton ()
@property (copy, nonatomic) NSString *displayedTitle;
@end

@implementation YKUIButton

- (id)init {
  return [self initWithFrame:CGRectZero];
}

- (void)sharedInit {
  [super sharedInit];
  self.userInteractionEnabled = YES;
  self.layout = [YKLayout layoutForView:self];
  self.opaque = YES;
  self.backgroundColor = [UIColor clearColor];
  self.contentMode = UIViewContentModeRedraw;
  _titleAlignment = UITextAlignmentCenter;
  _insets = UIEdgeInsetsZero;
  _titleInsets = UIEdgeInsetsZero;
  _iconImageSize = CGSizeZero;
  _highlightedEnabled = YES;
  _iconOrigin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
  _selectedShadingType = YKUIShadingTypeUnknown;
  _highlightedShadingType = YKUIShadingTypeUnknown;
  _disabledShadingType = YKUIShadingTypeUnknown;
  _margin = UIEdgeInsetsZero;
  _disabledAlpha = 1.0;
  _titleColor = [[UIColor blackColor] retain];
  _titleFont = [[UIFont boldSystemFontOfSize:14.0] retain];
  _titleShadowOffset = CGSizeZero;
  self.accessibilityTraits |= UIAccessibilityTraitButton;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
  if ((self = [self initWithFrame:frame])) {
    self.title = title;
    [self setTarget:target action:action];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
  if ((self = [self initWithFrame:frame title:title target:nil action:NULL])) { }
  return self;
}

- (id)initWithContentView:(UIView *)contentView {
  if ((self = [self initWithFrame:CGRectZero])) {
    [self setContentView:contentView];
  }
  return self;
}

- (void)dealloc {
  [_title release];
  [_titleFont release];
  [_titleColor release];
  [_color release];
  [_color2 release];
  [_color3 release];
  [_color4 release];
  [_highlightedTitleColor release];
  [_highlightedColor release];
  [_highlightedColor2 release];
  [_highlightedBorderColor release];
  [_highlightedBorderShadowColor release];
  [_highlightedIconImage release];
  [_highlightedTitleShadowColor release];
  [_disabledColor2 release];
  [_disabledTitleColor release];
  [_disabledColor release];
  [_disabledIconImage release];
  [_disabledBorderColor release];
  [_disabledTitleShadowColor release];
  [_borderColor release];
  [_borderShadowColor release];
  [_selectedColor release];
  [_selectedColor2 release];
  [_selectedBorderShadowColor release];
  [_selectedIconImage release];
  [_selectedTitleColor release];
  [_selectedTitleShadowColor release];
  [_titleShadowColor release];
  [_iconImageView release];
  [_accessoryImage release];
  [_highlightedAccessoryImage release];
  [_image release];
  [_highlightedImage release];
  [_disabledImage release];
  [_secondaryTitle release];
  [_secondaryTitleColor release];
  [_secondaryTitleFont release];
  [_contentView release];
  [_abbreviatedTitle release];
  [_iconShadowColor release];
  [super dealloc];
}

+ (YKUIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title {
  return [[[[self class] alloc] initWithFrame:frame title:title] autorelease];
}

+ (YKUIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
  return [self buttonWithFrame:CGRectZero title:title target:target action:action];
}

+ (YKUIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
  return [[[[self class] alloc] initWithFrame:frame title:title target:target action:action] autorelease];
}

- (NSString *)description {
  return YKDescription(@"title");
}

- (CGSize)_sizeForTitle:(NSString *)title constrainedToSize:(CGSize)constrainedToSize {
  if (_maxLineCount > 0) {
    CGSize lineSize = [@" " sizeWithFont:_titleFont];
    constrainedToSize.height = MIN(constrainedToSize.height, lineSize.height * _maxLineCount);
  }
  
  CGSize titleSize = CGSizeZero;
  
  if (title) {
    titleSize = [title sizeWithFont:_titleFont constrainedToSize:constrainedToSize lineBreakMode:UILineBreakModeTailTruncation];
    // TODO: Probably need this because sizeWithFont and draw methods produce different sizing
    titleSize.width += 2;
  }
  
  return titleSize;
}

/*!
 Sizes the secondary title given a current title size (either default or abbreviated).  The secondary title is
 sized depending on its position and such that both the title and secondary title fit within a given size constraint.
 */
- (void)_sizeSecondaryTitleWithCurrentTitleSize:(CGSize)titleSize constrainedToSize:(CGSize)constrainedToSize {
  _secondaryTitleSize = CGSizeZero;
  if (_secondaryTitle) {
    UIFont *secondaryTitleFont = _secondaryTitleFont ? _secondaryTitleFont : _titleFont;
    if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionDefault || _secondaryTitlePosition == YKUIButtonSecondaryTitlePositionRightAlign) {
      constrainedToSize.width -= roundf(titleSize.width);
      _secondaryTitleSize = [_secondaryTitle sizeWithFont:secondaryTitleFont constrainedToSize:constrainedToSize lineBreakMode:UILineBreakModeTailTruncation];
    } else if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionBottom) {
      constrainedToSize.height -= roundf(titleSize.height);
      if (_secondaryTitleMaxLineCount > 0) {
        CGSize lineSize = [@" " sizeWithFont:secondaryTitleFont];
        constrainedToSize.height = MIN(constrainedToSize.height, lineSize.height * _secondaryTitleMaxLineCount);
      }
      _secondaryTitleSize = [_secondaryTitle sizeWithFont:secondaryTitleFont constrainedToSize:constrainedToSize lineBreakMode:UILineBreakModeTailTruncation];
    }
  }
}

- (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size {
  if (_contentView) {
    CGFloat y = _insets.top;
    
    // TODO: UILabel sizeToFit with 0 height will not work? Special case it?
    CGRect contentViewFrame = [layout setFrame:CGRectMake(_insets.left, y, size.width - _insets.left - _insets.right, 0) view:_contentView options:YKLayoutOptionsSizeToFit|YKLayoutOptionsVariableWidth];
    y += contentViewFrame.size.height;
    return CGSizeMake(size.width, y + _insets.bottom);
  }
  
  CGFloat y = 0;
  
  y += _insets.top;
  UIEdgeInsets titleInsets = [self _titleInsets];
  y += titleInsets.top;
  
  // If the title is nil, but _titleSize hasn't been updated yet
  // Happens when the title gets changed from non-nil to nil.
  if (!YKCGSizeIsZero(_titleSize) && !_title) {
    _titleSize = CGSizeZero;
  } else if (_title) {
    CGSize constrainedToSize = size;
    // Subtract insets
    constrainedToSize.width -= (titleInsets.left + _insets.left);
    CGFloat rightInset = (titleInsets.right + _insets.right);
    // Ensure the title doesn't display over the accessory image if present
    if (_accessoryImage) {
      rightInset = MAX(rightInset, _accessoryImage.size.width + kAccessoryOffsetFromRight);
    }
    constrainedToSize.width -= rightInset;
    
    // Subtract icon width
    CGSize iconSize = _iconImageSize;
    if (_iconImageView.image && YKCGSizeIsZero(iconSize)) {
      iconSize = _iconImageView.image.size;
      iconSize.width += 2; // TODO(gabe): Set configurable
    }
    if (_iconPosition == YKUIButtonIconPositionLeft) {
      constrainedToSize.width -= iconSize.width;
    }
    
    if (_activityIndicatorView && _activityIndicatorView.isAnimating) {
      constrainedToSize.width -= _activityIndicatorView.frame.size.width;
    }
    
    if (constrainedToSize.height == 0) {
      constrainedToSize.height = 9999;
    }
    
    // Assume using the full title
    _titleSize = [self _sizeForTitle:_title constrainedToSize:constrainedToSize];
    self.displayedTitle = _title;
    // Check if we need to use abbreviated title
    if (_abbreviatedTitle) {
      CGSize unconstrainedTitleSize = [_title sizeWithFont:_titleFont];
      if (unconstrainedTitleSize.width > _titleSize.width) {
        _titleSize = [self _sizeForTitle:_abbreviatedTitle constrainedToSize:constrainedToSize];
        self.displayedTitle = _abbreviatedTitle;
      }
    }
    
    // Size the secondary title
    [self _sizeSecondaryTitleWithCurrentTitleSize:_titleSize constrainedToSize:constrainedToSize];
    
    // Display the activity indicator if the title is hidden
    if (_activityIndicatorView) {
      if (_titleHidden) {
        CGPoint p = YKCGPointToCenter(_activityIndicatorView.frame.size, size);
        [layout setOrigin:p view:_activityIndicatorView];
      } else {
        CGPoint p = YKCGPointToCenter(_titleSize, size);
        p.x -= _activityIndicatorView.frame.size.width + 4;
        [layout setOrigin:p view:_activityIndicatorView];
      }
    }
    
    y += _titleSize.height;
    if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionBottom) {
      y += _secondaryTitleSize.height;
    }
  }
  
  y += titleInsets.bottom;
  y += _insets.bottom;
  
  return CGSizeMake(size.width, y);
}

- (void)setEnabled:(BOOL)enabled {
  [super setEnabled:enabled];
  if (_disabledAlpha == 1.0) return;
  self.alpha = (!enabled ? _disabledAlpha : 1.0);
}

- (UIEdgeInsets)_titleInsets {
  UIEdgeInsets titleInsets = _titleInsets;
  if (_borderStyle == YKUIBorderStyleRoundedBack) {
    titleInsets.left += 4;
  }
  return titleInsets;
}

- (CGSize)sizeThatFitsTitle:(CGSize)size minWidth:(CGFloat)minWidth {
  CGSize sizeThatFitsTitle = [self sizeThatFitsTitle:size];
  if (sizeThatFitsTitle.width < minWidth) sizeThatFitsTitle.width = minWidth;
  return sizeThatFitsTitle;
}

- (CGSize)sizeThatFitsTitle:(CGSize)size {
  CGSize titleSize = [self _sizeForTitle:_title constrainedToSize:size];
  CGSize accessoryImageSize = CGSizeZero;
  if (_accessoryImage) {
    accessoryImageSize = _accessoryImage.size;
    accessoryImageSize.width += 10;
  }
  UIEdgeInsets titleInsets = [self _titleInsets];
  return CGSizeMake(titleSize.width + _insets.left + _insets.right + titleInsets.left + titleInsets.right + accessoryImageSize.width, titleSize.height + titleInsets.top + titleInsets.bottom + _insets.top + _insets.bottom);
}

- (CGSize)sizeThatFitsTitleAndIcon:(CGSize)size {
  CGSize titleSize = [self sizeThatFitsTitle:size];
  CGSize iconSize = _iconImageSize;
  if (_iconImageView.image && YKCGSizeIsZero(iconSize)) {
    iconSize = _iconImageView.image.size;
  }
  return CGSizeMake(titleSize.width + iconSize.width, titleSize.height + iconSize.height);
}

- (void)setHighlighted:(BOOL)highlighted {
  for (UIView *view in [self subviews]) {
    if ([view respondsToSelector:@selector(setHighlighted:)]) {
      [(id)view setHighlighted:highlighted];
    }
  }
  [super setHighlighted:highlighted];
}

- (void)didChangeValueForKey:(NSString *)key {
  [super didChangeValueForKey:key];
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets {
  _titleInsets = titleInsets;
  [self didChangeValueForKey:@"titleInsets"];
}

- (void)setTitleFont:(UIFont *)titleFont {
  [titleFont retain];
  [_titleFont release];
  _titleFont = titleFont;
  [self didChangeValueForKey:@"titleFont"];
}

- (void)setTitle:(NSString *)title {
  [title retain];
  [_title release];
  _title = title;
  [self didChangeValueForKey:@"title"];
}

- (void)setSecondaryTitle:(NSString *)secondaryTitle {
  [secondaryTitle retain];
  [_secondaryTitle release];
  _secondaryTitle = secondaryTitle;
  [self didChangeValueForKey:@"secondaryTitle"];
}

- (void)setTitleHidden:(BOOL)titleHidden {
  _titleHidden = titleHidden;
  [self didChangeValueForKey:@"titleHidden"];
}

- (void)setContentView:(UIView *)contentView {
  [contentView retain];
  [contentView removeFromSuperview];
  [_contentView removeFromSuperview];
  [_contentView release];
  _contentView = contentView;
  [self addSubview:_contentView];
  [self didChangeValueForKey:@"contentView"];
}

- (void)setColor:(UIColor *)color {
  [color retain];
  [_color release];
  _color = color;
  // Set shading type to none if a color is set
  if (_shadingType == YKUIShadingTypeUnknown) {
    _shadingType = YKUIShadingTypeNone;
  }
  [self didChangeValueForKey:@"color"];
}

- (void)_cornerRadiusChanged {
  if (_borderStyle == YKUIBorderStyleNone && (_cornerRadius > 0 || _cornerRadiusRatio > 0)) {
    _borderStyle = YKUIBorderStyleRounded;
    [self didChangeValueForKey:@"borderStyle"];
  }
  [self didChangeValueForKey:@"cornerRadius"];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self _cornerRadiusChanged];
}

- (void)setCornerRadiusRatio:(CGFloat)cornerRadiusRatio {
  _cornerRadiusRatio = cornerRadiusRatio;
  [self didChangeValueForKey:@"cornerRadiusRatio"];
  [self _cornerRadiusChanged];
}

+ (YKUIButton *)button {
  return [[[YKUIButton alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)sizeToFitWithMinimumSize:(CGSize)minSize {
  CGSize size = [self sizeThatFits:minSize];
  if (size.width < minSize.width) size.width = minSize.width;
  if (size.height < minSize.height) size.height = minSize.height;
  self.frame = YKCGRectSetSize(self.frame, size);
}

- (void)setBorderStyle:(YKUIBorderStyle)borderStyle {
  _borderStyle = borderStyle;
  [self didChangeValueForKey:@"borderStyle"];
}

- (void)setBorderStyle:(YKUIBorderStyle)borderStyle color:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)cornerRadius {
  self.borderStyle = borderStyle;
  self.borderColor = color;
  self.borderWidth = width;
  self.cornerRadius = cornerRadius;
}

- (void)setIconImage:(UIImage *)iconImage {
  [_iconImageView release];
  _iconImageView = [[YKUIImageView alloc] initWithImage:iconImage];
  _iconImageView.contentMode = UIViewContentModeScaleToFill;
  _iconImageView.backgroundColor = [UIColor clearColor];
}

- (UIImage *)iconImage {
  return _iconImageView.image;
}

- (UIColor *)textColorForState:(UIControlState)state {
  
  BOOL isSelected = self.isSelected;
  BOOL isHighlighted = (self.isHighlighted && self.userInteractionEnabled);
  BOOL isDisabled = !self.isEnabled;
  
  if (_selectedTitleColor && isSelected) {
    return _selectedTitleColor;
  } else if (_highlightedTitleColor && isHighlighted) {
    return _highlightedTitleColor;
  } else if (_disabledTitleColor && isDisabled) {
    return _disabledTitleColor;
  } else if (_titleColor) {
    return _titleColor;
  } else {
    return [UIColor blackColor];
  }
}

- (UIActivityIndicatorView *)activityIndicatorView {
  if (!_activityIndicatorView) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

- (void)setActivityIndicatorAnimating:(BOOL)animating {
  UIActivityIndicatorView *activityIndicatorView = [self activityIndicatorView];
  if (animating) [activityIndicatorView startAnimating];
  else [activityIndicatorView stopAnimating];
  self.userInteractionEnabled = !animating;
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (BOOL)isAnimating {
  return [_activityIndicatorView isAnimating];
}

- (void)setNeedsDisplay {
  [super setNeedsDisplay];
  [_contentView setNeedsDisplay];
}

- (void)drawInRect:(CGRect)rect {
  // Force layout if we never have
  if (YKCGSizeIsZero(_titleSize)) [self layoutView];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  UIControlState state = self.state;
  CGRect bounds = rect;
  bounds = UIEdgeInsetsInsetRect(bounds, _margin);
  CGSize size = bounds.size;
  
  size.height -= _insets.top + _insets.bottom;
  
  BOOL isHighlighted = (self.isHighlighted && self.userInteractionEnabled && self.isHighlightedEnabled);
  BOOL isSelected = self.isSelected;
  BOOL isDisabled = !self.isEnabled;
  
  YKUIShadingType shadingType = _shadingType;
  UIColor *color = _color;
  UIColor *color2 = _color2;
  UIColor *color3 = _color3;
  UIColor *color4 = _color4;
  UIColor *borderColor = _borderColor;
  
  UIImage *image = _image;
  
  UIColor *borderShadowColor = _borderShadowColor;
  CGFloat borderShadowBlur = _borderShadowBlur;
  
  CGFloat cornerRadius = _cornerRadius;
  if (_cornerRadiusRatio > 0) {
    cornerRadius = roundf(bounds.size.height/2.0f) * _cornerRadiusRatio;
  }
  
  UIColor *titleShadowColor = _titleShadowColor;
  CGSize titleShadowOffset = _titleShadowOffset;
  UIImage *icon = _iconImageView.image;
  UIImage *accessoryImage = _accessoryImage;
  
  if (isDisabled) {
    if (_disabledShadingType != YKUIShadingTypeUnknown) shadingType = _disabledShadingType;
    if (_disabledColor) color = _disabledColor;
    if (_disabledColor2) color2 = _disabledColor2;
    if (_disabledBorderColor) borderColor = _disabledBorderColor;
    if (_disabledImage) image = _disabledImage;
    if (_disabledIconImage) icon = _disabledIconImage;
    if (_disabledTitleShadowColor) titleShadowColor = _disabledTitleShadowColor;
  } else if (isHighlighted) {
    if (_highlightedShadingType != YKUIShadingTypeUnknown) shadingType = _highlightedShadingType;
    if (_highlightedColor) color = _highlightedColor;
    if (_highlightedColor2) color2 = _highlightedColor2;
    if (_highlightedImage) image = _highlightedImage;
    if (_highlightedBorderColor) borderColor = _highlightedBorderColor;
    if (_highlightedBorderShadowColor) borderShadowColor = _highlightedBorderShadowColor;
    if (_highlightedBorderShadowBlur) borderShadowBlur = _highlightedBorderShadowBlur;
    if (_highlightedTitleShadowColor) titleShadowColor = _highlightedTitleShadowColor;
    if (!CGSizeEqualToSize(_highlightedTitleShadowOffset, CGSizeZero)) titleShadowOffset = _highlightedTitleShadowOffset;
    if (_highlightedIconImage) icon = _highlightedIconImage;
    if (_highlightedAccessoryImage) accessoryImage = _highlightedAccessoryImage;
  } else if (isSelected) {
    // Set from selected properties; Fall back to highlighted properties
    if (_selectedShadingType != YKUIShadingTypeUnknown) shadingType = _selectedShadingType;
    else if (_highlightedShadingType != YKUIShadingTypeUnknown) shadingType = _highlightedShadingType;
    if (_selectedColor) color = _selectedColor;
    else if (_highlightedColor) color = _highlightedColor;
    if (_selectedColor2) color2 = _selectedColor2;
    else if (_highlightedColor2) color2 = _highlightedColor2;
    if (_highlightedImage) image = _highlightedImage;
    if (_selectedBorderShadowColor) borderShadowColor = _selectedBorderShadowColor;
    if (_selectedBorderShadowBlur) borderShadowBlur = _selectedBorderShadowBlur;
    if (_selectedIconImage) icon = _selectedIconImage;
    if (_selectedTitleShadowColor) titleShadowColor = _selectedTitleShadowColor;
    else if (_highlightedTitleShadowColor) titleShadowColor = _highlightedTitleShadowColor;
    if (!CGSizeEqualToSize(_selectedTitleShadowOffset, CGSizeZero)) titleShadowOffset = _selectedTitleShadowOffset;
    else if (!CGSizeEqualToSize(_highlightedTitleShadowOffset, CGSizeZero)) titleShadowOffset = _highlightedTitleShadowOffset;
  }
  
  // Set a sensible default
  if (borderShadowColor && borderShadowBlur == 0) borderShadowBlur = 3;
  
  UIColor *fillColor = color;
  
  CGFloat borderWidth = _borderWidth;
  
  // Clip for border styles that support it (that form a cohesive path)
  BOOL clip = (_borderStyle != YKUIBorderStyleTopOnly && _borderStyle != YKUIBorderStyleBottomOnly && _borderStyle != YKUIBorderStyleTopBottom && _borderStyle != YKUIBorderStyleNone && _borderStyle != YKUIBorderStyleNormal);
  
  if (color && shadingType != YKUIShadingTypeNone) {
    if (clip) {
      CGContextSaveGState(context);
    }
    
    YKCGContextAddStyledRect(context, bounds, _borderStyle, borderWidth, cornerRadius);
    if (clip) {
      CGContextClip(context);
    }
    
    YKCGContextDrawShading(context, color.CGColor, color2.CGColor, color3.CGColor, color4.CGColor, bounds.origin, CGPointMake(bounds.origin.x, CGRectGetMaxY(bounds)), shadingType, NO, NO);
    fillColor = nil;
    
    if (clip) {
      CGContextRestoreGState(context);
    }
  }
  
  if (_borderWidth > 0 || cornerRadius > 0) {
    if (borderShadowColor) {
      CGContextSaveGState(context);
      // Need to clip without border width adjustment
      if (clip) {
        YKCGContextAddStyledRect(context, bounds, _borderStyle, 0, cornerRadius);
        CGContextClip(context);
      }
      
      YKCGContextDrawBorderWithShadow(context, bounds, _borderStyle, fillColor.CGColor, borderColor.CGColor, borderWidth, cornerRadius, borderShadowColor.CGColor, borderShadowBlur, NO);
      CGContextRestoreGState(context);
    } else {
      YKCGContextDrawBorder(context, bounds, _borderStyle, fillColor.CGColor, borderColor.CGColor, borderWidth, cornerRadius);
    }
  } else if (fillColor) {
    [fillColor setFill];
    CGContextFillRect(context, bounds);
  }
  
  if (image) {
    [image drawInRect:bounds];
  }
  
  UIColor *textColor = [self textColorForState:state];
  
  UIFont *font = self.titleFont;
  
  CGSize totalTitleSize = _titleSize;
  if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionBottom) {
    totalTitleSize.height += _secondaryTitleSize.height;
  } else if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionDefault || _secondaryTitlePosition == YKUIButtonSecondaryTitlePositionRightAlign) {
    totalTitleSize.width += _secondaryTitleSize.width;
  }
  CGFloat y = bounds.origin.y + roundf(YKCGPointToCenter(totalTitleSize, size).y) + _insets.top;
  
  BOOL showIcon = (icon != nil && !_iconImageView.hidden);
  CGSize iconSize = _iconImageSize;
  if (icon && YKCGSizeIsZero(iconSize)) {
    iconSize = icon.size;
  }
  
  UIEdgeInsets titleInsets = [self _titleInsets];
  if (!_titleHidden) {
    CGFloat lineWidth = totalTitleSize.width + titleInsets.left + titleInsets.right;
    if (showIcon && _iconPosition == YKUIButtonIconPositionLeft) lineWidth += iconSize.width;
    CGFloat x = bounds.origin.x;
    
    if (_titleAlignment == UITextAlignmentCenter) {
      CGFloat width = size.width - _insets.left - _insets.right;
      if (accessoryImage) width -= accessoryImage.size.width;
      x += roundf(width/2.0 - lineWidth/2.0) + _insets.left;
    } else {
      x += _insets.left;
    }
    if (x < 0) x = 0;
    
    if (showIcon) {
      if (_iconShadowColor) CGContextSetShadowWithColor(context, CGSizeZero, 5.0, _iconShadowColor.CGColor);
      switch (_iconPosition) {
        case YKUIButtonIconPositionLeft: {
          CGPoint iconTop = YKCGPointToCenter(iconSize, size);
          iconTop.x = x;
          iconTop.y += bounds.origin.y + _insets.top;
          [_iconImageView drawInRect:CGRectMake(iconTop.x, iconTop.y, iconSize.width, iconSize.height)];
          x += iconSize.width;
          break;
        }
        case YKUIButtonIconPositionTop: {
          CGPoint iconTop = YKCGPointToCenter(iconSize, size);
          [_iconImageView drawInRect:CGRectMake(iconTop.x, _insets.top, iconSize.width, iconSize.height)];
          y = _insets.top + iconSize.height + titleInsets.top;
          break;
        }
        case YKUIButtonIconPositionCenter: {
          CGPoint iconTop = YKCGPointToCenter(iconSize, CGSizeMake(size.width, size.height - _titleSize.height));
          if (_iconOrigin.x != CGFLOAT_MAX) iconTop.x = _iconOrigin.x;
          if (_iconOrigin.y != CGFLOAT_MAX) iconTop.y = _iconOrigin.y;
          [_iconImageView drawInRect:CGRectMake(iconTop.x, iconTop.y + _insets.top, iconSize.width, iconSize.height)];
          y = iconTop.y + _insets.top + iconSize.height + titleInsets.top;
          break;
        }
      }
      CGContextSetShadowWithColor(context, CGSizeZero, 0.0, NULL);
      showIcon = NO;
    } else if (!YKCGSizeIsZero(iconSize)) {
      if (_iconPosition == YKUIButtonIconPositionLeft) {
        x += iconSize.width;
      }
    }
    
    [textColor setFill];
    CGContextSetShadowWithColor(context, titleShadowOffset, 0.0, titleShadowColor.CGColor);
    
    x += titleInsets.left;
    if (y < _insets.top) y = _insets.top + titleInsets.top;
    
    // Draw title. If we have a secondary title, we'll need to adjust for alignment.
    if (!_secondaryTitle) {
      [_displayedTitle drawInRect:CGRectMake(x, y, _titleSize.width, _titleSize.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
    } else if (_secondaryTitle) {
      CGSize titleSizeAdjusted = [_displayedTitle sizeWithFont:_titleFont constrainedToSize:_titleSize lineBreakMode:UILineBreakModeTailTruncation];
      titleSizeAdjusted = [_displayedTitle drawInRect:CGRectMake(x, y, titleSizeAdjusted.width, titleSizeAdjusted.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
      if (_secondaryTitleColor) [_secondaryTitleColor set];
      if (_secondaryTitleFont) font = _secondaryTitleFont;
      if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionDefault) {
        x += titleSizeAdjusted.width;
        CGFloat secondaryTitleWidth = size.width - x - _insets.right - titleInsets.right;
        CGSize secondaryTitleSize = [_secondaryTitle sizeWithFont:font forWidth:secondaryTitleWidth lineBreakMode:NSLineBreakByTruncatingTail];
        [_secondaryTitle drawInRect:CGRectMake(x, y, secondaryTitleSize.width, secondaryTitleSize.height) withFont:font lineBreakMode:NSLineBreakByTruncatingTail];
      } else if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionRightAlign) {
        x += titleSizeAdjusted.width;
        [_secondaryTitle drawInRect:CGRectMake(x, y, size.width - x - _insets.right - titleInsets.right, size.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
      } else if (_secondaryTitlePosition == YKUIButtonSecondaryTitlePositionBottom) {
        x = _insets.left + titleInsets.left + iconSize.width;
        y += titleSizeAdjusted.height + titleInsets.bottom;
        if (_titleAlignment == UITextAlignmentCenter) {
          // Center text within the maximum possible secondary title size (button size minus horizontal insets minus icon width)
          CGSize centerSize = CGSizeMake(size.width - x - _insets.right - _titleInsets.right, _secondaryTitleSize.height);
          [_secondaryTitle drawInRect:CGRectMake(x, y, centerSize.width, centerSize.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
        } else {
          CGSize secondaryTitleSizeAdjusted = [_secondaryTitle sizeWithFont:font constrainedToSize:_secondaryTitleSize lineBreakMode:UILineBreakModeTailTruncation];
          [_secondaryTitle drawInRect:CGRectMake(x, y, secondaryTitleSizeAdjusted.width, secondaryTitleSizeAdjusted.height) withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:_titleAlignment];
        }
      }
    }
  }
  
  if (accessoryImage) {
    [accessoryImage drawAtPoint:YKCGPointToRight(accessoryImage.size, CGSizeMake(size.width - kAccessoryOffsetFromRight, bounds.size.height))];
  }
  
  if (showIcon) {
    if (_iconShadowColor) CGContextSetShadowWithColor(context, CGSizeZero, 3.0, _iconShadowColor.CGColor);
    [_iconImageView drawInRect:YKCGRectToCenterInRect(iconSize, bounds)];
    CGContextSetShadowWithColor(context, CGSizeZero, 0.0, NULL);
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawInRect:self.bounds];
}

@end
