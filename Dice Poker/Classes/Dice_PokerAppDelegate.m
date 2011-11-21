//
//  Dice_PokerAppDelegate.m
//  Dice Poker
//
//  Created by Jeff LaMarche on 8/8/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Dice_PokerAppDelegate.h"
#import "GameViewController.h"

@implementation Dice_PokerAppDelegate

@synthesize window;
@synthesize rootController;
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
		
	[window addSubview:rootController.view];
    [window makeKeyAndVisible];
    //	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//	rootController.view.transform = CGAffineTransformConcat(rootController.view.transform, CGAffineTransformMakeRotation(degreesToRadian(90)));
//	rootController.view.center = window.center;

}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
