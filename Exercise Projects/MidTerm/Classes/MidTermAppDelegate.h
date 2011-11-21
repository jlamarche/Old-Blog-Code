//
//  MidTermAppDelegate.h
//  MidTerm
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface MidTermAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

