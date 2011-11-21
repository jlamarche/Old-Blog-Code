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
#import "OpenGLWaveFrontGroup.h"

@implementation OpenGLWaveFrontObject
@synthesize sourceObjFilePath;
@synthesize sourceMtlFilePath;
@synthesize currentPosition;
@synthesize currentRotation;
@synthesize materials;
@synthesize groups;
- (id)initWithPath:(NSString *)path
{
	if ((self = [super init]))
	{
		self.groups = [NSMutableArray array];
		
		self.sourceObjFilePath = path;
		NSString *objData = [NSString stringWithContentsOfFile:path];
		NSUInteger vertexCount = 0, faceCount = 0, normalCount = 0, textureCoordsCount=0, materialCount = 1, groupCount = 0, vertexNormalCount = 0;
		// Iterate through file once to discover how many vertices, normals, and faces there are
		NSArray *lines = [objData componentsSeparatedByString:@"\n"];
		for (NSString * line in lines)
		{
			if ([line hasPrefix:@"v "])
				vertexCount++;
			else if ([line hasPrefix:@"vn "])
				vertexNormalCount++;
			else if ([line hasPrefix:@"n"])
				normalCount++;
			else if ([line hasPrefix:@"t"])
				textureCoordsCount++;
			else if ([line hasPrefix:@"m"])
			{
				NSString *truncLine = [line substringFromIndex:7];
				self.sourceMtlFilePath = truncLine;
				NSString *mtlPath = [[NSBundle mainBundle] pathForResource:[[truncLine lastPathComponent] stringByDeletingPathExtension] ofType:[truncLine pathExtension]];
				self.materials = [OpenGLWaveFrontMaterial materialsFromMtlFile:mtlPath];
				
			}
			else if ([line hasPrefix:@"g"])
				groupCount++;
			else if ([line hasPrefix:@"f"])
				faceCount++;
			
		}
		NSLog(@"Vertices: %d, Normals: %d, Faces: %d, Texture Coords: %d, Materials: %d, Groups: %d", vertexCount, normalCount, faceCount, textureCoordsCount, materialCount, groupCount);
		vertices = malloc(sizeof(Vertex3D) * vertexCount);
		faces = malloc(sizeof(Face3D) * faceCount);
		
		// in OBJ file format, normals are referenced by index also, but not in OpenGL
		// So, we load them all into the allNormals array, and then copy the values over
		// to the normals array 
		Vertex3D *allNormals = malloc(sizeof(Vertex3D) * normalCount);
		normals = malloc(sizeof(Vertex3D) * faceCount * 3);
		
		// Store the counts
		numberOfFaces = faceCount;
		numberOfNormals = normalCount;
		numberOfVertices = vertexCount;
		numberOfTextureCoords = textureCoordsCount;
		
		NSUInteger groupFaceCount = 0;
		// Reuse our count variables for second time through
		vertexCount = 0;
		faceCount = 0;
		normalCount = 0;
		OpenGLWaveFrontGroup *currentGroup = nil;
		NSUInteger lineNum = 0;
		BOOL usingGroups = YES;
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
			else if ([line hasPrefix:@"g "])
			{
				NSLog(@"New Group");
				NSString *groupName = [line substringFromIndex:2];
				NSUInteger counter = lineNum+1;
				NSUInteger currentGroupFaceCount = 0;
				NSString *materialName = nil;
				while (counter < [lines count])
				{
					NSString *nextLine = [lines objectAtIndex:counter++];
					if ([nextLine hasPrefix:@"usemtl "])
						materialName = [nextLine substringFromIndex:7];
					else if ([nextLine hasPrefix:@"f "])
						currentGroupFaceCount ++;
					else if ([nextLine hasPrefix:@"g "])
						break;
				}
				
				OpenGLWaveFrontMaterial *material = [materials objectForKey:materialName] ;
				if (material == nil)
					material = [OpenGLWaveFrontMaterial defaultMaterial];
				
			
				
				currentGroup = [[OpenGLWaveFrontGroup alloc] initWithName:groupName 
															numberOfFaces:currentGroupFaceCount 
																 material:material];
				[groups addObject:currentGroup];
				[currentGroup release];
				groupFaceCount = 0;
			}
			
			else if ([line hasPrefix:@"vn "])
			{
				
			}
			else if ([line hasPrefix:@"f "])
			{
				NSString *lineTrunc = [line substringFromIndex:2];
				NSArray *faceIndexGroups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				
				// If no groups in file, create one group that has all the vertices and uses the default material
				if (currentGroup == nil)
				{
					currentGroup = [[OpenGLWaveFrontGroup alloc] initWithName:@"default" numberOfFaces:numberOfFaces material:[OpenGLWaveFrontMaterial defaultMaterial]];
					[groups addObject:currentGroup];
					[currentGroup release];
					usingGroups = NO;
				}
				
				
				
				// Unrolled loop, a little ugly but functional
				/*
				 From the WaveFront OBJ specification:
				 o       The first reference number is the geometric vertex.
				 o       The second reference number is the texture vertex. It follows the first slash.
				 o       The third reference number is the vertex normal. It follows the second slash.
				 */
				NSString *oneFaceGroup = [faceIndexGroups objectAtIndex:0];
				NSArray *groupParts = [oneFaceGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v1 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1; // indices in file are 1-indexed, not 0 indexed
				currentGroup.faces[groupFaceCount].v1 =  [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
				oneFaceGroup = [faceIndexGroups objectAtIndex:1];
				groupParts = [oneFaceGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v2 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;	
				currentGroup.faces[groupFaceCount].v2 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;	
				oneFaceGroup = [faceIndexGroups objectAtIndex:2];
				groupParts = [oneFaceGroup componentsSeparatedByString:@"/"];
				faces[faceCount].v3 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
				currentGroup.faces[groupFaceCount].v3 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
								
				faceCount++;
				groupFaceCount++;
				NSLog(@"groupFaceCount: %d", groupFaceCount);
			}
			lineNum++;
		}
		free(allNormals);
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
//	for (int i = 0; i < numberOfFaces; i++)
//	{
//		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, &faces[i]); 
//	}
	for (OpenGLWaveFrontGroup *group in groups)
	{
		Color3D ambient = group.material.ambient;
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, (const GLfloat *)&ambient);
		
		Color3D diffuse = group.material.diffuse;
		glColor4f(diffuse.red, diffuse.green, diffuse.blue, diffuse.alpha);
		glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE,  (const GLfloat *)&diffuse);
		
		Color3D specular = group.material.specular;
		glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, (const GLfloat *)&specular);
		
		glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, group.material.shininess);
		for (int i=0; i < group.numberOfFaces; i++)
		{
			glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_SHORT, &(group.faces[i]));
		}
	}
	
	glDisableClientState(GL_VERTEX_ARRAY);
	
	// Restore the current transformation by popping it off
	glPopMatrix();
}
- (void)dealloc
{
	[materials release];
	[groups release];
	[sourceObjFilePath release];
	[sourceMtlFilePath release];
	if (vertices)
		free(vertices);
	if (faces)
		free(faces);
	if (normals)
		free(normals);
	[super dealloc];
}
@end
