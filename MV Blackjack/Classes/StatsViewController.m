//
//  HighScoreViewController.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "StatsViewController.h"
#import "Prefs.h"

@implementation StatsViewController
@synthesize handsPlayedLabel;
@synthesize handsWonLabel;
@synthesize handsLostLabel;
@synthesize handsPushedLabel;
@synthesize blackjacksLabel;
@synthesize percentWonLabel;
@synthesize percentLostLabel;
- (void)updateStats
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int	blackJackCount = [defaults integerForKey:kBlackjackCountKey];
	int handCount = [defaults integerForKey:kHandCountKey];
	int handsWon = [defaults integerForKey:kWinCountKey];
	int handsPushed = [defaults integerForKey:kPushCountKey];
	int handsLost = handCount - (handsWon + handsPushed);
	
	handsPlayedLabel.text = [NSString stringWithFormat:@"%d", handCount];
	handsWonLabel.text = [NSString stringWithFormat:@"%d", handsWon];
	handsPushedLabel.text = [NSString stringWithFormat:@"%d", handsPushed];
	handsLostLabel.text = [NSString stringWithFormat:@"%d", handCount - handsWon];
	blackjacksLabel.text = [NSString stringWithFormat:@"%d", blackJackCount];
	percentWonLabel.text = [NSString stringWithFormat:@"%%%.2f", (handsWon == 0) ? 0.0 : ((float)handsWon /(float)handCount ) * 100];
	percentLostLabel.text = [NSString stringWithFormat:@"%%%.2f", (handCount == 0) ? 0.0 : ((float)handsLost / (float)handCount) * 100];
}
- (IBAction)resetStats
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:0 forKey:kBlackjackCountKey];
	[defaults setInteger:0 forKey:kHandCountKey];
	[defaults setInteger:0 forKey:kWinCountKey];
	[defaults setInteger:0 forKey:kPushCountKey];
	[self updateStats];
}
- (void)viewDidLoad
{
	[self updateStats];
	[super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
	
	[self updateStats];
	[super viewWillAppear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc 
{
	[handsPlayedLabel release];
	[handsWonLabel release];
	[handsLostLabel release];
	[handsPushedLabel release];
	[blackjacksLabel release];
	[percentWonLabel release];
	[percentLostLabel release];
	
    [super dealloc];
}
@end
