//
//  TicTacToeAppDelegate.h
//  TicTacToe
//
//  Created by jeff on 10/21/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TicTacToeViewController;

@interface TicTacToeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TicTacToeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TicTacToeViewController *viewController;

@end

