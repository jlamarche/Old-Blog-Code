//
//  SwipesAppDelegate.h
//  Swipes
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipesViewController;

@interface SwipesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SwipesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SwipesViewController *viewController;

@end

