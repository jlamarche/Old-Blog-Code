//
//  GameViewController.h
//  Dice Poker
//
//  Created by Jeff LaMarche on 8/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

typedef enum {
	kGameStarted	= 0
	,kFirstRoll
	,kSecondRoll
} GamePhase;

typedef enum {
	kPayoutNothing = 0
	,kPayoutPair = 1
	,kPayoutTwoPair = 2
	,kPayoutThreeOfAKind = 5
	,kPayoutFullHouse = 20
	,kPayoutStraight = 25
	,kPayoutFourOfAKind = 100
	,kPayoutFiveOfAKind = 250
	
} Payout;

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>



@interface GameViewController : UIViewController {
	IBOutlet	UIButton	*die1Button;
	IBOutlet	UIButton	*die2Button;
	IBOutlet	UIButton	*die3Button;
	IBOutlet	UIButton	*die4Button;
	IBOutlet	UIButton	*die5Button;
	
	IBOutlet	UILabel		*scoreLabel;
	IBOutlet	UILabel		*feedbackLabel;
	
	IBOutlet	UILabel		*keep1Label;
	IBOutlet	UILabel		*keep2Label;
	IBOutlet	UILabel		*keep3Label;
	IBOutlet	UILabel		*keep4Label;
	IBOutlet	UILabel		*keep5Label;

	
	NSArray *diceImages;
	NSArray *diceButtons;
	NSArray	*keepLabels;

	SystemSoundID rollSoundID;
	GamePhase gamePhase;
	int			score;
	
}
@property (nonatomic, retain) UIButton *die1Button;
@property (nonatomic, retain) UIButton *die2Button;
@property (nonatomic, retain) UIButton *die3Button;
@property (nonatomic, retain) UIButton *die4Button;
@property (nonatomic, retain) UIButton *die5Button;
@property (nonatomic, retain) UILabel *scoreLabel;
@property (nonatomic, retain) UILabel *feedbackLabel;

@property (nonatomic, retain) NSArray *diceImages;
@property (nonatomic, retain) NSArray *diceButtons;
@property (nonatomic, retain) NSArray *keepLabels;

@property (nonatomic, retain) UILabel *keep1Label;
@property (nonatomic, retain) UILabel *keep2Label;
@property (nonatomic, retain) UILabel *keep3Label;
@property (nonatomic, retain) UILabel *keep4Label;
@property (nonatomic, retain) UILabel *keep5Label;

- (IBAction)roll;
- (IBAction)toggleDie:(id)sender;
- (int)mostOfAKind;
- (BOOL)isStraight;
- (BOOL)isFullHouse;
- (int)numberOfDifferentValues;
@end
