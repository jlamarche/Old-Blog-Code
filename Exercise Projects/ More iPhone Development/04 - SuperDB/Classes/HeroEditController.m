#import "HeroEditController.h"
#import "NSArray-NestedArrays.h"
#import "HeroValueDisplay.h"
#import "ManagedObjectAttributeEditor.h" 
@implementation HeroEditController
@synthesize hero;
- (void)viewWillAppear:(BOOL)animated {	
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    sectionNames = [[NSArray alloc] initWithObjects:
                    [NSNull null],
                    NSLocalizedString(@"General", @"General"),
                    nil];
    rowLabels = [[NSArray alloc] initWithObjects:
				 
                 // Section 1
                 [NSArray arrayWithObjects:NSLocalizedString(@"Name", @"Name"), nil],
				 
                 // Section 2
                 [NSArray arrayWithObjects:NSLocalizedString(@"Identity", @"Identity"),
                  NSLocalizedString(@"Birthdate", @"Birthdate"),
                  NSLocalizedString(@"Sex", @"Sex"),
                  nil],
                 
                 // Sentinel
                 nil];
	
    rowKeys = [[NSArray alloc] initWithObjects:
               
               // Section 1
               [NSArray arrayWithObjects:@"name", nil],
			   
               // Section 2
               [NSArray arrayWithObjects:@"secretIdentity", @"birthdate", @"sex", nil],
               
               // Sentinel
               nil];
    
	rowControllers = [[NSArray alloc] initWithObjects:
					  
                      // Section 1
                      [NSArray arrayWithObject:@"ManagedObjectStringEditor"],
					  
                      // Section 2
                      [NSArray arrayWithObjects:@"ManagedObjectStringEditor", 
                       @"ManagedObjectDateEditor",
                       @"ManagedObjectSingleSelectionListEditor", nil],
					  
                      // Sentinel
                      nil];
    rowArguments = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObject:[NSNull null]],
                    
                    // Section 2,
                    [NSArray arrayWithObjects:[NSNull null], 
                     [NSNull null], 
                     [NSDictionary dictionaryWithObject:[NSArray 
                                                         arrayWithObjects:@"Male", @"Female", nil] 
                                                 forKey:@"list"], 
                     nil],
                    
                    // Sentinel
                    nil];
    
    
	
    [super viewDidLoad];
}
- (void)dealloc {
    [hero release];
    [sectionNames release];
    [rowLabels release];
    [rowKeys release];
    [rowControllers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionNames count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id theTitle = [sectionNames objectAtIndex:section];
    if ([theTitle isKindOfClass:[NSNull class]])
        return nil;
	
    return theTitle;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rowLabels countOfNestedArray:section];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Hero Edit Cell Identifier";
    
    UITableViewCell *cell = [theTableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    id <HeroValueDisplay> rowValue = [hero valueForKey:rowKey];
    
    cell.detailTextLabel.text = [rowValue heroValueDisplay];
    cell.textLabel.text = rowLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString *controllerClassName = [rowControllers 
                                     nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    Class controllerClass = NSClassFromString(controllerClassName);
    ManagedObjectAttributeEditor *controller = 
    [controllerClass alloc];
    controller = [controller initWithStyle:UITableViewStyleGrouped];
    controller.keypath = rowKey;
    controller.managedObject = hero;
    controller.labelString = rowLabel;
    controller.title = rowLabel;
    
    NSDictionary *args = [rowArguments nestedObjectAtIndexPath:indexPath];
    if ([args isKindOfClass:[NSDictionary class]]) {
        if (args != nil) {
            for (NSString *oneKey in args) {
                id oneArg = [args objectForKey:oneKey];
                [controller setValue:oneArg forKey:oneKey];
            }
        }
    }    
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
