//
//  ShipAppDelegate.h
//  Ship
//
//  Created by jeff on 7/17/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLView;

@interface ShipAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;

@end

