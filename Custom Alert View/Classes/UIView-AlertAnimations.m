//
//  UIView-AlertAnimations.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView-AlertAnimations.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration  0.2555

@implementation UIView(AlertAnimations)
- (void)doPopInAnimation
{
    [self doPopInAnimationWithDelegate:nil];
}
- (void)doPopInAnimationWithDelegate:(id)animationDelegate
{
    CALayer *viewLayer = self.layer;
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    popInAnimation.duration = kAnimationDuration;
    popInAnimation.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:0.6],
                             [NSNumber numberWithFloat:1.1],
                             [NSNumber numberWithFloat:.9],
                             [NSNumber numberWithFloat:1],
                             nil];
    popInAnimation.keyTimes = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0],
                               [NSNumber numberWithFloat:0.6],
                               [NSNumber numberWithFloat:0.8],
                               [NSNumber numberWithFloat:1.0], 
                               nil];    
    popInAnimation.delegate = animationDelegate;
    
    [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];  
}
- (void)doFadeInAnimation
{
    [self doFadeInAnimationWithDelegate:nil];
}
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate
{
    CALayer *viewLayer = self.layer;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.duration = kAnimationDuration;
    fadeInAnimation.delegate = animationDelegate;
    [viewLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}
@end
