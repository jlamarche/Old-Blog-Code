//
//  Custom_Alert_ViewViewController.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Custom_Alert_ViewViewController.h"

@implementation Custom_Alert_ViewViewController
@synthesize feedbackLabel;

- (IBAction)showCustomAlert
{
    CustomAlertView *alert = [[CustomAlertView alloc] init];
    alert.delegate = self;
    [alert show];
    [alert release];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.feedbackLabel = nil;
}
- (void)dealloc 
{
    [feedbackLabel release];
    [super dealloc];
}
- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithValue:(NSString *)value
{
    feedbackLabel.text = [NSString stringWithFormat:@"'%@' was entered", value];
}
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert
{
    feedbackLabel.text = NSLocalizedString(@"User cancelled alert", @"User cancelled alert");
}
@end
