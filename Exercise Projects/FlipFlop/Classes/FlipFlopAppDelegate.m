//
//  FlipFlopAppDelegate.m
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "FlipFlopAppDelegate.h"
#import "RootViewController.h"

@implementation FlipFlopAppDelegate

@synthesize window;
@synthesize rootController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window insertSubview:rootController.view atIndex:0];
    rootController.view.frame = window.frame;
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [rootController release];
    [super dealloc];
}

@end
