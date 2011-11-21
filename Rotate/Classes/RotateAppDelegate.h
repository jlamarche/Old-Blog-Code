//
//  RotateAppDelegate.h
//  Rotate
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RotateViewController;

@interface RotateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RotateViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RotateViewController *viewController;

@end

