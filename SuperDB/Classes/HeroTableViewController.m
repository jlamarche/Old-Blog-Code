//
//  HeroTableViewController.m
//  SuperDB
//
//  Created by jeff on 7/7/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "HeroTableViewController.h"
#import "SuperDBAppDelegate.h"
#import "ManagedObjectDetailEditor.h"

@implementation HeroTableViewController
#pragma mark Properties
@synthesize fetchedResultsController = _fetchedResultsController;
#pragma mark -
#pragma mark Superclass Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1); 
	}
    SuperDBAppDelegate *delegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate addObserver:self forKeyPath:@"selectedTab" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem = self.editButtonItem;    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHero)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    SuperDBAppDelegate *delegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate showTabBar];
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc {
    [_fetchedResultsController release];
    [super dealloc];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem.enabled = !editing;
    [super setEditing:editing animated:animated];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _fetchedResultsController.delegate = nil;
    [_fetchedResultsController release];
    _fetchedResultsController = nil;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
        NSLog(@"Error performing fetch: %@", [error localizedDescription]);
    [self.tableView reloadData];
    
}
#pragma mark -
#pragma mark Additional Methods
- (void)addHero {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSString *layoutPath = [[NSBundle mainBundle] pathForResource:@"HeroLayout" ofType:@"plist"];
	ManagedObjectDetailEditor *controller = [[ManagedObjectDetailEditor alloc] initWithLayoutFile:layoutPath];
    controller.managedObject = newManagedObject;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    SuperDBAppDelegate *delegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate hideTabBar];
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
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *HeroTableViewCell = @"HeroTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeroTableViewCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HeroTableViewCell] autorelease];
    }
	NSManagedObject *oneHero = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = [oneHero valueForKey:@"name"];
    cell.detailTextLabel.text = [oneHero valueForKey:@"secretIdentity"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *oneHero = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *layoutPath = [[NSBundle mainBundle] pathForResource:@"HeroLayout" ofType:@"plist"];
	ManagedObjectDetailEditor *controller = [[ManagedObjectDetailEditor alloc] initWithLayoutFile:layoutPath];
    controller.managedObject = oneHero;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SuperDBAppDelegate *delegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate hideTabBar];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
		[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
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
    
    
    
    SuperDBAppDelegate *delegate = (SuperDBAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger tab = delegate.selectedTab;
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
            break;
        }
        case kByCity: {
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            [sortDescriptor1 release];
            [sortDescriptor2 release];
            [sortDescriptors release];
            break;
        }
            break;
        case kByPower: {
            
        }
            break;
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
    // No release - it's not set to retain!
    
	[fetchRequest release];
    
	
	return _fetchedResultsController;
}    
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if (!self.tableView.editing) 
        [self.tableView reloadData];
}
@end

