//
//  Hello_GoodbyeAppDelegate.h
//  Hello Goodbye
//
//  Created by jeff on 8/10/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hello_GoodbyeViewController;

@interface Hello_GoodbyeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Hello_GoodbyeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Hello_GoodbyeViewController *viewController;

@end

