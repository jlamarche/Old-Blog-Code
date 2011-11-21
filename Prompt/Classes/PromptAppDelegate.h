//
//  PromptAppDelegate.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromptViewController;

@interface PromptAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PromptViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PromptViewController *viewController;

@end

