//
//  RootViewController.m
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DeviantDisplayViewController.h"

@implementation RootViewController
@synthesize inputField;
- (IBAction)backgroundTapped
{
    [inputField resignFirstResponder];
}
- (void)viewDidLoad
{
    [inputField becomeFirstResponder];
    self.title = NSLocalizedString(@"Deviant Downloader", @"");
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.inputField = nil;
}
- (void)dealloc 
{
    [inputField release];
    [super dealloc];
}
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DeviantDisplayViewController *controller = [[DeviantDisplayViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.deviantName = textField.text;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    return YES;
}
@end

