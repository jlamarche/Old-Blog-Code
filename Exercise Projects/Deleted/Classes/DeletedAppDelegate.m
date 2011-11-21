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
@synthesize contentView;
- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    rootController.view.frame = CGRectMake(0.0, 0.0, contentView.frame.size.width, contentView.frame.size.height);
    // rootController.view.bounds = contentView.bounds;
    [contentView insertSubview:rootController.view atIndex:0];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 5;
    
    [window makeKeyAndVisible];
}
- (void)dealloc {
    [window release];
    [rootController release];
    [super dealloc];
}

@end
