//
//  GLView.h
//  Face
//
//  Created by jeff on 9/20/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@class GLViewController;
@interface GLView : NSOpenGLView {

}
@property IBOutlet GLViewController *controller;
@property (assign) NSMutableArray *colors;
- (void)setViewportRect:(NSRect)bounds;
@end
