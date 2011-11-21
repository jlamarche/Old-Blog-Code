//
//  SuperDBAppDelegate.h
//  SuperDB
//
//  Created by jeff on 9/5/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface SuperDBAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    
    UINavigationController  *navController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
- (NSString *)applicationDocumentsDirectory;

@end

