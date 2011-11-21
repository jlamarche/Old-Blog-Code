//
//  TabSaveAppDelegate.m
//  TabSave
//
//  Created by jeff on 9/5/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "TabSaveAppDelegate.h"

@implementation TabSaveAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger whichTab = [defaults integerForKey:kSelectedTabDefaultsKey];    
    tabBarController.selectedIndex = whichTab;
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger whichTab = tabBarController.selectedIndex;
    [defaults setInteger:whichTab forKey:kSelectedTabDefaultsKey];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
