//
//  GLViewController.h
//  Part5Project
//
//  Created by jeff on 5/4/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLCommon.h"

@class GLView;
@interface GLViewController : UIViewController {
    Vertex3D    *sphereTriangleStripVertices;
    Vector3D    *sphereTriangleStripNormals;
    GLuint      sphereTriangleStripVertexCount;
    
    Vertex3D    *sphereTriangleFanVertices;
    Vector3D    *sphereTriangleFanNormals;
    GLuint      sphereTriangleFanVertexCount;
}
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;

@end
