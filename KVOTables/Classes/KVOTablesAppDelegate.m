//
//  KVOTablesAppDelegate.m
//  KVOTables
//
//  Created by jeff on 11/25/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "KVOTablesAppDelegate.h"
#import "RootViewController.h"


@implementation KVOTablesAppDelegate

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

