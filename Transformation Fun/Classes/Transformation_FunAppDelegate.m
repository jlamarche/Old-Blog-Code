//
//  Transformation_FunAppDelegate.m
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "Transformation_FunAppDelegate.h"
#import "Transformation_FunViewController.h"

@implementation Transformation_FunAppDelegate

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
