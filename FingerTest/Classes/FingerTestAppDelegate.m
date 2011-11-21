//
//  FingerTestAppDelegate.m
//  FingerTest
//
//  Created by jeff on 4/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FingerTestAppDelegate.h"
#import "FingerTestViewController.h"

@implementation FingerTestAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
