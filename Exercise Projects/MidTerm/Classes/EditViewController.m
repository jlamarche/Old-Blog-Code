//
//  EditViewController.m
//  MidTerm
//
//  Created by jeff on 8/15/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController
@synthesize textField;
@synthesize array;
@synthesize index;
#pragma mark - 
#pragma mark Action Methods
- (IBAction)backgroundClick
{
    [textField resignFirstResponder];
}

- (IBAction)save 
{
    [array replaceObjectAtIndex:index withObject:textField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Superclass Overrides
- (void)viewWillLoad
{
    
}

- (void)viewWillAppear:(BOOL)animated 
{
    textField.text = [array objectAtIndex:index];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    [textField becomeFirstResponder];
    
    [super viewWillAppear:animated];
}
- (void)viewDidUnload {
    self.textField = nil;
}
- (void)dealloc {
    [textField release];
    [array release];
    [super dealloc];
}


@end
