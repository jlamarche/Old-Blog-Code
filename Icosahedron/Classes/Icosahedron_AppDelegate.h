//
//  NeHe_Lesson_06AppDelegate.h
//  NeHe Lesson 06
//
//  Created by Jeff LaMarche on 12/13/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

@class GLViewController;

@interface Icosahedron_AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow				*window;
	GLViewController		*controller;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLViewController *controller;
@end
