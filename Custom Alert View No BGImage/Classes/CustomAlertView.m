//
//  CustomAlertView.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"
#import "UIView-AlertAnimations.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomAlertView()
- (void)alertDidFadeOut;
@end

@implementation CustomAlertView
@synthesize alertView;
@synthesize backgroundView;
@synthesize inputField;
@synthesize delegate;
#pragma mark -
#pragma mark IBActions
- (IBAction)show
{
    // Retaining self is odd, but we do it to make this "fire and forget"
    [self retain];
    
    // We need to add it to the window, which we can get from the delegate
    id appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [appDelegate window];
    [window addSubview:self.view];
    
    // Make sure the alert covers the whole window
    self.view.frame = window.frame;
    self.view.center = window.center;
    
    // "Pop in" animation for alert
    [alertView doPopInAnimationWithDelegate:self];
    
    // "Fade in" animation for background
    [backgroundView doFadeInAnimation];
}
- (IBAction)dismiss:(id)sender
{
    [inputField resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(alertDidFadeOut)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];    

    
    if (sender == self || [sender tag] == CustomAlertViewButtonTagOk)
        [delegate CustomAlertView:self wasDismissedWithValue:inputField.text];
    else
    {
        if ([delegate respondsToSelector:@selector(customAlertViewWasCancelled:)])
            [delegate customAlertViewWasCancelled:self];
    }
    
        
}
#pragma mark -
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.alertView = nil;
    self.backgroundView = nil;
    self.inputField = nil;
}
- (void)dealloc 
{
    [alertView release];
    [backgroundView release];
    [inputField release];
    [super dealloc];
}
#pragma mark -
#pragma mark Private Methods
- (void)alertDidFadeOut
{    
    [self.view removeFromSuperview];
    [self autorelease];
}
#pragma mark -
#pragma mark CAAnimation Delegate Methods
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self.inputField becomeFirstResponder];
}
#pragma mark -
#pragma mark Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismiss:self];
    return YES;
}
@end
