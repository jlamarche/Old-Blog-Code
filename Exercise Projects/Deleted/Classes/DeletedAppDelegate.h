//
//  DeletedAppDelegate.h
//  Deleted
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@class TableViewController;
@interface DeletedAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TableViewController *rootController;
    UIView  *contentView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TableViewController *rootController;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@end

