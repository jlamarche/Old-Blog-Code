//
//  OpenGLWaveFrontObject.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

typedef struct {
	GLfloat	x;
	GLfloat y;
	GLfloat z;
} Vertex3D, Vector3D, Rotation3D;

// A Face 3D contains three indices to vertices, generally faster to use...
typedef struct {
	GLushort	v1;
	GLushort	v2;
	GLushort	v3;
} Face3D;

@interface OpenGLWaveFrontObject : NSObject {
	Vertex3D	*vertices;
	int			numberOfFaces;
	Face3D		*faces;
	Vertex3D	currentPosition;
	Rotation3D	currentRotation;
}
@property Vertex3D currentPosition;
@property Rotation3D currentRotation;
- (id)initWithPath:(NSString *)path;
- (void)drawSelf;
@end
