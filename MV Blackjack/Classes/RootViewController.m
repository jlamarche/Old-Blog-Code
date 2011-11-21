//
//  RootViewController.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "RootViewController.h"
#import "GameViewController.h"
#import "HelpViewController.h"
#import "StatsViewController.h"

@implementation RootViewController
@synthesize gameViewController;
@synthesize highScoreButton;
@synthesize containerView;
@synthesize helpViewController;
@synthesize statsViewController;
@synthesize highScoreShowing;
- (IBAction)help
{
	if (helpViewController == nil)
	{
		HelpViewController *controller = [[HelpViewController alloc] initWithNibName:@"HelpView" bundle:nil];
		self.helpViewController = controller;
		helpViewController.presentingViewController = self;
		[controller release];
	}
	[self presentModalViewController:helpViewController animated:YES];
}
- (IBAction)toggleHighScores
{
	UIViewController *coming = nil;
	UIViewController *going = nil;
	UIViewAnimationTransition transition;
	if (highScoreShowing)
	{
		coming = gameViewController;
		going = statsViewController;
		transition = UIViewAnimationTransitionFlipFromLeft;
		//transition = UIViewAnimationTransitionCurlDown;
	}
	else
	{
		if (statsViewController == nil)
		{
			StatsViewController *controller = [[StatsViewController alloc] initWithNibName:@"StatsView" bundle:nil];
			self.statsViewController = controller;
			[controller release];
		}
		coming = statsViewController;
		going = gameViewController;
		transition = UIViewAnimationTransitionFlipFromRight;
		//transition = UIViewAnimationTransitionCurlUp;
	}
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition: transition forView:self.view cache:YES];
	[coming viewWillAppear:YES];
	[going viewWillDisappear:YES];
	[going.view removeFromSuperview];
	[self.containerView insertSubview: coming.view atIndex:0];
	[going viewDidDisappear:YES];
	[coming viewDidAppear:YES];
	
	[UIView commitAnimations];
	
	
	
	highScoreShowing = !highScoreShowing;
	
	if (highScoreShowing)
		highScoreButton.title = NSLocalizedString(@"Return to Game", @"Return to Game");
	else
		highScoreButton.title = NSLocalizedString(@"Stats", @"Short for Statistics");
}
#pragma mark -
- (void)viewDidLoad 
{
	highScoreShowing = NO;
	GameViewController *controller = [[GameViewController alloc] initWithNibName:@"GameView" bundle:nil];
	self.gameViewController = controller;
	[self.containerView insertSubview:controller.view atIndex:0];
	[controller release];
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	if (!highScoreShowing)
		self.statsViewController = nil;
	
	if (self.modalViewController == nil) // not presenting a view modally
		self.helpViewController = nil;
}


- (void)dealloc {
	[gameViewController release];
	[highScoreButton release];
	[containerView release];
	[helpViewController release];
	[statsViewController release];
    [super dealloc];
}


@end
