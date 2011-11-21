//
//  RotateAppDelegate.m
//  Rotate
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "RotateAppDelegate.h"
#import "RotateViewController.h"

@implementation RotateAppDelegate

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
