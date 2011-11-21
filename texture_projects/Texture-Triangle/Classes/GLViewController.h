//
//  GLViewController.h
//  Texture
//
//  Created by jeff on 5/23/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


// Set this value to 1 to use PVRTC compressed texture, 0 to use a PNG
//#define USE_PVRTC_TEXTURE   1

@class GLView;
@interface GLViewController : UIViewController {
    GLuint		texture[1];
}
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;
@end
