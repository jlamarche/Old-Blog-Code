//
//  AlertOrientationTestAppDelegate.m
//  AlertOrientationTest
//
//  Created by Jeff LaMarche on 12/22/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "AlertOrientationTestAppDelegate.h"
#import "AlertOrientationTestViewController.h"

@implementation AlertOrientationTestAppDelegate

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
