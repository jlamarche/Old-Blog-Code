//
//  Hello_WorldAppDelegate.h
//  Hello World
//
//  Created by jeff on 8/10/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hello_WorldViewController;

@interface Hello_WorldAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Hello_WorldViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Hello_WorldViewController *viewController;

@end

