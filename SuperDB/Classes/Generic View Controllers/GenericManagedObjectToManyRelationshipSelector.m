//
//  GenericManagedObjectToManyRelationshipSelector.m
//  SuperDB
//
//  Created by jeff on 7/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "GenericManagedObjectToManyRelationshipSelector.h"
#import "GenericManagedObjectAppDelegate.h"
#import "ManagedObjectDetailEditor.h"

@implementation GenericManagedObjectToManyRelationshipSelector
@synthesize relationship;
@synthesize selectedObjects;
@synthesize allowAdd;
@synthesize displayKey;
@synthesize dest;
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
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.selectedObjects = array;
    [array release];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.selectedObjects removeAllObjects];
    for (id oneObject in [self.managedObject mutableSetValueForKey:self.relationship])
        [self.selectedObjects addObject:oneObject];
    [super viewWillAppear:animated];
    
}
- (void)dealloc {
    [relationship release];
    [selectedObjects release];
    [displayKey release];
    [dest release];
    [layoutFilename release];
    [_fetchedResultsController release];
    [super dealloc];
}
-(IBAction)save {

    NSMutableSet *objects = [self.managedObject mutableSetValueForKey:self.relationship];
    [objects removeAllObjects];
    for (NSManagedObject *oneObject in selectedObjects) {
        
        if (![objects containsObject:oneObject])
            [objects addObject:oneObject];
    }
    
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
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
        
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [object valueForKey:displayKey];
        cell.accessoryType = ([selectedObjects containsObject:object]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    if ([indexPath row] >= [self.fetchedResultsController.fetchedObjects count]) {
        // Add a new one
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
    else {
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // Toggle the row's selection status
        if ([selectedObjects containsObject:object])
            [selectedObjects removeObject:object];
        else
            [selectedObjects addObject:object];
        [self.tableView reloadData];
    }
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
