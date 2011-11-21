//
//  Part2ProjectAppDelegate.h
//  Part2Project
//
//  Created by jeff on 4/30/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@class GLViewController;

@interface Part2ProjectAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow				*window;
	GLViewController		*controller;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLViewController *controller;
@end
