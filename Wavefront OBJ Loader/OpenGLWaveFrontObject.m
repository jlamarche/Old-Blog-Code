//
//  OpenGLWaveFrontObject.m
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//
// This file will load certain .obj files into memory and display them in OpenGL ES.
// Because of limitations of OpenGL ES, not all .obj files can be loaded - faces larger
// than triangles cannot be handled, so files must be exported with only triangles.

// This version doesn't handle textures. That's coming.

#import "OpenGLWaveFrontObject.h"
#import "ConstantsAndMacros.h"

@implementation OpenGLWaveFrontObject
@synthesize currentPosition;
@synthesize currentRotation;
- (id)initWithPath:(NSString *)path
{
	if ((self = [super init]))
	{

		NSString *objData = [NSString stringWithContentsOfFile:path];
		NSUInteger vertexCount = 0, faceCount = 0;
		// Iterate through file once to discover how many vertices, normals, and faces there are
		NSArray *lines = [objData componentsSeparatedByString:@"\n"];
		for (NSString * line in lines)
		{
			if ([line hasPrefix:@"v "])
				vertexCount++;
			else if ([line hasPrefix:@"f "])
				faceCount++;
		}
		NSLog(@"Vertices: %d, Normals: %d, Faces: %d", vertexCount, faceCount);
		vertices = malloc(sizeof(Vertex3D) * vertexCount);
		faces = malloc(sizeof(Face3D) * faceCount);
		
		// Reuse our count variables for second time through
		vertexCount = 0;
		faceCount = 0;
		for (NSString * line in lines)
		{
			if ([line hasPrefix:@"v "])
			{
				NSString *lineTrunc = [line substringFromIndex:2];
				NSArray *lineVertices = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				vertices[vertexCount].x = [[lineVertices objectAtIndex:0] floatValue];
				vertices[vertexCount].y = [[lineVertices objectAtIndex:1] floatValue];
				vertices[vertexCount].z = [[lineVertices objectAtIndex:2] floatValue];
				// Ignore weight if it exists..
				vertexCount++;
			}
			else if ([line hasPrefix:@"f "])
			{
				NSString *lineTrunc = [line substringFromIndex:2];
				NSArray *faceIndexGroups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				// Unrolled loop, a little ugly but functional
				/*
				 From the WaveFront OBJ specification:
				 o       The first reference number is the geometric vertex.
				 o       The second reference number is the texture vertex. It follows the first slash.
				 o       The third reference number is the vertex normal. It follows the second slash.
				 */
				NSString *oneGroup = [faceIndexGroups objectAtIndex:0];
				NSArray *groupParts = [oneGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v1 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1; // indices in file are 1-indexed, not 0 indexed
				oneGroup = [faceIndexGroups objectAtIndex:1];
				groupParts = [oneGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v2 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;	
				oneGroup = [faceIndexGroups objectAtIndex:2];
				groupParts = [oneGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v3 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
				faceCount++;
				
			}
		}
		numberOfFaces = faceCount;
		
	}
	return self;
}
- (void)drawSelf
{
	// Save the current transformation by pushing it on the stack
	glPushMatrix();
	
	// Load the identity matrix to restore to origin
	glLoadIdentity();
	
	// Translate to the current position
	glTranslatef(currentPosition.x, currentPosition.y, currentPosition.z);
	
	// Rotate to the current rotation
	glRotatef(currentRotation.x, 1.0, 0.0, 0.0);
	glRotatef(currentRotation.y, 0.0, 1.0, 0.0);
	glRotatef(currentPosition.z, 0.0, 0.0, 1.0);
	
	// Enable and load the vertex array
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, vertices); 
	
	// Loop through faces and draw them
	for (int i = 0; i < numberOfFaces; i++)
	{
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, &faces[i]); 
	}
	
	glDisableClientState(GL_VERTEX_ARRAY);
	
	
	
	// Restore the current transformation by popping it off
	glPopMatrix();
}
- (void)dealloc
{
	if (vertices)
		free(vertices);
	if (faces)
		free(faces);
	[super dealloc];
}
@end
