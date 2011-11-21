//
//  NeHe_Lesson_03AppDelegate.h
//  NeHe Lesson 03
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

@class GLViewController;

@interface NeHe_Lesson_03AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow				*window;
	GLViewController		*controller;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLViewController *controller;
@end
