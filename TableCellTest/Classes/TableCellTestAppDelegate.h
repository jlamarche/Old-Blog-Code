//
//  TableCellTestAppDelegate.h
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface TableCellTestAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    RootViewController  *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootController;
@end

