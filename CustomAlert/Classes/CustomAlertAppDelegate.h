//
//  CustomAlertAppDelegate.h
//  CustomAlert
//
//  Created by jeff on 2/26/10.
//  Copyright Jeff LaMarche 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomAlertViewController;

@interface CustomAlertAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomAlertViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomAlertViewController *viewController;

@end

