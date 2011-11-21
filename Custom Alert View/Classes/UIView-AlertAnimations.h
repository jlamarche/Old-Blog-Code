//
//  UIView-AlertAnimations.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView(AlertAnimations)
- (void)doPopInAnimation;
- (void)doPopInAnimationWithDelegate:(id)animationDelegate;
- (void)doFadeInAnimation;
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate;
@end
