//
//  PinchesAppDelegate.h
//  Pinches
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PinchesViewController;

@interface PinchesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PinchesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PinchesViewController *viewController;

@end

