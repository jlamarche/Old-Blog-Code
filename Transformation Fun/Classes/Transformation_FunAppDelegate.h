//
//  Transformation_FunAppDelegate.h
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transformation_FunViewController;

@interface Transformation_FunAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Transformation_FunViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Transformation_FunViewController *viewController;

@end

