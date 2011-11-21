//
//  GLViewController.h
//  BouncyBall
//
//  Created by jeff on 12/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

#define kAnimationDuration  0.3
enum animationDirection {
    kAnimationDirectionForward = YES, 
    kAnimationDirectionBackward = NO
};
typedef BOOL AnimationDirection;

@interface GLViewController : UIViewController <GLViewDelegate>
{
}
@end
