//
//  RootViewController.h
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import <UIKit/UIKit.h>

@class GameViewController;
@class HelpViewController;
@class StatsViewController;
@interface RootViewController : UIViewController {
	GameViewController	*gameViewController;
	UIBarButtonItem		*highScoreButton;
	UIView				*containerView;

	HelpViewController *helpViewController;
	StatsViewController *statsViewController;
	BOOL highScoreShowing;
}
@property (nonatomic, retain) GameViewController *gameViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *highScoreButton;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) HelpViewController *helpViewController;
@property (nonatomic, retain) StatsViewController *statsViewController;
@property BOOL highScoreShowing;
- (IBAction)help;
- (IBAction)toggleHighScores;
@end
