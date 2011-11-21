//
//  MultiRowDeleteAppDelegate.m
//  MultiRowDelete
//
//  Created by Jeff LaMarche on 10/25/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "MultiRowDeleteAppDelegate.h"
@implementation MultiRowDeleteAppDelegate

@synthesize window;
@synthesize navController;
@synthesize toolbar;
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	[window insertSubview:navController.view belowSubview:toolbar];
	//[window addSubview:navController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
	[toolbar release];
    [super dealloc];
}


@end
