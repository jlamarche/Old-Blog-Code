#import "ManagedObjectAttributeEditor.h"


@implementation ManagedObjectAttributeEditor
@synthesize managedObject;
@synthesize keypath;
@synthesize labelString;
- (void)viewWillAppear:(BOOL)animated  {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                     initWithTitle:NSLocalizedString(@"Cancel", 
                                                                     @"Cancel - for button to cancel changes")
                                     style:UIBarButtonSystemItemCancel
                                     target:self
                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Save", 
                                                                   @"Save - for button to save changes")
                                   style:UIBarButtonItemStyleDone
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
    // Objective-C has no support for abstract methods, so we're going 
    // to take matters into our own hands.
    NSException *ex = [NSException exceptionWithName:
                       @"Abstract Method Not Overridden" 
                                              reason:NSLocalizedString(@"You MUST override the save method", 
                                                                       @"You MUST override the save method")  
                                            userInfo:nil];
    [ex raise];
}
-(IBAction)validateAndPop {
    NSError *error;
    if (![managedObject.managedObjectContext save:&error]) {
        
        NSString *message = nil;
        if ([[error domain] isEqualToString:@"NSCocoaErrorDomain"]) {
            NSDictionary *userInfo = [error userInfo];
            message = [NSString stringWithFormat:NSLocalizedString(@"Validation error on %@\rFailed condition: %@", @"Validation error on %@, (failed condition: %@)"), [userInfo valueForKey:@"NSValidationErrorKey"], [userInfo valueForKey:@"NSValidationErrorPredicate"]];
        } 
        else   
            message = [error localizedDescription];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Validation Error", @"Validation Error") 
                                                        message:message 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")  
                                              otherButtonTitles:NSLocalizedString(@"Fix", @"Fix"), nil];
        [alert show];
        [alert release];
        
    } 
    else
        [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)dealloc {
    [managedObject release];
    [keypath release];
    [labelString release];
    [super dealloc];
}
#pragma mark -
#pragma mark Alert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [self.managedObject.managedObjectContext rollback];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
