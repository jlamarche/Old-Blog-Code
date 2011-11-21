//
//  AlertOrientationTestViewController.m
//  AlertOrientationTest
//
//  Created by Jeff LaMarche on 12/22/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "AlertOrientationTestViewController.h"

@implementation AlertOrientationTestViewController
- (IBAction)showAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Which way is up?" message:@"I'm not sure I'm in the right orientation" delegate:self cancelButtonTitle:@"Okay, then..." otherButtonTitles:nil];
	[alert show];
	[alert release];
}

// This does work, but looks bad:
//- (void)didPresentAlertView:(UIAlertView *)alertView
//{
//	[UIView beginAnimations:@"" context:nil];
//	[UIView setAnimationDuration:0.1];
//	alertView.transform = CGAffineTransformRotate(alertView.transform, degreesToRadian(90));
//	[UIView commitAnimations];
//}


// This doesn't work:
//- (void)willPresentAlertView:(UIAlertView *)alertView
//{
//	[UIView beginAnimations:@"" context:nil];
//	alertView.transform = CGAffineTransformRotate(alertView.transform, degreesToRadian(90));
//	[UIView commitAnimations];
//}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)dealloc {
    [super dealloc];
}

@end
