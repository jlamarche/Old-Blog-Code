//
//  GenericManagedObjectStringEditor.m
//  SuperDB
//
//  Created by jeff on 7/9/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "GenericManagedObjectStringEditor.h"


@implementation GenericManagedObjectStringEditor

#pragma mark -
#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GenericManagedObjectStringEditorCell = @"GenericManagedObjectStringEditorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GenericManagedObjectStringEditorCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericManagedObjectStringEditorCell] autorelease];


		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
		label.textAlignment = UITextAlignmentRight;
		label.tag = kLabelTag;
		UIFont *font = [UIFont boldSystemFontOfSize:14.0];
		label.textColor = kNonEditableTextColor;
		label.font = font;
		[cell.contentView addSubview:label];
		[label release];
		
		
		UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
        [cell.contentView addSubview:theTextField];
        theTextField.tag = kTextFieldTag;
		[theTextField release];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kLabelTag];
    
    label.text = labelString;
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kTextFieldTag];;
    textField.text =  [managedObject valueForKey:self.keypath];
    [textField becomeFirstResponder];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(IBAction)save {
    NSUInteger onlyRow[] = {0, 0};
    NSIndexPath *onlyRowPath = [NSIndexPath indexPathWithIndexes:onlyRow length:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:onlyRowPath];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:kTextFieldTag];
    [self.managedObject setValue:textField.text forKey:self.keypath];
    
    NSError *error;
    if (![managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end

