//
//  getAppDelegate.h
//  get
//
//  Created by jeff on 8/16/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class getViewController;

@interface getAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    getViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet getViewController *viewController;

@end

