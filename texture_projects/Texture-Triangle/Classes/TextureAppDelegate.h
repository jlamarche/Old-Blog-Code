//
//  TextureAppDelegate.h
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@class GLViewController;

@interface TextureAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow				*window;
	GLViewController		*controller;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLViewController *controller;
@end
