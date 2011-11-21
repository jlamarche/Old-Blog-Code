//
//  GenericMangedObjectToOneRelationshipSelector.m
//  SuperDB
//
//  Created by jeff on 7/13/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "GenericManagedObjectToOneRelationshipSelector.h"
#import "GenericManagedObjectAppDelegate.h"
#import "ManagedObjectDetailEditor.h"

@implementation GenericManagedObjectToOneRelationshipSelector
@synthesize relationship;
@synthesize displayKey;
@synthesize dest;
@synthesize allowAdd;
@synthesize layoutFilename;
@synthesize fetchedResultsController = _fetchedResultsController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    id delegate = [[UIApplication sharedApplication] delegate];
    [delegate addObserver:self forKeyPath:@"selectedTab" options:NSKeyValueObservingOptionNew context:nil];
    
    NSArray *keypathParts = [self.keypath componentsSeparatedByString:@"."];
    if ([keypathParts count] != 2) {
        NSException *e = [NSException exceptionWithName:@"Invalid Keypath Exception" reason:@"To-One relationships require a two-part keypath (e.g. relationship.name). The first part is the name of the relationship to be displayed, the second is the attribute on the other entity to display." userInfo:nil];
        [e raise];
    }
    self.relationship = [keypathParts objectAtIndex:0];
    self.displayKey = [keypathParts objectAtIndex:1];
    NSEntityDescription *entity = self.managedObject.entity; 
    NSRelationshipDescription *relationshipDescr = [entity.relationshipsByName valueForKey:relationship];
    self.dest = relationshipDescr.destinationEntity;
    
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1); 
	}
}
- (void)viewWillAppear:(BOOL)animated 
{
    
    // See if there is a currently selected value, if so, select it
    NSManagedObject *currentValue = [self.managedObject valueForKey:self.relationship];
    for (NSManagedObject *oneItem in self.fetchedResultsController.fetchedObjects) {
        if ([oneItem isEqual:currentValue]) {
            NSUInteger newIndex[] = {0, [self.fetchedResultsController.fetchedObjects indexOfObject:oneItem]};
            NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
            lastIndexPath = newPath;
            break;
        }
    }
    [super viewWillAppear:animated];
}
-(IBAction)save {
    NSManagedObject *selected = [self.fetchedResultsController objectAtIndexPath:lastIndexPath];
    
    [self.managedObject setValue:selected forKey:self.relationship];
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc {
    [relationship release];
    [displayKey release];
    [dest release];
    [layoutFilename release];
    [_fetchedResultsController release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger count = [[self.fetchedResultsController sections] count];
    if (count == 0) {
        count = 1;
    }
    return count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
        
    }
    return (allowAdd) ? count+1 : count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GenericManagedObjectToOneRelationshipSelectorCell = @"GenericManagedObjectToOneRelationshipSelectorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GenericManagedObjectToOneRelationshipSelectorCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericManagedObjectToOneRelationshipSelectorCell] autorelease];
    }
    NSUInteger row = [indexPath row];
    
    if (row >= self.fetchedResultsController.fetchedObjects.count) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"Add new…", @"Add new…");
    }
    else {
        NSUInteger oldRow = [lastIndexPath row];
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [object valueForKey:displayKey];
        cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int newRow = [indexPath row];
	int oldRow = [lastIndexPath row];
	
    if (newRow >= self.fetchedResultsController.fetchedObjects.count) {
        NSArray *filenameComponents = [self.layoutFilename componentsSeparatedByString:@"."];
        NSString *layoutPath = [[NSBundle mainBundle] pathForResource:[filenameComponents objectAtIndex:0] ofType:[filenameComponents objectAtIndex:1]];
        
        if (layoutPath == nil) {
            NSException *e = [NSException exceptionWithName:@"Layout File Missing or In Incorrect Format" reason:@"The name of a valid layout file for adding a new instancemust be provided if allowAdd is YES." userInfo:nil];
            [e raise];
        }
        ManagedObjectDetailEditor *controller = [[ManagedObjectDetailEditor alloc] initWithLayoutFile:layoutPath];
        NSManagedObject *newMO = [NSEntityDescription insertNewObjectForEntityForName:self.dest.name inManagedObjectContext:self.managedObject.managedObjectContext];
        controller.managedObject = newMO;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if (newRow != oldRow || newRow == 0) {
		UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
		newCell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
		oldCell.accessoryType = UITableViewCellAccessoryNone;
		
        [lastIndexPath release];
		lastIndexPath = indexPath;	
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    id <GenericManagedObjectAppDelegate> appDelegate = (id <GenericManagedObjectAppDelegate>) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:displayKey ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,  nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
   	[fetchRequest setEntity:dest];
	[fetchRequest setFetchBatchSize:20];
    
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest    
                                                                          managedObjectContext:managedObjectContext 
                                                                            sectionNameKeyPath:nil 
                                                                                     cacheName:displayKey];
    frc.delegate = self;
    _fetchedResultsController = frc;
    // No release - it's not set to retain!
    
	[fetchRequest release];
    
	return _fetchedResultsController;
}    
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (!self.tableView.editing) 
        [self.tableView reloadData];
}

@end
