//
//  SuperDBAppDelegate.h
//  SuperDB
//
//  Created by jeff on 7/7/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GenericManagedObjectAppDelegate.h"
#define kSelectedTabDefaultsKey @"Selected Tab"

typedef enum {
    kByName = 0,
    kBySecretIdentity,
    kByCity,
    kByPower,
    kMetrics
} TabBarIndex;


@interface SuperDBAppDelegate : NSObject <UIApplicationDelegate, UITabBarDelegate, GenericManagedObjectAppDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    
    UINavigationController  *navController;
    UITabBar                *tabBar;
    UIView                  *contentView;
    NSInteger               selectedTab;
}

- (IBAction)saveAction:sender;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@property NSInteger selectedTab;

-(void)hideTabBar;
-(void)showTabBar;
@end

