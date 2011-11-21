//
//  RequestTypesAppDelegate.h
//  RequestTypes
//
//  Created by jeff on 11/1/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RequestTypesViewController;

@interface RequestTypesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RequestTypesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RequestTypesViewController *viewController;

@end

