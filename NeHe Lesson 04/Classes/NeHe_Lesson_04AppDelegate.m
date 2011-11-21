//
//  NeHe_Lesson_04AppDelegate.m
//  NeHe Lesson 04
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "NeHe_Lesson_04AppDelegate.h"
#import "GLViewController.h"
#import "GLView.h"

#define kRenderingFrequency 60.0

@implementation NeHe_Lesson_04AppDelegate
@synthesize window;
@synthesize controller;

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	CGRect	rect = [[UIScreen mainScreen] bounds];
	
	window = [[UIWindow alloc] initWithFrame:rect];
	
	GLViewController *theController = [[GLViewController alloc] init];
	self.controller = theController;
	[theController release];
	
	GLView *glView = [[GLView alloc] initWithFrame:rect];
	[window addSubview:glView];

	glView.controller = controller;
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
	[glView release];
	
	[window makeKeyAndVisible];

}

- (void)dealloc
{
	[window release];
	[controller release];
	[super dealloc];
}
@end
