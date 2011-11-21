//
//  NeHe_Lesson_02AppDelegate.h
//  NeHe Lesson 02
//
//  Created by Jeff LaMarche on 12/11/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLView.h"


@interface NeHe_Lesson_02AppDelegate : NSObject <UIApplicationDelegate, GLTriangleViewDelegate>
{
	UIWindow*				window;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end
