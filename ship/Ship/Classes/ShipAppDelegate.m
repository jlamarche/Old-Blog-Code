//
//  ShipAppDelegate.m
//  Ship
//
//  Created by jeff on 7/17/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "ShipAppDelegate.h"
#import "GLView.h"
#import "ConstantsAndMacros.h"

@implementation ShipAppDelegate

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
