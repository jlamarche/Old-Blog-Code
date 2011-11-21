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
#import "OpengLWaveFrontCommon.h"
#import "OpenGLWaveFrontMaterial.h"


@interface OpenGLWaveFrontObject : NSObject {
	NSString			*sourceObjFilePath;
	NSString			*sourceMtlFilePath;
	
	GLuint				numberOfVertices;
	Vertex3D			*vertices;
	
	GLuint				numberOfNormals;
	Vertex3D			*normals;
	
	GLuint				numberOfTextureCoords;
	Vertex3D			*textureCoords;
	
	GLuint				numberOfSurfaceNormals;
	Vertex3D			*surfaceNormals;
	
	GLuint				numberOfFaces;
	Face3D				*faces;
	
	NSDictionary		*materials;
	NSMutableArray		*groups;
	
	Vertex3D			currentPosition;
	Rotation3D			currentRotation;
}
@property (nonatomic, retain) NSString *sourceObjFilePath;
@property (nonatomic, retain) NSString *sourceMtlFilePath;
@property (nonatomic, retain) NSDictionary *materials;
@property (nonatomic, retain) NSMutableArray *groups;
@property Vertex3D currentPosition;
@property Rotation3D currentRotation;
- (id)initWithPath:(NSString *)path;
- (void)drawSelf;
@end
