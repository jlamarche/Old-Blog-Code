//
//  MV_BlackjackAppDelegate.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "MV_BlackjackAppDelegate.h"
#import "RootViewController.h"
@implementation MV_BlackjackAppDelegate

@synthesize window;
@synthesize rootViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
	[window insertSubview:rootViewController.view atIndex:0];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
	[rootViewController release];
    [super dealloc];
}


@end
