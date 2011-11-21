//
//  Deviant_DownloaderAppDelegate.m
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Deviant_DownloaderAppDelegate.h"
#import "RootViewController.h"


@implementation Deviant_DownloaderAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
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

