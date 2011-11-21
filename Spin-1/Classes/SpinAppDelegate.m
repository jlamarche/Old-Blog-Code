//
//  SpinAppDelegate.m
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import "SpinAppDelegate.h"
#import "SpinViewController.h"

@implementation SpinAppDelegate

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
