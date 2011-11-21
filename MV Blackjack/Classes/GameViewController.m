//
//  GameViewController.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.



#import "GameViewController.h"
#import "CardView.h"
#import "Card.h"
#import "NSArray-Shuffle.h"
#import "NSMutableArray-QueueAndStack.h"

int handValue(NSArray *hand)
{
	int lowValue = 0;
	int highValue = 0;
	for (Card *oneCard in hand)
	{
		if (oneCard.frontShowing)
		{
			if (oneCard.value == kAce)
			{
				lowValue+= 1;
				highValue+= 11;
			}
			else if (oneCard.value == kJack || oneCard.value == kQueen || oneCard.value == kKing)
			{
				lowValue += 10;
				highValue += 10;
			}
			else
			{
				lowValue += (oneCard.value + 1);
				highValue += (oneCard.value + 1);
			}
		}
	}
	return (highValue > 21) ? lowValue : highValue;		
}

@implementation GameViewController
@synthesize dealButton;
@synthesize hitButton;
@synthesize stayButton;
@synthesize deck;
@synthesize playerHand;
@synthesize dealerHand;
@synthesize playerScoreLabel;
@synthesize dealerScoreLabel;
- (int)currentPlayerHandValue
{
	return handValue(playerHand);
}
- (int)currentDealerHandValue
{
	return handValue(dealerHand);
}
- (void)blackjack
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Blackjack", @"Blackjack")
													message:NSLocalizedString(@"You win!", @"You win!")
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"Great!", @"Displayed when player wins.")
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	hitButton.hidden = YES;
	stayButton.hidden = YES;
	[dealButton setTitle:NSLocalizedString(@"Deal Again", @"Deal Again") forState:UIControlStateNormal];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; 
	int numBlackjacks = [defaults integerForKey:kBlackjackCountKey];
	numBlackjacks++;
	[defaults setInteger:numBlackjacks forKey:kBlackjackCountKey];
	
	int numWins = [defaults integerForKey:kWinCountKey];
	numWins++;
	[defaults setInteger:numWins forKey:kWinCountKey];

	
}

- (IBAction)deal
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int numHands = [defaults integerForKey:kHandCountKey];
	numHands++;
	[defaults setInteger:numHands forKey:kHandCountKey];
	
	
	[playerHand removeAllObjects];
	[dealerHand removeAllObjects];
	// First, get rid of any cards on the table
	for (UIView *oneView in self.view.subviews)
	{
		if ([oneView isKindOfClass:[CardView class]])
			[oneView removeFromSuperview];
	}
	dealButton.hidden = YES;
	hitButton.hidden = NO;
	stayButton.hidden = NO;
	
	NSMutableArray *tempDeck = [NSMutableArray arrayWithCapacity:52];
	for (int i=0; i<4; i++)
	{
		for (int j=0; j < 13; j++)
		{
			Card *card = [[Card alloc] initWithSuit:i andValue:j];
			[tempDeck addObject:card];
			[card release];
		}
	}
	
	self.deck = [[tempDeck shuffledArray] mutableCopy];
	Card *card1 = [deck pop];
	Card *card2 = [deck pop];
	Card *card3 = [deck pop];
	Card *card4 = [deck pop];
	
	card1.frontShowing = YES;
	card2.frontShowing = YES;
	card3.frontShowing = YES;
	card4.frontShowing = NO;
	
	[playerHand addObject:card1];
	[playerHand addObject:card3];
	[dealerHand addObject:card2];
	[dealerHand addObject:card4];
	
	CardView *playerCardView1 = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
	playerCardView1.card = card1;
	[self.view addSubview:playerCardView1];
	
	
	CardView *playerCardView2 = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
	playerCardView2.card = card3;
	[self.view addSubview:playerCardView2];
	
	
	CardView *dealerCardView1 = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
	dealerCardView1.card = card2;
	[self.view addSubview: dealerCardView1];
	
	
	CardView *dealerCardView2 = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
	dealerCardView2.card = card4;
	[self.view addSubview: dealerCardView2];
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDealAnimationDuration];
	[UIView setAnimationDelay:0.0];
	playerCardView1.frame = kPlayerCard1Position;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDealAnimationDuration];
	[UIView setAnimationDelay:0.1];
	dealerCardView1.frame = kDealerCard1Position;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDealAnimationDuration];
	[UIView setAnimationDelay:0.2];
	playerCardView2.frame = kPlayerCard2Position;
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDealAnimationDuration];
	[UIView setAnimationDelay:0.3];
	dealerCardView2.frame = kDealerCard2Position;
	[UIView commitAnimations];
	
	
	[playerCardView1 release];
	[playerCardView2 release];
	[dealerCardView1 release];
	[dealerCardView2 release];
	
	playerScoreLabel.text = [NSString stringWithFormat:@"%d", [self currentPlayerHandValue]];
	dealerScoreLabel.text = [NSString stringWithFormat:@"%d", [self currentDealerHandValue]];
	
	// Check for blackjack
	if ([self currentPlayerHandValue] == 21)
	{
		[self performSelector:@selector(blackjack) withObject:nil afterDelay:1.5];
		hitButton.hidden = YES;
		stayButton.hidden = YES;
	}
		
}
- (void)busted
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Busted", @"When you get a score greater than 21 in Blackjack")
													message:NSLocalizedString(@"Your hand exceeds 21, dealer wins", @"Your hand exceeds 21, dealer wins")
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"Bummer", @"Displayed when player loses.")
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[dealButton setTitle:NSLocalizedString(@"Deal Again", @"Deal Again") forState:UIControlStateNormal];
}
- (IBAction)hit
{
	CGRect theRect;
	
	if ([playerHand count] == 2)
		theRect = kPlayerCard3Position;
	else if ([playerHand count] == 3)
		theRect = kPlayerCard4Position;
	else
		theRect = kPlayerCard5Position;
	
	Card *nextCard = [deck pop];
	nextCard.frontShowing = YES;
	[playerHand addObject:nextCard];
	CardView *nextCardView = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
	nextCardView.card = nextCard;
	[self.view addSubview:nextCardView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kDealAnimationDuration];
	[UIView setAnimationDelay:0.0];
	nextCardView.frame = theRect;
	[UIView commitAnimations];
	
	[nextCardView release];
	playerScoreLabel.text = [NSString stringWithFormat:@"%d", [self currentPlayerHandValue]];
	if ([self currentPlayerHandValue] > 21)
	{
		hitButton.hidden = YES;
		stayButton.hidden = YES;
		[self performSelector:@selector(busted) withObject:nil afterDelay:1.2];
	}
	else
	{
		if ([playerHand count] >= 5)
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Five Card Charlie", @"When you get five cards without busting, called a 'Five Card Charlie' in USA")
															message:NSLocalizedString(@"You win!", @"You win!")
														   delegate:self 
												  cancelButtonTitle:NSLocalizedString(@"Great!", @"Displayed when player wins.")
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			hitButton.hidden = YES;
			stayButton.hidden = YES;
			[dealButton setTitle:NSLocalizedString(@"Deal Again", @"Deal Again") forState:UIControlStateNormal];
		}
	}
}
- (void)determineWinner
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	dealerScoreLabel.text = [NSString stringWithFormat:@"%d", [self currentDealerHandValue]];
	NSString *title = nil;
	NSString *message = nil;
	
	if ([self currentDealerHandValue] > 21)
	{
		title = @"Dealer Busted!";
		message = [NSString stringWithFormat:NSLocalizedString(@"You win with a score of %d.", nil), [self currentPlayerHandValue]];
		
		int numWins = [defaults integerForKey:kWinCountKey];
		numWins++;
		[defaults setInteger:numWins forKey:kWinCountKey];
	}
	else if ([self currentPlayerHandValue] > [self currentDealerHandValue])
	{
		title = @"You won!";
		message = [NSString stringWithFormat:NSLocalizedString(@"Your score of %d beats Dealer's score of %d.", nil), [self currentPlayerHandValue], [self currentDealerHandValue]];
		
		int numWins = [defaults integerForKey:kWinCountKey];
		numWins++;
		[defaults setInteger:numWins forKey:kWinCountKey];
	}
	else if ([self currentDealerHandValue] > [self currentPlayerHandValue])
	{
		title = @"You Lost!";
		message = [NSString stringWithFormat:NSLocalizedString(@"Your score of %d loses to Dealer's score of %d.", nil), [self currentPlayerHandValue], [self currentDealerHandValue]];
	}
	else
	{
		title = @"Push!";
		message = [NSString stringWithFormat:NSLocalizedString(@"You and Dealer tied with a score of %d", nil), [self currentPlayerHandValue]];
		int numPushes = [defaults integerForKey:kPushCountKey];
		numPushes++;
		[defaults setInteger:numPushes forKey:kPushCountKey];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message 
												   delegate:self 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"OK") 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	dealButton.hidden = NO;
}
- (IBAction)stay
{
	
	hitButton.hidden = YES;
	stayButton.hidden = YES;
	[dealButton setTitle:NSLocalizedString(@"Deal Again", @"Deal Again") forState:UIControlStateNormal];
	
	// Reveal Dealer's Hand
	for (UIView *oneView in self.view.subviews)
	{
		if ([oneView isKindOfClass:[CardView class]])
		{
			CardView *oneCardView = (CardView *)oneView;
			oneCardView.card.frontShowing = YES;
			[oneView setNeedsDisplay];[oneView setNeedsDisplay];
		}
	}
	dealerScoreLabel.text = [NSString stringWithFormat:@"%d", [self currentDealerHandValue]];
	
	while ([self currentDealerHandValue] < 17 && [dealerHand count] <= 5)
	{
		Card *nextCard = [deck pop];
		nextCard.frontShowing = YES;
		[dealerHand addObject:nextCard];
	}
	
	
	
	// Animate dealing dealier's hand
	for (int i=2; i < [dealerHand count]; i++)
	{
		CardView *dealtCardView = [[CardView alloc] initWithFrame:kDealerOffscreenPosition];
		dealtCardView.card = [dealerHand objectAtIndex:i];
		[self.view addSubview: dealtCardView];
		
		CGRect theRect;
		
		if (i == 2)
			theRect = kDealerCard3Position;
		else if (i == 3)
			theRect = kDealerCard4Position;
		else
			theRect = kDealerCard5Position;
		
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:kDealAnimationDuration];
		[UIView setAnimationDelay:(CGFloat)i*.1];
		dealtCardView.frame = theRect;
		[UIView commitAnimations];
		
	}
	
	[self performSelector:@selector(determineWinner) withObject:nil afterDelay:1.0];
	
	
}
#pragma mark -
- (void)viewDidLoad 
{	
	UIImage *redImage = [UIImage imageNamed:@"red_button.png"];
	UIImage *redImageStretchable = [redImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	UIImage *blueImage = [UIImage imageNamed:@"blueButton.png"];
	UIImage *blueImageStretchable = [blueImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	UIImage *greenImage = [UIImage imageNamed:@"green_button.png"];
	UIImage *greenImageStretchable = [greenImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	UIImage *whiteImage = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *whiteImageStretchable = [whiteImage stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	
	[dealButton setBackgroundImage:blueImageStretchable forState:UIControlStateNormal];
	[dealButton setBackgroundImage:whiteImageStretchable forState:UIControlStateHighlighted];
	
	[hitButton setBackgroundImage:greenImageStretchable forState:UIControlStateNormal];
	[hitButton setBackgroundImage:whiteImageStretchable forState:UIControlStateHighlighted];
	
	[stayButton setBackgroundImage:redImageStretchable forState:UIControlStateNormal];
	[stayButton setBackgroundImage:whiteImageStretchable forState:UIControlStateHighlighted];
	
	self.playerHand = [NSMutableArray array];
	self.dealerHand = [NSMutableArray array];
	
	[super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[dealButton release];
	[hitButton release];
	[stayButton release];
	[deck release];
	[playerHand release];
	[dealerHand release];
	[playerScoreLabel release];
	[dealerScoreLabel release];
	[super dealloc];
}


@end
