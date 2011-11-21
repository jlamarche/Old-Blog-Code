//
//  StalledAppDelegate.h
//  Stalled
//
//  Created by jeff on 11/19/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StalledViewController;

@interface StalledAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    StalledViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet StalledViewController *viewController;

@end

