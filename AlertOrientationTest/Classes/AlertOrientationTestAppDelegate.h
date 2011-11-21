//
//  AlertOrientationTestAppDelegate.h
//  AlertOrientationTest
//
//  Created by Jeff LaMarche on 12/22/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertOrientationTestViewController;

@interface AlertOrientationTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AlertOrientationTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AlertOrientationTestViewController *viewController;

@end

