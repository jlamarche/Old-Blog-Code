//
//  OpenGLWaveFrontGroup.m
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/18/08.
//  Copyright 2008 Jeff LaMarche. All rights reserved.
//

#import "OpenGLWaveFrontGroup.h"

@implementation OpenGLWaveFrontGroup
@synthesize name;
@synthesize numberOfFaces;
@synthesize faces;
@synthesize textureCoordsIndices;
@synthesize material;

- (id)initWithName:(NSString *)inName 
	 numberOfFaces:(GLuint)inNumFaces
  hasTextureCoords:(BOOL)hasTextureCoords
		  material:(OpenGLWaveFrontMaterial *)inMaterial
{
	if ((self = [super init]))
	{
		self.name = inName;
		self.numberOfFaces = inNumFaces;
		self.material = inMaterial;
		faces = malloc(sizeof(Face3D) * numberOfFaces);
		if (hasTextureCoords)
			textureCoordsIndices = malloc(sizeof(Face3D) * numberOfFaces);
	}
	return self;
}

- (void)dealloc
{
	[name release];
	if (faces)
		free(faces);
	if (textureCoordsIndices)
		free(textureCoordsIndices);
	[material release];
	[super dealloc];
}
@end
