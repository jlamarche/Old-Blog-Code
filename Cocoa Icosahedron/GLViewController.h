//
//  GLViewController.h
//  Face
//
//  Created by jeff on 9/20/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define kAttemptedUpdatesPerSecond  60

@class GLView;
@interface GLViewController : NSWindowController {

}
@property (getter=isAnimating, setter=setIsAnimating:) BOOL animating;
@property IBOutlet NSWindow *window;
@property IBOutlet GLView *glView;
@property NSTimer *timer;
@property (readonly) NSDictionary *fullScreenOptions;

@property GLfloat rotSpeed;



- (IBAction) toggleFullScreen:(id)sender;
@end
