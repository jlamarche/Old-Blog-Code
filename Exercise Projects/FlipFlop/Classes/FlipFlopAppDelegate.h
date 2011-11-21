//
//  FlipFlopAppDelegate.h
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@interface FlipFlopAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootController;
@end

