//
//  ModalViewController.m
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "ModalViewController.h"


@implementation ModalViewController
- (IBAction)dismiss 
{
    [self.parentViewController dismissModalViewControllerAnimated:YES]; 
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
