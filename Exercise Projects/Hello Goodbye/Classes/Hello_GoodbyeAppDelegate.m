//
//  Hello_GoodbyeAppDelegate.m
//  Hello Goodbye
//
//  Created by jeff on 8/10/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "Hello_GoodbyeAppDelegate.h"
#import "Hello_GoodbyeViewController.h"

@implementation Hello_GoodbyeAppDelegate

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
