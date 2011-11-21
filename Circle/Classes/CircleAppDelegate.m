//
//  CircleAppDelegate.m
//  Circle
//
//  Created by jeff on 4/28/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "CircleAppDelegate.h"
#import "CircleViewController.h"

@implementation CircleAppDelegate

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
