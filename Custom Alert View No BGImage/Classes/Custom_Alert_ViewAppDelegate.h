//
//  Custom_Alert_ViewAppDelegate.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Custom_Alert_ViewViewController;

@interface Custom_Alert_ViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Custom_Alert_ViewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Custom_Alert_ViewViewController *viewController;

@end

