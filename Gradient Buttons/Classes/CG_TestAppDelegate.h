//
//  CG_TestAppDelegate.h
//  CG Test
//
//  Created by jeff on 5/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CG_TestViewController;

@interface CG_TestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CG_TestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CG_TestViewController *viewController;

@end

