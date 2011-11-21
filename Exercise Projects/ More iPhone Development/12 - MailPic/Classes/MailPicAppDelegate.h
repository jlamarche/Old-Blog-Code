//
//  MailPicAppDelegate.h
//  MailPic
//
//  Created by jeff on 11/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MailPicViewController;

@interface MailPicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MailPicViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MailPicViewController *viewController;

@end

