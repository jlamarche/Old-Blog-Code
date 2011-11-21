//
//  TableCellTestAppDelegate.m
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TableCellTestAppDelegate.h"
#import "RootViewController.h"
@implementation TableCellTestAppDelegate

@synthesize window;
@synthesize rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	
    // Override point for customization after application launch
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)dealloc 
{
    [window release];
    [rootController release];
    [super dealloc];
}


@end
