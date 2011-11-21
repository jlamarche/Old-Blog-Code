#import "ManagedObjectStringEditor.h"

@implementation ManagedObjectStringEditor

#pragma mark -
#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ManagedObjectStringEditorCell = 
    @"ManagedObjectStringEditorCell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:ManagedObjectStringEditorCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:ManagedObjectStringEditorCell] autorelease];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        UIFont *font = [UIFont boldSystemFontOfSize:14.0];
        label.textColor = kNonEditableTextColor;
        label.font = font;
        [cell.contentView addSubview:label];
        [label release];
		
        UITextField *theTextField = [[UITextField alloc] 
                                     initWithFrame:CGRectMake(100, 10, 190, 25)];
        
        [cell.contentView addSubview:theTextField];
        theTextField.tag = kTextFieldTag;
        [theTextField release];
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:kLabelTag];
    
    label.text = labelString;
    UITextField *textField = (UITextField *)[cell.contentView 
                                             viewWithTag:kTextFieldTag];
    NSString *currentValue = [self.managedObject valueForKeyPath:self.keypath];
    
    NSEntityDescription *ed = [self.managedObject entity];
    NSDictionary *properties = [ed propertiesByName];
    NSAttributeDescription *ad = [properties objectForKey:self.keypath];
    NSString *defaultValue = nil;
    if (ad != nil)
        defaultValue = [ad defaultValue];
    if (![currentValue isEqualToString:defaultValue])
        textField.text =  currentValue;
    
    [textField becomeFirstResponder];
    return cell;
}
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(IBAction)save {
    NSUInteger onlyRow[] = {0, 0};
    NSIndexPath *onlyRowPath = [NSIndexPath indexPathWithIndexes:onlyRow length:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:onlyRowPath];
    UITextField *textField = (UITextField *)[cell.contentView 
                                             viewWithTag:kTextFieldTag];
    [self.managedObject setValue:textField.text forKey:self.keypath];
    
    NSError *error;
    if (![managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
