/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 fgengine(Alexander Trifonov)  */
/*                                                  */
/* Permission is hereby granted, free of charge,    */
/* to any person obtaining a copy of this software  */
/* and associated documentation files               */
/* (the "Software"), to deal in the Software        */
/* without restriction, including without           */
/* limitation the rights to use, copy, modify,      */
/* merge, publish, distribute, sublicense,          */
/* and/or sell copies of the Software, and to       */
/* permit persons to whom the Software is furnished */
/* to do so, subject to the following conditions:   */
/*                                                  */
/* The above copyright notice and this permission   */
/* notice shall be included in all copies or        */
/* substantial portions of the Software.            */
/*                                                  */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT        */
/* WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        */
/* INCLUDING BUT NOT LIMITED TO THE WARRANTIES      */
/* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR     */
/* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   */
/* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR   */
/* ANY CLAIM, DAMAGES OR OTHER LIABILITY,           */
/* WHETHER IN AN ACTION OF CONTRACT, TORT OR        */
/* OTHERWISE, ARISING FROM, OUT OF OR IN            */
/* CONNECTION WITH THE SOFTWARE OR THE USE OR       */
/* OTHER DEALINGS IN THE SOFTWARE.                  */
/*                                                  */
/*--------------------------------------------------*/

#import "MobilyData.h"

/*--------------------------------------------------*/

@interface MobilyDataItemView : UIView< MobilyDataItemView, UIGestureRecognizerDelegate >

@property(nonatomic, readonly, strong) UILongPressGestureRecognizer* pressGestureRecognizer;
@property(nonatomic, readonly, strong) UITapGestureRecognizer* tapGestureRecognizer;

@property(nonatomic, readwrite, strong) IBOutlet UIView* rootView;
@property(nonatomic, readwrite, assign) UIOffset rootOffsetOfCenter;
@property(nonatomic, readwrite, assign) UIOffset rootMarginSize;

@property(nonatomic, readonly, strong) NSArray* orderedSubviews;

@end

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyDataItemSwipeViewStyle) {
    MobilyDataItemSwipeViewStyleStands,
    MobilyDataItemSwipeViewStyleLeaves,
    MobilyDataItemSwipeViewStylePushes
};

/*--------------------------------------------------*/

@interface MobilyDataItemSwipeView : MobilyDataItemView

@property(nonatomic, readonly, strong) UIPanGestureRecognizer* panGestureRecognizer;

@property(nonatomic, readwrite, assign) IBInspectable MobilyDataItemSwipeViewStyle swipeStyle;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeThreshold;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeVelocity;
@property(nonatomic, readwrite, assign) IBInspectable CGFloat swipeSpeed;
@property(nonatomic, readonly, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readonly, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, assign, getter=isShowedLeftSwipeView) IBInspectable BOOL showedLeftSwipeView;
@property(nonatomic, readwrite, strong) IBOutlet UIView* leftSwipeView;
@property(nonatomic, readwrite, assign) CGFloat leftSwipeOffset;
@property(nonatomic, readwrite, assign) CGFloat leftSwipeSize;

@property(nonatomic, readwrite, assign, getter=isShowedRightSwipeView) IBInspectable BOOL showedRightSwipeView;
@property(nonatomic, readwrite, strong) IBOutlet UIView* rightSwipeView;
@property(nonatomic, readwrite, assign) CGFloat rightSwipeOffset;
@property(nonatomic, readwrite, assign) CGFloat rightSwipeSize;

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated;
- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated;
- (void)hideAnySwipeViewAnimated:(BOOL)animated;

- (void)willBeganSwipe;
- (void)didBeganSwipe;
- (void)movingSwipe:(CGFloat)progress;
- (void)willEndedSwipe;
- (void)didEndedSwipe;

@end

/*--------------------------------------------------*/

extern NSString* MobilyDataItemViewPressed;

/*--------------------------------------------------*/