//
//  TapsAppDelegate.h
//  Taps
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapsViewController;

@interface TapsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TapsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TapsViewController *viewController;

@end

