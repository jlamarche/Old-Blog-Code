//
//  RootViewController.m
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "RootViewController.h"
#import "LoveViewController.h"
#import "HateViewController.h"

@implementation RootViewController
@synthesize loveController, hateController;
- (void)viewDidLoad
{
    [self.view insertSubview:loveController.view atIndex:0];
}
- (IBAction)flip
{
    UIViewController *coming, *going;
    
    if (loveController.view.superview == nil) 
    {
        coming = loveController;
        going = hateController;
    }
    else 
    {
        coming = hateController;
        going = loveController;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.view 
                             cache:YES];
    
    [coming viewWillAppear:NO];
    [going viewWillDisappear:NO];
    [going.view removeFromSuperview];
    [self.view insertSubview:coming.view atIndex:0];
    [coming viewDidAppear:YES];
    [going viewDidDisappear:YES];
    
    [UIView commitAnimations];

}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.loveController = nil;
    self.hateController = nil;
}


- (void)dealloc {
    [loveController release];
    [hateController release];
    [super dealloc];
}


@end
