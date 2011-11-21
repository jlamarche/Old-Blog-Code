#import "ManagedObjectSingleSelectionListEditor.h"

@implementation ManagedObjectSingleSelectionListEditor
@synthesize list;
-(IBAction)save {
    UITableViewCell *selectedCell = [self.tableView 
                                     cellForRowAtIndexPath:lastIndexPath];
    NSString *newValue = selectedCell.textLabel.text;
    [self.managedObject setValue:newValue forKey:self.keypath];
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated 
{
    NSString *currentValue = [self.managedObject valueForKey:self.keypath];
    for (NSString *oneItem in list) {
        if ([oneItem isEqualToString:currentValue]) {
            NSUInteger newIndex[] = {0, [list indexOfObject:oneItem]};
            NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:
                                    newIndex length:2];
            [lastIndexPath release];
            lastIndexPath = newPath;
            break;
        }
    }
    [super viewWillAppear:animated];
}
- (void)dealloc {
    [list release];
    [lastIndexPath release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int newRow = [indexPath row];
    int oldRow = [lastIndexPath row];
    
    if (newRow != oldRow || newRow == 0)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        [lastIndexPath release];
        lastIndexPath = indexPath;	
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GenericManagedObjectListSelectorCell = 
    @"GenericManagedObjectListSelectorCell";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:GenericManagedObjectListSelectorCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:GenericManagedObjectListSelectorCell] autorelease];
    }
    NSUInteger row = [indexPath row];
    NSUInteger oldRow = [lastIndexPath row];
    cell.textLabel.text = [list objectAtIndex:row];
    cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? 
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}
@end
