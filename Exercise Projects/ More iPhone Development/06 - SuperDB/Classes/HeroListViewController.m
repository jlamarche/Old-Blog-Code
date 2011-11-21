#import "HeroListViewController.h"
#import "SuperDBAppDelegate.h"
#import "HeroEditController.h"

@implementation HeroListViewController
@synthesize tableView;
@synthesize tabBar;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize detailController;
#pragma mark -
- (void)addHero {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSError *error;
    if (![context save:&error])
        NSLog(@"Error saving entity: %@", [error localizedDescription]);
     
    detailController.hero = newManagedObject;
    [self.navigationController pushViewController:detailController animated:YES];
}
- (IBAction)toggleEdit {
    BOOL editing = !self.tableView.editing;
    self.navigationItem.rightBarButtonItem.enabled = !editing;
    self.navigationItem.leftBarButtonItem.title = (editing) ? NSLocalizedString(@"Done", @"Done") : NSLocalizedString(@"Edit", @"Edit");
    [self.tableView setEditing:editing animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error loading data", @"Error loading data") 
                                                        message:[NSString stringWithFormat:@"Error was: %@, quitting.", [error localizedDescription]]
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
                                              otherButtonTitles:nil];
        [alert show];
		
	}
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger selectedTab = [defaults integerForKey:kSelectedTabDefaultsKey];
    UITabBarItem *item = [tabBar.items objectAtIndex:selectedTab];
    [tabBar setSelectedItem:item];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    UIBarButtonItem *editButton = self.editButtonItem; 
    [editButton setTarget:self];
    [editButton setAction:@selector(toggleEdit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHero)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.tableView = nil;
    self.tabBar = nil;
}


- (void)dealloc {
    [tableView release];
    [tabBar release];
    [_fetchedResultsController release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
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
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeroTableViewCell = @"HeroTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeroTableViewCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HeroTableViewCell] autorelease];
    }
	NSManagedObject *oneHero = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSInteger tab = [tabBar.items indexOfObject:tabBar.selectedItem];
    switch (tab) {
        case kByName:
            cell.textLabel.text = [oneHero valueForKey:@"name"];
            cell.detailTextLabel.text = [oneHero valueForKey:@"secretIdentity"];
            break;
        case kBySecretIdentity:
            cell.detailTextLabel.text = [oneHero valueForKey:@"name"];
            cell.textLabel.text = [oneHero valueForKey:@"secretIdentity"];
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)theTableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    detailController.hero = [self.fetchedResultsController 
                             objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:detailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error saving after delete", @"Error saving after delete.") 
                                                            message:[NSString stringWithFormat:@"Error was: %@, quitting.", [error localizedDescription]]
                                                           delegate:self 
                                                  cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
                                                  otherButtonTitles:nil];
            [alert show];
			exit(-1);
		}
	}   
}
#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // The typecast on the next line is not ordinarily necessary, however without it, we get a warning about
    // the returned object not conforming to UITabBarDelegate. The typecast quiets the warning so we get
    // a clean build.
    SuperDBAppDelegate *appDelegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Hero" inManagedObjectContext:managedObjectContext];
    
    
    NSUInteger tab = [tabBar.items indexOfObject:tabBar.selectedItem];
    if (tab == NSNotFound) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tab = [defaults integerForKey:kSelectedTabDefaultsKey];
    }
    
    NSString *sectionKey = nil;
    switch (tab) {
            // Notice that the kByName and kBySecretIdentity Code are nearly identical - refactoring opportunity?
        case kByName: {
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            [sortDescriptor1 release];
            [sortDescriptor2 release];
            [sortDescriptors release];
            sectionKey = @"name";
            break;
        }
        case kBySecretIdentity:{
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            [sortDescriptor1 release];
            [sortDescriptor2 release];
            [sortDescriptors release];
            sectionKey = @"secretIdentity";
            break;
        }
        default:
            break;
            
    }
   	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
    
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest    
                                                                          managedObjectContext:managedObjectContext 
                                                                            sectionNameKeyPath:sectionKey 
                                                                                     cacheName:@"Hero"];
    frc.delegate = self;
    _fetchedResultsController = frc;
    
	[fetchRequest release];
    
	return _fetchedResultsController;
}    
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    sectionInsertCount = 0;
    [self.tableView beginUpdates];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	switch(type) {
		case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
        case NSFetchedResultsChangeUpdate: {
            NSString *sectionKeyPath = [controller sectionNameKeyPath];
            if (sectionKeyPath == nil)
                break;
            NSManagedObject *changedObject = [controller objectAtIndexPath:indexPath];
            NSArray *keyParts = [sectionKeyPath componentsSeparatedByString:@"."];
            id currentKeyValue = [changedObject valueForKeyPath:sectionKeyPath];
            for (int i = 0; i < [keyParts count] - 1; i++) {
                NSString *onePart = [keyParts objectAtIndex:i];
                changedObject = [changedObject valueForKey:onePart];
            }
            sectionKeyPath = [keyParts lastObject];
            NSDictionary *committedValues = [changedObject committedValuesForKeys:nil];
            
            if ([[committedValues valueForKeyPath:sectionKeyPath] isEqual:currentKeyValue])
                break;
            
            NSUInteger tableSectionCount = [self.tableView numberOfSections];
            NSUInteger frcSectionCount = [[controller sections] count];
            if (tableSectionCount + sectionInsertCount != frcSectionCount) {
                // Need to insert a section
                NSArray *sections = controller.sections;
                NSInteger newSectionLocation = -1;
                for (id oneSection in sections) {
                    NSString *sectionName = [oneSection name];
                    if ([currentKeyValue isEqual:sectionName]) {
                        newSectionLocation = [sections indexOfObject:oneSection];
                        break;
                    }
                }
                if (newSectionLocation == -1)
                    return; // uh oh
                
                if (!((newSectionLocation == 0) && (tableSectionCount == 1) && ([self.tableView numberOfRowsInSection:0] == 0))) {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newSectionLocation] withRowAnimation:UITableViewRowAnimationFade];
                    sectionInsertCount++;
                }
                
                NSUInteger indices[2] = {newSectionLocation, 0};
                newIndexPath = [[[NSIndexPath alloc] initWithIndexes:indices length:2] autorelease];
            }
        }
		case NSFetchedResultsChangeMove:
            if (newIndexPath != nil) {
                
                NSUInteger tableSectionCount = [self.tableView numberOfSections];
                NSUInteger frcSectionCount = [[controller sections] count];
                if (frcSectionCount != tableSectionCount + sectionInsertCount)  {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:[newIndexPath section]] withRowAnimation:UITableViewRowAnimationNone];
                    sectionInsertCount++;
                }
                
                
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation: UITableViewRowAnimationRight];
                
            }
            else {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationFade];
            }
			break;
        default:
			break;
	}
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
            if (!((sectionIndex == 0) && ([self.tableView numberOfSections] == 1))) {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                sectionInsertCount++;
            }
            
			break;
		case NSFetchedResultsChangeDelete:
            if (!((sectionIndex == 0) && ([self.tableView numberOfSections] == 1) )) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                sectionInsertCount--;
            }
            
			break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate: 
            break;
        default:
            break;
	}
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(-1); 
}

#pragma mark -
#pragma mark Tab Bar Delegate
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    [defaults setInteger:tabIndex forKey:kSelectedTabDefaultsKey];  
    
    _fetchedResultsController.delegate = nil;
    [_fetchedResultsController release];
    _fetchedResultsController = nil;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"Error performing fetch: %@", [error localizedDescription]);
    [self.tableView reloadData];
}
@end
