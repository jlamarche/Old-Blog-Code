//
//  Simple_PlayerAppDelegate.h
//  Simple Player
//
//  Created by jeff on 11/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Simple_PlayerViewController;

@interface Simple_PlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Simple_PlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Simple_PlayerViewController *viewController;

@end

