//
//  CG_TestAppDelegate.m
//  CG Test
//
//  Created by jeff on 5/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CG_TestAppDelegate.h"
#import "CG_TestViewController.h"

@implementation CG_TestAppDelegate

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
