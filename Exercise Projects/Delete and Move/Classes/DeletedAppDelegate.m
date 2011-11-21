//
//  DeletedAppDelegate.m
//  Deleted
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "DeletedAppDelegate.h"
#import "TableViewController.h"

@implementation DeletedAppDelegate

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
