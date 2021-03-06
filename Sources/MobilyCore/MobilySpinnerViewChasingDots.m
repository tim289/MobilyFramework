/*--------------------------------------------------*/
/*                                                  */
/* The MIT License (MIT)                            */
/*                                                  */
/* Copyright (c) 2014 Mobily TEAM                   */
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
#define MOBILY_SOURCE
/*--------------------------------------------------*/

#import <MobilyCore/MobilySpinnerView.h>

/*--------------------------------------------------*/

@implementation MobilySpinnerViewChasingDots

- (void)prepareAnimation {
    [super prepareAnimation];
    
    NSTimeInterval beginTime = CACurrentMediaTime();

    CALayer* spinner = [CALayer layer];
    spinner.frame = CGRectMake(0.0f, 0.0f, self.size, self.size);
    spinner.anchorPoint = CGPointMake(0.5f, 0.5f);
    spinner.transform = CATransform3DIdentity;
    spinner.shouldRasterize = YES;
    spinner.rasterizationScale = UIScreen.mainScreen.scale;
    [self.layer addSublayer:spinner];

    CAKeyframeAnimation* spinnerAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    spinnerAnimation.removedOnCompletion = NO;
    spinnerAnimation.repeatCount = HUGE_VALF;
    spinnerAnimation.duration = 2.0f;
    spinnerAnimation.beginTime = beginTime;
    spinnerAnimation.keyTimes = @[@(0.0f), @(0.25), @(0.5f), @(0.75), @(1.0f)];
    spinnerAnimation.timingFunctions = @[
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]
    ];
    spinnerAnimation.values = @[
       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)],
       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0f, 0.0f, 1.0f)],
       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f)],
       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.0f * M_PI_2, 0.0f, 0.0f, 1.0f)],
       [NSValue valueWithCATransform3D:CATransform3DMakeRotation(2.0f * M_PI, 0.0f, 0.0f, 1.0f)]
    ];
    [spinner addAnimation:spinnerAnimation forKey:@"spinner"];
    
    for(NSInteger i = 0; i < 2; i++) {
        CGFloat offset = self.size * 0.3f * i;
        
        CALayer* circle = [CALayer layer];
        circle.frame = CGRectOffset(CGRectApplyAffineTransform(CGRectMake(0.0f, 0.0f, self.size, self.size), CGAffineTransformMakeScale(0.6f, 0.6f)), offset, offset);
        circle.backgroundColor = self.color.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.cornerRadius = CGRectGetHeight(circle.bounds) * 0.5f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        [spinner addSublayer:circle];
        
        CAKeyframeAnimation* circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        circleAnimation.removedOnCompletion = NO;
        circleAnimation.repeatCount = HUGE_VALF;
        circleAnimation.duration = 2.0f;
        circleAnimation.beginTime = beginTime - (1.0f * i);
        circleAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
        circleAnimation.timingFunctions = @[
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
            [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]
        ];
        circleAnimation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]
        ];
        [circle addAnimation:circleAnimation forKey:@"circle"];
    }
}

@end

/*--------------------------------------------------*/

