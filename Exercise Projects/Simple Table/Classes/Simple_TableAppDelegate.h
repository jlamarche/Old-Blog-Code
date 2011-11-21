//
//  Simple_TableAppDelegate.h
//  Simple Table
//
//  Created by jeff on 8/12/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Simple_TableAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITableViewController *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITableViewController *rootController;
@end

