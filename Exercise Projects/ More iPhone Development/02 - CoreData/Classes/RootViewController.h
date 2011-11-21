//
//  RootViewController.h
//  CoreData
//
//  Created by jeff on 7/4/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
