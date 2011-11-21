//
//  Dice_PokerAppDelegate.h
//  Dice Poker
//
//  Created by Jeff LaMarche on 8/8/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#define degreesToRadian(x) (M_PI * x / 180.0)
@class GameViewController;

@interface Dice_PokerAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet GameViewController *rootController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) GameViewController *rootController;
@end

