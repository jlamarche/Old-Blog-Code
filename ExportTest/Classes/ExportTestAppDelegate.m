//
//  ExportTestAppDelegate.m
//  ExportTest
//
//  Created by jeff on 6/24/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "ExportTestAppDelegate.h"
#import "GLView.h"
#import "ConstantsAndMacros.h"

@implementation ExportTestAppDelegate

@synthesize window;
@synthesize glView;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / kInactiveRenderingFrequency;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
	glView.animationInterval = 1.0 / 60.0;
}


- (void)dealloc {
	[window release];
	[glView release];
	[super dealloc];
}

@end
