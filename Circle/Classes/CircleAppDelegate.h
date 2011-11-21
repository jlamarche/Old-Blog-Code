//
//  CircleAppDelegate.h
//  Circle
//
//  Created by jeff on 4/28/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleViewController;

@interface CircleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CircleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CircleViewController *viewController;

@end

