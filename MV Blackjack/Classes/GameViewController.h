//
//  GameViewController.h
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import <UIKit/UIKit.h>
#import "Prefs.h"

#define kDealerOffscreenPosition CGRectMake(160, -100.0, 72.0, 96.0)
#define kPlayerCard1Position CGRectMake(20.0, 213.0, 72.0, 96.0)
#define kPlayerCard2Position CGRectMake(102.0, 213.0, 72.0, 96.0)
#define kPlayerCard3Position CGRectMake(184.0, 213.0, 72.0, 96.0)
#define kPlayerCard4Position CGRectMake(206.0, 213.0, 72.0, 96.0)
#define kPlayerCard5Position CGRectMake(228.0, 213.0, 72.0, 96.0)

#define kDealerCard1Position CGRectMake(20.0, 40.0, 72.0, 96.0)
#define kDealerCard2Position CGRectMake(102.0, 40.0, 72.0, 96.0)
#define kDealerCard3Position CGRectMake(184.0, 40.0, 72.0, 96.0)
#define kDealerCard4Position CGRectMake(206.0, 40.0, 72.0, 96.0)
#define kDealerCard5Position CGRectMake(228.0, 40.0, 72.0, 96.0)

#define kDealAnimationDuration 0.2

@interface GameViewController : UIViewController <UIAlertViewDelegate> {
	UIButton		*dealButton;
	UIButton		*hitButton;
	UIButton		*stayButton;
	
	NSMutableArray	*deck;
	
	NSMutableArray	*playerHand;
	NSMutableArray	*dealerHand;
	
	UILabel			*playerScoreLabel;
	UILabel			*dealerScoreLabel;
}
@property (nonatomic, retain) IBOutlet UIButton *dealButton;
@property (nonatomic, retain) IBOutlet UIButton *hitButton;
@property (nonatomic, retain) IBOutlet UIButton *stayButton;
@property (nonatomic, retain) IBOutlet NSMutableArray *deck;
@property (nonatomic, retain) NSMutableArray *playerHand;
@property (nonatomic, retain) NSMutableArray *dealerHand;
@property (nonatomic, retain) IBOutlet UILabel *playerScoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *dealerScoreLabel;
- (int)currentPlayerHandValue;
- (int)currentDealerHandValue;
- (IBAction)deal;
- (IBAction)hit;
- (IBAction)stay;

@end
