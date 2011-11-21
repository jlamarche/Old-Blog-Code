//
//  BouncyBallAppDelegate.h
//  BouncyBall
//
//  Created by jeff on 12/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLView;

@interface BouncyBallAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;

@end

