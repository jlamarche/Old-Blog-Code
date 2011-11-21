//
//  FingerTestAppDelegate.h
//  FingerTest
//
//  Created by jeff on 4/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FingerTestViewController;

@interface FingerTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FingerTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FingerTestViewController *viewController;

@end

