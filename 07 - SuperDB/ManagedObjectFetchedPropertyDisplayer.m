#import "ManagedObjectFetchedPropertyDisplayer.h"
#import "NSArray-Set.h"
#import "ManagedObjectEditor.h"

@implementation ManagedObjectFetchedPropertyDisplayer
@synthesize displayKey;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)dealloc {
    [displayKey release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = [self.managedObject valueForKey:keypath];
    return [array count];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Fetched Property Display Cell";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSArray *array = [self.managedObject valueForKey:keypath];
    
	NSManagedObject *oneObject = [array objectAtIndex:[indexPath row]];
    cell.textLabel.text = [oneObject valueForKey:displayKey];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = [self.managedObject valueForKey:keypath];    
	NSManagedObject *oneObject = [array objectAtIndex:[indexPath row]];
    SEL factorySelector = NSSelectorFromString(controllerFactoryMethod);
    ManagedObjectEditor *controller = [ManagedObjectEditor performSelector:factorySelector];
    controller.managedObject = oneObject;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
