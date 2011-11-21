//
//  SpinAppDelegate.h
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SpinViewController;

@interface SpinAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SpinViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SpinViewController *viewController;

@end

