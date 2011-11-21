//
//  GLViewController.h
//  NeHe Lesson 05
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@class GLView;
@interface GLViewController : UIViewController {
	GLuint  texture[1];      // Storage For One Texture ( NEW ) 
	NSMutableArray *colors;

}
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;
- (void)switchBackToFrustum;
- (void)switchToOrtho;
@end
