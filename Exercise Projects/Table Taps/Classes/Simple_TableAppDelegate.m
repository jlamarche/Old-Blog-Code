//
//  Simple_TableAppDelegate.m
//  Simple Table
//
//  Created by jeff on 8/12/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "Simple_TableAppDelegate.h"

@implementation Simple_TableAppDelegate

@synthesize window;
@synthesize rootController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window insertSubview:rootController.view atIndex:0];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [window release];
    [rootController release];
    [super dealloc];
}

@end
