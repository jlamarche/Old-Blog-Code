//
//  MultiRowDeleteAppDelegate.h
//  MultiRowDelete
//
//  Created by Jeff LaMarche on 10/25/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MultiRowDeleteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;
	UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController * navController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@end

