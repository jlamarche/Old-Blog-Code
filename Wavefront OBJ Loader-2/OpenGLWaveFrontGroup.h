//
//  OpenGLWaveFrontGroup.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/18/08.
//  Copyright 2008 Jeff LaMarche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLWaveFrontCommon.h"

@class OpenGLWaveFrontMaterial;

@interface OpenGLWaveFrontGroup : NSObject 
{
	NSString				*name;
	GLuint					numberOfFaces;
	Face3D					*faces;	
	Face3D					*textureCoordsIndices;
	OpenGLWaveFrontMaterial	*material;
}
@property (nonatomic, retain) NSString *name;
@property GLuint numberOfFaces;
@property Face3D *faces;
@property (nonatomic, retain) OpenGLWaveFrontMaterial *material;
@property Face3D *textureCoordsIndices;
- (id)initWithName:(NSString *)inName 
	 numberOfFaces:(GLuint)inNumFaces
  hasTextureCoords:(BOOL)hasTextureCoords
		  material:(OpenGLWaveFrontMaterial *)inMaterial;
@end
