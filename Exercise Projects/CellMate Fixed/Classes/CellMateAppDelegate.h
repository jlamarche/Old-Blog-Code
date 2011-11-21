//
//  CellMateAppDelegate.h
//  CellMate
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewController;
@interface CellMateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TableViewController *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TableViewController *rootController;
@end

