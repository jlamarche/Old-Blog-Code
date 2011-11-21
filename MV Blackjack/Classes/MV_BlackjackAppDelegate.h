//
//  MV_BlackjackAppDelegate.h
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import <UIKit/UIKit.h>

@class RootViewController;
@interface MV_BlackjackAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow				*window;
	RootViewController		*rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;
@end

