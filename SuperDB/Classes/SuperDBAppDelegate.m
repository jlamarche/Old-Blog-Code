//
//  SuperDBAppDelegate.m
//  SuperDB
//
//  Created by jeff on 7/7/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "SuperDBAppDelegate.h"


@implementation SuperDBAppDelegate

@synthesize window;
@synthesize navController;
@synthesize tabBar;
@synthesize contentView;
@synthesize selectedTab;

#pragma mark -
#pragma mark Custom Methods
-(void)hideTabBar {
    [self.tabBar removeFromSuperview];
}
-(void)showTabBar {
    self.tabBar.hidden = NO;
}
#pragma mark -
#pragma mark Application lifecycle
- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.selectedTab = [defaults integerForKey:kSelectedTabDefaultsKey];
    NSLog(@"selected tab: %d", self.selectedTab);
    UITabBarItem *item = [tabBar.items objectAtIndex:self.selectedTab];
    [tabBar setSelectedItem:item];
    
    [contentView insertSubview:navController.view atIndex:0];
	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			// Handle error
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:selectedTab forKey:kSelectedTabDefaultsKey];
}


#pragma mark -
#pragma mark Saving

/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.
 */
- (IBAction)saveAction:(id)sender {
	
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
		// Handle error
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"SuperDB.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
    [navController release];
    [tabBar release];
    [contentView release];
	[super dealloc];
}

#pragma mark -
#pragma mark Tab Bar Delegate
- (void)tabBar:(UITabBar *)theTabBar didSelectItem:(UITabBarItem *)item {
    
    self.selectedTab = [theTabBar.items indexOfObject:tabBar.selectedItem];
}
@end

