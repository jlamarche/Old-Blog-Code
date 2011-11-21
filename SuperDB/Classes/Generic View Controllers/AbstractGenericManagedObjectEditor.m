//
//  AbstractGenericViewController.m
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "AbstractGenericManagedObjectEditor.h"


@implementation AbstractGenericManagedObjectEditor
@synthesize managedObject;
@synthesize keypath;
@synthesize labelString;
- (void)viewWillAppear:(BOOL)animated  {
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
									 initWithTitle:NSLocalizedString(@"Cancel", @"Cancel - for button to cancel changes")
									 style:UIBarButtonSystemItemCancel
									 target:self
									 action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"Save", @"Save - for button to save changes")
								   style:UIBarButtonItemStylePlain
								   target:self 
								   action:@selector(save)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	[super viewWillAppear:animated];
}
-(IBAction)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save {
    // Objective-C has no support for abstract classes, so we're going to take matters into our own hands.
    NSException *ex = [NSException exceptionWithName:@"Abstract Method Not Overridden" reason:NSLocalizedString(@"You MUST override the save method", @"You MUST override the save method")  userInfo:nil];
    [ex raise];
}
-(void)dealloc {
    [managedObject release];
    [keypath release];
    [labelString release];
    [super dealloc];
}
@end
