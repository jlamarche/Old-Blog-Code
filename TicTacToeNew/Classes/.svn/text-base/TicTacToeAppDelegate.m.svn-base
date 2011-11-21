//
//  TicTacToeAppDelegate.m
//  TicTacToe
//
//  Created by jeff on 10/21/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "TicTacToeAppDelegate.h"
#import "TicTacToeViewController.h"

@implementation TicTacToeAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
