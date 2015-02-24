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

#import "MobilyDataItemView.h"

/*--------------------------------------------------*/

typedef NS_ENUM(NSUInteger, MobilyTableSwipeCellDirection) {
    MobilyTableSwipeCellDirectionUnknown,
    MobilyTableSwipeCellDirectionLeft,
    MobilyTableSwipeCellDirectionRight
};

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@interface MobilyDataItemSwipeView ()

@property(nonatomic, readwrite, strong) UIPanGestureRecognizer* panGestureRecognizer;
@property(nonatomic, readwrite, getter=isSwipeDragging) BOOL swipeDragging;
@property(nonatomic, readwrite, getter=isSwipeDecelerating) BOOL swipeDecelerating;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewOffsetX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintLeftSwipeViewHeight;

@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewOffsetX;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewCenterY;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewWidth;
@property(nonatomic, readwrite, strong) NSLayoutConstraint* constraintRightSwipeViewHeight;

@property(nonatomic, readwrite, assign) CGFloat panSwipeLastOffset;
@property(nonatomic, readwrite, assign) CGFloat panSwipeLastVelocity;
@property(nonatomic, readwrite, assign) CGFloat panSwipeProgress;
@property(nonatomic, readwrite, assign) CGFloat panSwipeLeftWidth;
@property(nonatomic, readwrite, assign) CGFloat panSwipeRightWidth;
@property(nonatomic, readwrite, assign) MobilyTableSwipeCellDirection panSwipeDirection;

- (UIOffset)rootOffsetOfCenterBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)leftOffsetBySwipeProgress:(CGFloat)swipeProgress;
- (CGFloat)rightOffsetBySwipeProgress:(CGFloat)swipeProgress;

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe;

- (void)handlerPanGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer;

@end

/*--------------------------------------------------*/
#pragma mark -
/*--------------------------------------------------*/

@implementation MobilyDataItemSwipeView

#pragma mark Init / Free

- (void)setup {
    [super setup];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlerPanGestureRecognizer:)];
    
    self.swipeStyle = MobilyDataItemSwipeViewStyleLeaves;
    self.swipeThreshold = 2.0f;
    self.swipeSpeed = 1050.0f;
    self.swipeVelocity = 570.0f;
    self.leftSwipeSize = -1.0f;
    self.rightSwipeSize = -1.0f;
    self.rootOffsetOfCenter = [self rootOffsetOfCenterBySwipeProgress:0.0f];
    self.leftSwipeOffset = [self leftOffsetBySwipeProgress:0.0f];
    self.rightSwipeOffset = [self rightOffsetBySwipeProgress:0.0f];
}

- (void)dealloc {
    self.rootView = nil;
    self.panGestureRecognizer = nil;
    self.constraintLeftSwipeViewOffsetX = nil;
    self.constraintLeftSwipeViewCenterY = nil;
    self.constraintLeftSwipeViewWidth = nil;
    self.constraintLeftSwipeViewHeight = nil;
    self.leftSwipeView = nil;
    self.constraintRightSwipeViewOffsetX = nil;
    self.constraintRightSwipeViewCenterY = nil;
    self.constraintRightSwipeViewWidth = nil;
    self.constraintRightSwipeViewHeight = nil;
    self.rightSwipeView = nil;
}

#pragma mark UIView

- (void)updateConstraints {
    if(_leftSwipeView != nil) {
        if(_leftSwipeSize >= 0.0f) {
            if(_constraintLeftSwipeViewWidth == nil) {
                self.constraintLeftSwipeViewWidth = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_leftSwipeSize];
            }
        } else {
            self.constraintLeftSwipeViewWidth = nil;
        }
        if(_constraintLeftSwipeViewOffsetX == nil) {
            self.constraintLeftSwipeViewOffsetX = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:_leftSwipeOffset];
        }
        if(_constraintLeftSwipeViewCenterY == nil) {
            self.constraintLeftSwipeViewCenterY = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintLeftSwipeViewHeight == nil) {
            self.constraintLeftSwipeViewHeight = [NSLayoutConstraint constraintWithItem:_leftSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintLeftSwipeViewOffsetX = nil;
        self.constraintLeftSwipeViewCenterY = nil;
        self.constraintLeftSwipeViewWidth = nil;
        self.constraintLeftSwipeViewHeight = nil;
    }
    if(_rightSwipeView != nil) {
        if(_rightSwipeSize >= 0.0f) {
            if(_constraintRightSwipeViewWidth == nil) {
                self.constraintRightSwipeViewWidth = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:_rightSwipeSize];
            }
        } else {
            self.constraintRightSwipeViewWidth = nil;
        }
        if(_constraintRightSwipeViewOffsetX == nil) {
            self.constraintRightSwipeViewOffsetX = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:_rightSwipeOffset];
        }
        if(_constraintRightSwipeViewCenterY == nil) {
            self.constraintRightSwipeViewCenterY = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        }
        if(_constraintRightSwipeViewHeight == nil) {
            self.constraintRightSwipeViewHeight = [NSLayoutConstraint constraintWithItem:_rightSwipeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
        }
    } else {
        self.constraintRightSwipeViewOffsetX = nil;
        self.constraintRightSwipeViewCenterY = nil;
        self.constraintRightSwipeViewWidth = nil;
        self.constraintRightSwipeViewHeight = nil;
    }
    [super updateConstraints];
}

#pragma mark Property

- (NSArray*)orderedSubviews {
    NSMutableArray* result = NSMutableArray.array;
    switch(_swipeStyle) {
        case MobilyDataItemSwipeViewStyleStands: {
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            if(self.rootView != nil) {
                [result addObject:self.rootView];
            }
            break;
        }
        case MobilyDataItemSwipeViewStyleLeaves:
        case MobilyDataItemSwipeViewStylePushes: {
            if(self.rootView != nil) {
                [result addObject:self.rootView];
            }
            if(_leftSwipeView != nil) {
                [result addObject:_leftSwipeView];
            }
            if(_rightSwipeView != nil) {
                [result addObject:_rightSwipeView];
            }
            break;
        }
    }
    return result;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:NO];
    
    if(editing == NO) {
        [self hideAnySwipeViewAnimated:animated];
    }
}

- (void)setRootView:(UIView*)rootView {
    super.rootView = rootView;
    
    self.rootOffsetOfCenter = [self rootOffsetOfCenterBySwipeProgress:0.0f];
}

- (void)setPanGestureRecognizer:(UIPanGestureRecognizer*)panGestureRecognizer {
    if(_panGestureRecognizer != panGestureRecognizer) {
        if(_panGestureRecognizer != nil) {
            [self removeGestureRecognizer:_panGestureRecognizer];
        }
        _panGestureRecognizer = panGestureRecognizer;
        if(_panGestureRecognizer != nil) {
            _panGestureRecognizer.delegate = self;
            [self addGestureRecognizer:_panGestureRecognizer];
        }
    }
}

- (void)setSwipeStyle:(MobilyDataItemSwipeViewStyle)swipeStyle {
    if(_swipeStyle != swipeStyle) {
        self.constraintLeftSwipeViewOffsetX = nil;
        self.constraintLeftSwipeViewCenterY = nil;
        self.constraintLeftSwipeViewWidth = nil;
        self.constraintLeftSwipeViewHeight = nil;
        self.constraintRightSwipeViewOffsetX = nil;
        self.constraintRightSwipeViewCenterY = nil;
        self.constraintRightSwipeViewWidth = nil;
        self.constraintRightSwipeViewHeight = nil;
        _swipeStyle = swipeStyle;
        [self setSubviews:self.orderedSubviews];
        self.rootOffsetOfCenter = [self rootOffsetOfCenterBySwipeProgress:0.0f];
        self.leftSwipeOffset = [self leftOffsetBySwipeProgress:0.0f];
        self.rightSwipeOffset = [self rightOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setShowedLeftSwipeView:(BOOL)showedSwipeLeft {
    [self setShowedLeftSwipeView:showedSwipeLeft animated:NO];
}

- (void)setLeftSwipeView:(UIView*)leftSwipeView {
    if(_leftSwipeView != leftSwipeView) {
        if(_leftSwipeView != nil) {
            [_leftSwipeView removeFromSuperview];
        }
        _leftSwipeView = leftSwipeView;
        if(_leftSwipeView != nil) {
            _leftSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self setSubviews:self.orderedSubviews];
        }
        self.leftSwipeOffset = [self leftOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setConstraintLeftSwipeViewOffsetX:(NSLayoutConstraint*)constraintLeftSwipeViewOffsetX {
    if(_constraintLeftSwipeViewOffsetX != constraintLeftSwipeViewOffsetX) {
        if(_constraintLeftSwipeViewOffsetX != nil) {
            [self removeConstraint:_constraintLeftSwipeViewOffsetX];
        }
        _constraintLeftSwipeViewOffsetX = constraintLeftSwipeViewOffsetX;
        if(_constraintLeftSwipeViewOffsetX != nil) {
            [self addConstraint:_constraintLeftSwipeViewOffsetX];
        }
    }
}

- (void)setConstraintLeftSwipeViewCenterY:(NSLayoutConstraint*)constraintLeftSwipeViewCenterY {
    if(_constraintLeftSwipeViewCenterY != constraintLeftSwipeViewCenterY) {
        if(_constraintLeftSwipeViewCenterY != nil) {
            [self removeConstraint:_constraintLeftSwipeViewCenterY];
        }
        _constraintLeftSwipeViewCenterY = constraintLeftSwipeViewCenterY;
        if(_constraintLeftSwipeViewCenterY != nil) {
            [self addConstraint:_constraintLeftSwipeViewCenterY];
        }
    }
}

- (void)setConstraintLeftSwipeViewWidth:(NSLayoutConstraint*)constraintLeftSwipeViewWidth {
    if(_constraintLeftSwipeViewWidth != constraintLeftSwipeViewWidth) {
        if(_constraintLeftSwipeViewWidth != nil) {
            [self removeConstraint:_constraintLeftSwipeViewWidth];
        }
        _constraintLeftSwipeViewWidth = constraintLeftSwipeViewWidth;
        if(_constraintLeftSwipeViewWidth != nil) {
            [self addConstraint:_constraintLeftSwipeViewWidth];
        }
    }
}

- (void)setConstraintLeftSwipeViewHeight:(NSLayoutConstraint*)constraintLeftSwipeViewHeight {
    if(_constraintLeftSwipeViewHeight != constraintLeftSwipeViewHeight) {
        if(_constraintLeftSwipeViewHeight != nil) {
            [self removeConstraint:_constraintLeftSwipeViewHeight];
        }
        _constraintLeftSwipeViewHeight = constraintLeftSwipeViewHeight;
        if(_constraintLeftSwipeViewHeight != nil) {
            [self addConstraint:_constraintLeftSwipeViewHeight];
        }
    }
}

- (void)setLeftSwipeOffset:(CGFloat)leftSwipeOffset {
    if(_leftSwipeOffset != leftSwipeOffset) {
        _leftSwipeOffset = leftSwipeOffset;
        if(_constraintLeftSwipeViewOffsetX != nil) {
            _constraintLeftSwipeViewOffsetX.constant = _leftSwipeOffset;
        }
    }
}

- (void)setLeftSwipeSize:(CGFloat)leftSwipeSize {
    if(_leftSwipeSize != leftSwipeSize) {
        _leftSwipeSize = leftSwipeSize;
        if(_leftSwipeSize < 0.0f) {
            [self setNeedsUpdateConstraints];
        } else if(_constraintLeftSwipeViewWidth != nil) {
            _constraintLeftSwipeViewWidth.constant = _leftSwipeSize;
        }
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView {
    [self setShowedRightSwipeView:showedRightSwipeView animated:NO];
}

- (void)setRightSwipeView:(UIView*)rightSwipeView {
    if(_rightSwipeView != rightSwipeView) {
        if(_rightSwipeView != nil) {
            [_rightSwipeView removeFromSuperview];
        }
        _rightSwipeView = rightSwipeView;
        if(_rightSwipeView != nil) {
            _rightSwipeView.translatesAutoresizingMaskIntoConstraints = NO;
            [self setSubviews:self.orderedSubviews];
        }
        self.rightSwipeOffset = [self rightOffsetBySwipeProgress:0.0f];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setConstraintRightSwipeViewOffsetX:(NSLayoutConstraint*)constraintRightSwipeViewOffsetX {
    if(_constraintRightSwipeViewOffsetX != constraintRightSwipeViewOffsetX) {
        if(_constraintRightSwipeViewOffsetX != nil) {
            [self removeConstraint:_constraintRightSwipeViewOffsetX];
        }
        _constraintRightSwipeViewOffsetX = constraintRightSwipeViewOffsetX;
        if(_constraintRightSwipeViewOffsetX != nil) {
            [self addConstraint:_constraintRightSwipeViewOffsetX];
        }
    }
}

- (void)setConstraintRightSwipeViewCenterY:(NSLayoutConstraint*)constraintRightSwipeViewCenterY {
    if(_constraintRightSwipeViewCenterY != constraintRightSwipeViewCenterY) {
        if(_constraintRightSwipeViewCenterY != nil) {
            [self removeConstraint:_constraintRightSwipeViewCenterY];
        }
        _constraintRightSwipeViewCenterY = constraintRightSwipeViewCenterY;
        if(_constraintRightSwipeViewCenterY != nil) {
            [self addConstraint:_constraintRightSwipeViewCenterY];
        }
    }
}

- (void)setConstraintRightSwipeViewWidth:(NSLayoutConstraint*)constraintRightSwipeViewWidth {
    if(_constraintRightSwipeViewWidth != constraintRightSwipeViewWidth) {
        if(_constraintRightSwipeViewWidth != nil) {
            [self removeConstraint:_constraintRightSwipeViewWidth];
        }
        _constraintRightSwipeViewWidth = constraintRightSwipeViewWidth;
        if(_constraintRightSwipeViewWidth != nil) {
            [self addConstraint:_constraintRightSwipeViewWidth];
        }
    }
}

- (void)setConstraintRightSwipeViewHeight:(NSLayoutConstraint*)constraintRightSwipeViewHeight {
    if(_constraintRightSwipeViewHeight != constraintRightSwipeViewHeight) {
        if(_constraintRightSwipeViewHeight != nil) {
            [self removeConstraint:_constraintRightSwipeViewHeight];
        }
        _constraintRightSwipeViewHeight = constraintRightSwipeViewHeight;
        if(_constraintRightSwipeViewHeight != nil) {
            [self addConstraint:_constraintRightSwipeViewHeight];
        }
    }
}

- (void)setRightSwipeOffset:(CGFloat)rightSwipeOffset {
    if(_rightSwipeOffset != rightSwipeOffset) {
        _rightSwipeOffset = rightSwipeOffset;
        if(_constraintRightSwipeViewOffsetX != nil) {
            _constraintRightSwipeViewOffsetX.constant = _rightSwipeOffset;
        }
    }
}

- (void)setRightSwipeSize:(CGFloat)rightSwipeSize {
    if(_rightSwipeSize != rightSwipeSize) {
        _rightSwipeSize = rightSwipeSize;
        if(_rightSwipeSize < 0.0f) {
            [self setNeedsUpdateConstraints];
        } else if(_constraintRightSwipeViewWidth != nil) {
            _constraintRightSwipeViewWidth.constant = _rightSwipeSize;
        }
    }
}

#pragma mark Public

- (void)setShowedLeftSwipeView:(BOOL)showedLeftSwipeView animated:(BOOL)animated {
    if(_showedLeftSwipeView != showedLeftSwipeView) {
        _showedLeftSwipeView = showedLeftSwipeView;
        _showedRightSwipeView = NO;
        
        CGFloat needSwipeProgress = (showedLeftSwipeView == YES) ? -1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? [_leftSwipeView frameWidth] * ABS(needSwipeProgress - _panSwipeProgress) : FLT_EPSILON
                    endedSwipe:NO];
    }
}

- (void)setShowedRightSwipeView:(BOOL)showedRightSwipeView animated:(BOOL)animated {
    if(_showedRightSwipeView != showedRightSwipeView) {
        _showedRightSwipeView = showedRightSwipeView;
        _showedLeftSwipeView = NO;
        
        CGFloat needSwipeProgress = (_showedRightSwipeView == YES) ? 1.0f : 0.0f;
        [self setSwipeProgress:needSwipeProgress
                         speed:(animated == YES) ? [_rightSwipeView frameWidth] * ABS(needSwipeProgress - _panSwipeProgress) : FLT_EPSILON
                    endedSwipe:NO];
    }
}

- (void)hideAnySwipeViewAnimated:(BOOL)animated {
    [self setShowedLeftSwipeView:NO animated:NO];
    [self setShowedRightSwipeView:NO animated:NO];
}

- (void)willBeganSwipe {
}

- (void)didBeganSwipe {
    self.swipeDragging = YES;
}

- (void)movingSwipe:(CGFloat)progress {
}

- (void)willEndedSwipe {
    self.swipeDragging = NO;
    self.swipeDecelerating = YES;
}

- (void)didEndedSwipe {
    _showedLeftSwipeView = (_panSwipeProgress < 0.0f) ? YES : NO;
    _showedRightSwipeView = (_panSwipeProgress > 0.0f) ? YES : NO;
    self.swipeDecelerating = NO;

    [self.item setEditing:((_showedLeftSwipeView == YES) || (_showedRightSwipeView == YES)) animated:YES];
}

#pragma mark Private

- (UIOffset)rootOffsetOfCenterBySwipeProgress:(CGFloat)swipeProgress {
    switch(_swipeStyle) {
        case MobilyDataItemSwipeViewStyleStands:
        case MobilyDataItemSwipeViewStyleLeaves: {
            if(swipeProgress < 0.0f) {
                return UIOffsetMake(_leftSwipeView.frameWidth * (-swipeProgress), 0.0f);
            } else if(swipeProgress > 0.0f) {
                return UIOffsetMake((-_rightSwipeView.frameWidth) * swipeProgress, 0.0f);
            }
            break;
        }
        case MobilyDataItemSwipeViewStylePushes:
            break;
    }
    return UIOffsetMake(0.0f, 0.0f);
}

- (CGFloat)leftOffsetBySwipeProgress:(CGFloat)swipeProgress {
    CGFloat leftSwipeWidth = _leftSwipeView.frameWidth;
    switch(_swipeStyle) {
        case MobilyDataItemSwipeViewStyleStands:
            return 0.0f;
        case MobilyDataItemSwipeViewStyleLeaves:
        case MobilyDataItemSwipeViewStylePushes:
            if(swipeProgress < 0.0f) {
                return -leftSwipeWidth + (leftSwipeWidth * (-swipeProgress));
            }
            break;
    }
    return -leftSwipeWidth;
}

- (CGFloat)rightOffsetBySwipeProgress:(CGFloat)swipeProgress {
    CGFloat rightSwipeWidth = _rightSwipeView.frameWidth;
    switch(_swipeStyle) {
        case MobilyDataItemSwipeViewStyleStands:
            return 0.0f;
        case MobilyDataItemSwipeViewStyleLeaves:
        case MobilyDataItemSwipeViewStylePushes:
            if(swipeProgress > 0.0f) {
                return rightSwipeWidth * (1.0f - swipeProgress);
            }
            break;
    }
    return rightSwipeWidth;
}

- (void)setSwipeProgress:(CGFloat)swipeProgress speed:(CGFloat)speed endedSwipe:(BOOL)endedSwipe {
    CGFloat minSwipeProgress = (_panSwipeDirection == MobilyTableSwipeCellDirectionLeft) ? -1.0f : 0.0f;
    CGFloat maxSwipeProgress = (_panSwipeDirection == MobilyTableSwipeCellDirectionRight) ? 1.0f :0.0f;
    CGFloat normalizedSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
    if(_panSwipeProgress != normalizedSwipeProgress) {
        _panSwipeProgress = normalizedSwipeProgress;
        self.rootOffsetOfCenter = [self rootOffsetOfCenterBySwipeProgress:_panSwipeProgress];
        self.leftSwipeOffset = [self leftOffsetBySwipeProgress:_panSwipeProgress];
        self.rightSwipeOffset = [self rightOffsetBySwipeProgress:_panSwipeProgress];
        [self setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:ABS(speed) / _swipeSpeed
                         animations:^{
                             [self layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if(endedSwipe == YES) {
                                 [self didEndedSwipe];
                             }
                         }];
    } else {
        if(endedSwipe == YES) {
            [self didEndedSwipe];
        }
    }
}

- (void)handlerPanGestureRecognizer:(UIPanGestureRecognizer*)gestureRecognizer {
    if(_swipeDecelerating == NO) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        CGPoint velocity = [gestureRecognizer velocityInView:self];
        switch([gestureRecognizer state]) {
            case UIGestureRecognizerStateBegan: {
                [self willBeganSwipe];
                self.panSwipeLastOffset = translation.x;
                self.panSwipeLastVelocity = velocity.x;
                self.panSwipeLeftWidth = -_leftSwipeView.frameWidth;
                self.panSwipeRightWidth = _rightSwipeView.frameWidth;
                self.panSwipeDirection = MobilyTableSwipeCellDirectionUnknown;
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat delta = _panSwipeLastOffset - translation.x;
                if(_panSwipeDirection == MobilyTableSwipeCellDirectionUnknown) {
                    if((_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.panSwipeDirection = MobilyTableSwipeCellDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.panSwipeDirection = MobilyTableSwipeCellDirectionRight;
                        [self didBeganSwipe];
                    } else if((_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (delta < -_swipeThreshold)) {
                        self.panSwipeDirection = MobilyTableSwipeCellDirectionLeft;
                        [self didBeganSwipe];
                    } else if((_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (delta > _swipeThreshold)) {
                        self.panSwipeDirection = MobilyTableSwipeCellDirectionRight;
                        [self didBeganSwipe];
                    }
                }
                if(_panSwipeDirection != MobilyTableSwipeCellDirectionUnknown) {
                    switch(_panSwipeDirection) {
                        case MobilyTableSwipeCellDirectionUnknown: {
                            break;
                        }
                        case MobilyTableSwipeCellDirectionLeft: {
                            CGFloat localDelta = MIN(MAX(_panSwipeLeftWidth, delta), -_panSwipeLeftWidth);
                            [self setSwipeProgress:_panSwipeProgress - (localDelta / _panSwipeLeftWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_panSwipeProgress];
                            break;
                        }
                        case MobilyTableSwipeCellDirectionRight: {
                            CGFloat localDelta = MIN(MAX(-_panSwipeRightWidth, delta), _panSwipeRightWidth);
                            [self setSwipeProgress:_panSwipeProgress + (localDelta / _panSwipeRightWidth) speed:localDelta endedSwipe:NO];
                            [self movingSwipe:_panSwipeProgress];
                            break;
                        }
                    }
                    self.panSwipeLastOffset = translation.x;
                    self.panSwipeLastVelocity = velocity.x;
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
                [self willEndedSwipe];
                CGFloat swipeProgress = roundf(_panSwipeProgress - (_panSwipeLastVelocity / _swipeVelocity));
                CGFloat minSwipeProgress = (_panSwipeDirection == MobilyTableSwipeCellDirectionLeft) ? -1.0f : 0.0f;
                CGFloat maxSwipeProgress = (_panSwipeDirection == MobilyTableSwipeCellDirectionRight) ? 1.0f : 0.0f;
                CGFloat needSwipeProgress = MIN(MAX(minSwipeProgress, swipeProgress), maxSwipeProgress);
                switch(_panSwipeDirection) {
                    case MobilyTableSwipeCellDirectionLeft: {
                        [self setSwipeProgress:needSwipeProgress speed:_panSwipeLeftWidth * ABS(needSwipeProgress - _panSwipeProgress) endedSwipe:YES];
                        break;
                    }
                    case MobilyTableSwipeCellDirectionRight: {
                        [self setSwipeProgress:needSwipeProgress speed:_panSwipeRightWidth * ABS(needSwipeProgress - _panSwipeProgress) endedSwipe:YES];
                        break;
                    }
                    default: {
                        [self didEndedSwipe];
                        break;
                    }
                }
                break;
            }
            default: {
                break;
            }
        }
    }
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    if(gestureRecognizer == _panGestureRecognizer) {
        if((_swipeDragging == NO) && (_swipeDecelerating == NO)) {
            if([self.item.widget shouldBeganEditItem:self.item] == YES) {
                CGPoint translation = [_panGestureRecognizer translationInView:self];
                if(fabs(translation.x) >= fabs(translation.y)) {
                    if((_showedLeftSwipeView == YES) && (_leftSwipeView != nil) && (translation.x < 0.0f)) {
                        return YES;
                    } else if((_showedRightSwipeView == YES) && (_rightSwipeView != nil) && (translation.x > 0.0f)) {
                        return YES;
                    } else if((_showedLeftSwipeView == NO) && (_leftSwipeView != nil) && (translation.x > 0.0f)) {
                        return YES;
                    } else if((_showedRightSwipeView == NO) && (_rightSwipeView != nil) && (translation.x < 0.0f)) {
                        return YES;
                    }
                    return NO;
                }
            }
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end

/*--------------------------------------------------*/