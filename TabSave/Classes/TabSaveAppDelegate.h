//
//  TabSaveAppDelegate.h
//  TabSave
//
//  Created by jeff on 9/5/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSelectedTabDefaultsKey @"Selected Tab"

@interface TabSaveAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow              *window;
    UITabBarController    *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@end

