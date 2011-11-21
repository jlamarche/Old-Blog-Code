//
//  CellMateAppDelegate.m
//  CellMate
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "CellMateAppDelegate.h"
#import "TableViewController.h"
@implementation CellMateAppDelegate

@synthesize window;
@synthesize rootController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window insertSubview:rootController.view atIndex:0];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
