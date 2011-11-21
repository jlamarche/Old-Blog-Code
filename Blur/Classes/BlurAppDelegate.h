//
//  BlurAppDelegate.h
//  Blur
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlurViewController;

@interface BlurAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BlurViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BlurViewController *viewController;

@end

