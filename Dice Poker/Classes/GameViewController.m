//
//  GameViewController.m
//  Dice Poker
//
//  Created by Jeff LaMarche on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


#import "GameViewController.h"

@implementation GameViewController
@synthesize die1Button;
@synthesize die2Button;
@synthesize die3Button;
@synthesize die4Button;
@synthesize die5Button;

@synthesize scoreLabel;
@synthesize feedbackLabel;

@synthesize diceImages;
@synthesize diceButtons;
@synthesize keepLabels;

@synthesize keep1Label;
@synthesize keep2Label;
@synthesize keep3Label;
@synthesize keep4Label;
@synthesize keep5Label;

- (IBAction)toggleDie:(id)sender {
	
	if (gamePhase == kFirstRoll) {
		
		UIButton *senderButton = (UIButton *)sender;

		senderButton.alpha = (senderButton.alpha == 1.0f) ? .50f : 1.0f;
			
		for (int button = 0; button < 5; button++)
		{
			UIButton *oneButton = [diceButtons objectAtIndex:button];
			UILabel *keepLabel = [keepLabels objectAtIndex:button];
			keepLabel.hidden = (oneButton.alpha == .50f) ? NO : YES;
		}
	}
	
}
- (IBAction)roll {
	
	AudioServicesPlaySystemSound (rollSoundID);	
	for (int i = 1; i <= 5; i ++)
	{
		int roll = (arc4random() % ((unsigned)RAND_MAX + 1) %6);
		
		
		UIButton *theDieButton = [diceButtons objectAtIndex:i-1];
		if (theDieButton.alpha == 1.0f) {
			[theDieButton setImage:[diceImages objectAtIndex:roll] forState:UIControlStateNormal];
			[theDieButton setImage:[diceImages objectAtIndex:roll] forState:UIControlStateHighlighted];
			[theDieButton setTag:roll];
		}
		theDieButton.alpha = 1.0f;
		
		UILabel *keepLabel = [keepLabels objectAtIndex:i-1];
		keepLabel.hidden = YES;
		
		
	}

	// For testing algorithm...
//	[[diceButtons objectAtIndex:0] setTag:4];
//	[[diceButtons objectAtIndex:1] setTag:1];
//	[[diceButtons objectAtIndex:2] setTag:5];
//	[[diceButtons objectAtIndex:3] setTag:1];
//	[[diceButtons objectAtIndex:4] setTag:1];
	if (gamePhase == kFirstRoll) {
		
		int mostOfAKind = [self mostOfAKind];
		
		if (mostOfAKind == 5) {
			score += kPayoutFiveOfAKind;
			feedbackLabel.text = @"Five of a Kind";
		}
		else if (mostOfAKind == 4) {
			score += kPayoutFourOfAKind;
			feedbackLabel.text = @"Four of a Kind";
		}
		else {
			if ([self isStraight]) {
				score += kPayoutStraight;
				feedbackLabel.text = @"Straight";
			}
			else if ([self isFullHouse]) {
				score += kPayoutStraight;
				feedbackLabel.text = @"Full House";
			}
			else if (mostOfAKind == 3) {
				score += kPayoutThreeOfAKind;
				feedbackLabel.text = @"Three of a Kind";
			}
			else if (mostOfAKind == 2) {
				
				if ([self numberOfDifferentValues] == 3) {
					score += kPayoutTwoPair;
					feedbackLabel.text = @"Two Pair";
				}
				else {
					score += kPayoutPair;
					feedbackLabel.text = @"Pair";
				}
				
			}
			else 
				feedbackLabel.text = @"";
		}
	}			
	else {
		score-=1;
		feedbackLabel.text = @"";
	}
	
	NSString *newScoreString = [[NSString alloc] initWithFormat:@"%d", score];
	scoreLabel.text = newScoreString;
	[newScoreString release];
	
	gamePhase = (gamePhase == kFirstRoll) ? kSecondRoll : kFirstRoll;
	
}
- (int)numberOfDifferentValues {
	
	int counters[6] = {0,0,0,0,0,0};
	
	for (int die = 1; die <= 5; die ++)	{
		UIButton *button = [diceButtons objectAtIndex:die - 1];
		counters[button.tag]++;
	}
	
	int values = 0;
	for (int sides = 0; sides <6; sides++) 
		if (counters[sides] > 0)
			values ++;
	
	return values;
}
- (BOOL)isStraight {
	if ([self numberOfDifferentValues] != 5)
		return NO;
	
	return YES;
}
- (BOOL)isFullHouse {
	
	if ([self mostOfAKind] == 3){
		if ([self numberOfDifferentValues] == 2)
			return YES;
		
	}
	return NO;	
}
- (int)mostOfAKind {
	
	int mostOfAKind = 1;
	for (int side = 1; side <= 6; side++) {		// Loop through sides
		int numberOfSameDie = 0;
		for (int die = 1; die <=5; die++) {	// Looping through dice
			UIButton *theDieButton = [diceButtons objectAtIndex:die-1];
			if (theDieButton.tag == side)
				numberOfSameDie ++;
		}
		if (numberOfSameDie > mostOfAKind)
			mostOfAKind = numberOfSameDie;
	}
	return mostOfAKind;
}
#pragma mark -
- (id)initWithCoder:(NSCoder *)coder {
	
	if (self == [super initWithCoder:coder]) {
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"roll" ofType:@"wav"];
		AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path], &rollSoundID);
		UIImage *die1 = [UIImage imageNamed:@"die1.png"];
		UIImage *die2 = [UIImage imageNamed:@"die2.png"];
		UIImage *die3 = [UIImage imageNamed:@"die3.png"];
		UIImage *die4 = [UIImage imageNamed:@"die4.png"];
		UIImage *die5 = [UIImage imageNamed:@"die5.png"];
		UIImage *die6 = [UIImage imageNamed:@"die6.png"];
		
		NSArray *array = [[NSArray alloc] initWithObjects: die1, die2, die3, die4, die5, die6, nil];
		self.diceImages = array;
		[array release];
		
		gamePhase = kGameStarted;
		score = 100;
		
	}
	return self;
}
- (void)viewDidLoad {
	
	// Cache button pointers in array to make looping through them easier
	NSArray *buttonArray = [[NSArray alloc] initWithObjects:die1Button, die2Button, die3Button, die4Button, die5Button, nil];
	self.diceButtons = buttonArray;
	[buttonArray release];
	
	NSArray *keepArray = [[NSArray alloc] initWithObjects:keep1Label, keep2Label, keep3Label, keep4Label, keep5Label, nil];
	self.keepLabels = keepArray;
	[keepArray release];
	
	
}
#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[die1Button release];
	[die2Button release];
	[die3Button release];
	[die4Button release];
	[die5Button release];
	
	[scoreLabel release];
	[feedbackLabel release];
	
	[diceImages release];
	[diceButtons release];
	[keepLabels release];
	
	[keep1Label release];
	[keep2Label release];
	[keep3Label release];
	[keep4Label release];
	[keep5Label release];
	
	[super dealloc];
}


@end
