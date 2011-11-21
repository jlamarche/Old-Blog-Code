//
//  OutletTestAppDelegate.h
//  OutletTest
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OutletTestViewController;

@interface OutletTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OutletTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OutletTestViewController *viewController;

@end

