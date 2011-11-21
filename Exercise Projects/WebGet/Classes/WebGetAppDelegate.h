//
//  WebGetAppDelegate.h
//  WebGet
//
//  Created by jeff on 12/6/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebGetViewController;

@interface WebGetAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    WebGetViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet WebGetViewController *viewController;

@end

