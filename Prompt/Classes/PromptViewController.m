//
//  PromptViewController.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import "PromptViewController.h"
#import "AlertPrompt.h"

@implementation PromptViewController
@synthesize label;
- (IBAction)buttonPressed
{
	AlertPrompt *prompt = [AlertPrompt alloc];
	prompt = [prompt initWithTitle:@"Test Prompt" message:@"Please enter some text in" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Okay"];
	[prompt show];
	[prompt release];
}

- (void)dealloc 
{
	[label release];
    [super dealloc];
}
#pragma mark -
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *entered = [(AlertPrompt *)alertView enteredText];
		label.text = [NSString stringWithFormat:@"You typed: %@", entered];
	}
}
@end
