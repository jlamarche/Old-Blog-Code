//
//  HighScoreViewController.h
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import <UIKit/UIKit.h>


@interface StatsViewController : UIViewController {
	UILabel	*handsPlayedLabel;
	UILabel *handsWonLabel;
	UILabel *handsLostLabel;
	UILabel *handsPushedLabel;
	UILabel *blackjacksLabel;
	UILabel *percentWonLabel;
	UILabel *percentLostLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *handsPlayedLabel;
@property (nonatomic, retain) IBOutlet UILabel *handsWonLabel;
@property (nonatomic, retain) IBOutlet UILabel *handsLostLabel;
@property (nonatomic, retain) IBOutlet UILabel *handsPushedLabel;
@property (nonatomic, retain) IBOutlet UILabel *blackjacksLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentWonLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentLostLabel;
- (IBAction)resetStats;
- (void)updateStats;
@end
