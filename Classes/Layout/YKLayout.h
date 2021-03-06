//
//  YKLayout.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 1/31/11.
//  Copyright 2011 Yelp. All rights reserved.
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

typedef enum {
  YKLayoutOptionsSizeToFit = 1 << 0, // Size to fit the view
  YKLayoutOptionsVariableWidth = 1 << 1,
  
  // Deprecated: Use YKLayoutOptionsVariableWidth.
  YKLayoutOptionsSizeToFitVariableWidth = 1 << 1,
  
  // Alignment
  // Center the view in the specified size (horizontal + vertical). If you use this with YKLayoutOptionsSizeToFit then the origin width is maintained.
  YKLayoutOptionsCenter = 1 << 2, 
  YKLayoutOptionsCenterVertical = 1 << 3, // Center vertically
  YKLayoutOptionsRightAlign = 1 << 4, // After sizing, aligns the view with the right of the passed in rect

  // Whether sizeToFit is constrained to the width specified.
  // For example UILabel sizeToFit may return a larger width than was specified,
  // and this will constrain it.
  YKLayoutOptionsSizeToFitConstraintWidth = 1 << 8,
  
  // Whether the size specified is the default. Using this option will
  // use the specified width and/or height (if not 0) when the sizeToFit 
  // returns a 0 width.
  // This is useful for an image view that has to load its data and may 
  // initially return 0 for sizeThatFits.
  // This option is only available when using 
  YKLayoutOptionsSizeToFitDefaultSize = 1 << 9,

  // Whether sizeToFit is constrained to the size specified.
  // This is useful for an image view that may need to be constrained to a max
  // size, but still maintain its aspect ratio.
  YKLayoutOptionsSizeToFitConstrainSizeMaintainAspectRatio = 1 << 10,

  // Whether width specified will be set as the width. Using this option will
  // use the specified width regardless of the width returned by sizeThatFits.
  YKLayoutOptionsFixedWidth = 1 << 11,
} YKLayoutOptions;

@protocol YKLayoutView;
/*!
 Informal protocol for views laid out by YKLayout.
 */
@protocol YKLView <YKLayoutView>

@property (assign, nonatomic) CGRect frame;

- (void)setNeedsLayout;

@end


@protocol YKLayout <NSObject>

/*!
 Layout the subviews.
 
 @param size Size to layout in
 */
- (CGSize)layoutSubviews:(CGSize)size;

/*!
 Size that fits.
 
 @param size Size to layout in; Should have a width specified.
 @result The size needed to display the view
 */
- (CGSize)sizeThatFits:(CGSize)size;

/*!
 Set frame for the (sub)view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view;

/*!
 Set frame for the (sub)view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @param needsLayout If YES, calls setNeedsLayout on view.
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view needsLayout:(BOOL)needsLayout;

/*!
 Set the (sub)view frame, then size to fit the view.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @param sizeToFit Size to fit
 @result The view frame. 
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view sizeToFit:(BOOL)sizeToFit;

/*!
 Set the (sub)view frame.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @param options Options for setFrame; See YKLayoutOptions for more info
 @result The view frame. 
 */
- (CGRect)setFrame:(CGRect)frame view:(id)view options:(YKLayoutOptions)options;

/*!
 Set the (sub)view frame.
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param frame Frame
 @param inRect Rect to optionally position in for YKLayoutOptionsCenter, YKLayoutOptionsCenterVertical, YKLayoutOptionsRightAlign, etc.
 @param view View
 @param options Options for setFrame; See YKLayoutOptions for more info
 @result The view frame.
 */
- (CGRect)setFrame:(CGRect)frame inRect:(CGRect)inRect view:(id)view options:(YKLayoutOptions)options;

/*!
 Set origin for the (sub)view (for views with fixed sizes).
 If we are calculating sizeThatFits, this doesn't actually set the views frame.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param origin Origin
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @result The view frame. 
 */
- (CGRect)setOrigin:(CGPoint)origin frame:(CGRect)frame view:(id)view;

/*!
 @deprecated Use setOrigin:frame:view:
 */
- (CGRect)setOrigin:(CGPoint)origin view:(id)view;

/*!
 Set origin, x position.
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param x X position
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @result The view frame. 
 */
- (CGRect)setX:(CGFloat)x frame:(CGRect)frame view:(id)view;

/*!
 Set origin, y position.
 
 Use this value instead of view.frame since the views frame might not have been set.
 
 @param y Y position
 @param frame Frame
 @param view View should conform to YKLView informal protocol.
 @result The view frame. 
 */
- (CGRect)setY:(CGFloat)y frame:(CGRect)frame view:(id)view;

/*!
 @deprecated Use setY:frame:view:
 */
- (CGRect)setY:(CGFloat)y view:(UIView *)view;

/*!
 If layout is required. Otherwise cached value may be returned.
 This should be called when a views data changes.
 */
- (void)setNeedsLayout;

/*!
 For subclasses, in rare cases, if they need to know whether the layout will
 be applied or not via setFrame:view:
 
 @result YES if we are only sizing, NO if we are setting frames
 */
- (BOOL)isSizing;

@end


/*
 UIViews can implement this protocol, to enable custom layouts.
 */
@protocol YKLayoutView <NSObject>

/*!
 Layout object belonging to the class implementing this protocol.
 */
@property (retain, nonatomic) id <YKLayout>layout;

@optional

/*!
 Layout or size the current view, with the specified size as a hint.
 Return the size used. The returned size.width should match the width that was
 passed in.

 You should never setFrame on subviews in this method. Instead use the methods
 in layout in order to setFrame, and use what those methods return to layout other
 subviews. This is because setFrame calls are no-ops when the view is only sizing.

 This method must be implemented if self.layout is not nil.

 @param layout Layout
 @param size Size to layout in
 */
- (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size;

@end

/*!
 Subviews added to YKLayout need to implement these methods.
 */
@protocol YKLayoutDrawable <NSObject>

/*!
 @result Size of drawable
 */
- (CGRect)frame;

/*!
 @result Whether drawable is hidden
 */
- (BOOL)isHidden;

/*!
 @result Set needs layout
 */
- (void)layoutIfNeeded;

/*!
 @result Draw the drawable
 */
- (void)drawInRect:(CGRect)rect;

@end


@class YKLayoutStats;


/*!
 YKLayout is a way to size and layout views without having to implement layoutSubview and 
 sizeToFit separately.
 
 It also provides a basic cache to avoid layout when the view is unchanged.
 
 YKLayout calculates a size that best fits the receiver’s subviews,
 without altering the subviews frames, or affecting layoutSubviews call hierarchy.
 
 Instead of defining both sizeThatFits: and layoutSubviews, you define a single method called:
 
      - (CGSize)layout:(id<YKLayout>)layout size:(CGSize)size;
 
 Then in this method you use the layout instance to set the subview frames (if sizing).
 
 This prevents your code from altering subviews when you are sizing (for sizeThatFits:).
 
 For example, 
 
      CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:YKLayoutOptionsSizeToFit];
      // titleLabelFrame may have a different width and will have a valid height
 
 You can combine YKLayoutOptionsSizeToFit and YKLayoutOptionsCenter to have it be centered with a variable height. 
 For example,
 
      CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:YKLayoutOptionsSizeToFit|YKLayoutOptionsCenter];
      // titleLabelFrame may have a different width and will have a valid height and will have an x position so it is centered
 
 You can also combine YKLayoutOptionsSizeToFit with YKLayoutOptionsConstraintWidth 
 to make sure the width isn't set larger than expected. For example, 
 
      CGRect titleLabelFrame = [layout setFrame:CGRectMake(x, y, 400, 0) view:_titleLabel options:YKLayoutOptionsSizeToFit|YKLayoutOptionsConstraintWidth];
      // titleLabelFrame may have a different width but it won't be larger than 400
 
 You can combine YKLayoutOptionsSizeToFit, YKLayoutOptionsConstraintWidth, and YKLayoutOptionsDefaultWidth to make sure
 a view sizes to fit with max and default width (when 0).  
 */
@interface YKLayout : NSObject <YKLayout> { 
  
  UIView *_view; // weak
  
  BOOL _needsLayout;
  BOOL _needsSizing;
  CGSize _cachedSize;
  CGSize _cachedLayoutSize;
  NSMutableArray *_accessibleElements;
  
  BOOL _sizing;
  
  NSMutableArray *_subviews; // For manual subview handling
  
  CGSize _sizeThatFits;
}

@property (readonly, retain, nonatomic) NSArray *accessibleElements;
@property (readonly, nonatomic, getter=isSizing) BOOL sizing;

/*!
 Set a custon/fixed size that fits.
 Override the size that is returned by sizeThatFits:(CGSize)size.
 Defaults to CGSizeZero, which is unset.
 If height is not set (is 0), then we will use this size value for sizeThatFits:.
 */
@property (assign, nonatomic) CGSize sizeThatFits;

/*!
 Create layout for view.

 @param view View for layout (weak reference).
 */
- (id)initWithView:(UIView *)view;

/*!
 Default layout.
 @param view View for layout (weak reference).
 @result Layout
 */
+ (YKLayout *)layoutForView:(UIView *)view;

/*!
 Add subview.
 
 Call YKLayout#drawSubviews in the superview drawRect: method to
 draw YKLayout managed subviews.
 
 Subviews managed by the layout don't automatically handle re-display,
 or touches. Layout managed subviews are intended for simple views
 or views in table view cells that need better scrolling performance.
 For resizing you may need to adjust the contentMode.

 @param view View to add. Must respond to:
      drawInRect:(CGRect)rect
      (CGRect)frame
 */
- (void)addSubview:(id)view;

/*!
 Remove subview.

 @param view View to remove
 */
- (void)removeSubview:(id)view;

/*!
 Draw subviews that were added.
 Each view is drawn at their view frame.

 @param rect Offset to draw in; TODO(gabe): Use rect.size?
 */
- (void)drawSubviewsInRect:(CGRect)rect;

/*!
 Remove view reference and all subviews.
 */
- (void)clear;

/*!
 Get debug stats.
 @param view View
 */
+ (YKLayoutStats *)statsForView:(UIView *)view;

/*!
 Assert layout parameters are correct.
 */
void YKLayoutAssert(UIView *view, id<YKLayout> layout);

@end

/*
 Layout stats.
 */
@interface YKLayoutStats : NSObject {
  NSMutableArray *_log;
  
@public
  NSTimeInterval _timing;
  NSInteger _createCount;
  NSInteger _layoutCount;
  NSInteger _cacheCount;
}

@property (readonly, nonatomic) NSMutableArray *log;

@end
