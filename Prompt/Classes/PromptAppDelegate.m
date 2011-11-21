//
//  PromptAppDelegate.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import "PromptAppDelegate.h"
#import "PromptViewController.h"

@implementation PromptAppDelegate

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
