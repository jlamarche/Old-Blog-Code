//
//  KVOTablesAppDelegate.h
//  KVOTables
//
//  Created by jeff on 11/25/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface KVOTablesAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

