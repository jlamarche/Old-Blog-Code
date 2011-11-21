//
//  OneInfiniteLoopAppDelegate.m
//  OneInfiniteLoop
//
//  Created by jeff on 8/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "OneInfiniteLoopAppDelegate.h"
#import "InfiniteViewController.h"


@implementation OneInfiniteLoopAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

