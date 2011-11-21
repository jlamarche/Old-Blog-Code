//
//  getAppDelegate.m
//  get
//
//  Created by jeff on 8/16/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "getAppDelegate.h"
#import "getViewController.h"

@implementation getAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
