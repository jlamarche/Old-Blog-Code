//
//  Hello_GoodbyeViewController.m
//  Hello Goodbye
//
//  Created by jeff on 8/10/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "Hello_GoodbyeViewController.h"

@implementation Hello_GoodbyeViewController
@synthesize outputLabel;
@synthesize nameField;
- (IBAction)retractKeyboard
{
    [nameField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)sayHello 
{
    NSString *name = nameField.text;
    NSString *message = [[NSString alloc] initWithFormat:@"Hello, %@", name];
    outputLabel.text = message;
    [message release];
}
- (IBAction)sayGoodbye
{
    NSString *name = nameField.text;
    NSString *message = [[NSString alloc] initWithFormat:@"Goodbye, %@", name];
    outputLabel.text = message;
    [message release]; 
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.outputLabel = nil;
    self.nameField = nil;
}


- (void)dealloc {
    [outputLabel release];
    [nameField release];
    [super dealloc];
}

@end
