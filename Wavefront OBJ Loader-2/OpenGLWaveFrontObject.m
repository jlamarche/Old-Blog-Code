//
//  OpenGLWaveFrontObject.m
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright 2008 Jeff LaMarche. All rights reserved.
//
// This file will load certain .obj files into memory and display them in OpenGL ES.
// Because of limitations of OpenGL ES, not all .obj files can be loaded - faces larger
// than triangles cannot be handled, so files must be exported with only triangles.


#import "OpenGLWaveFrontObject.h"
#import "ConstantsAndMacros.h"
#import "OpenGLWaveFrontGroup.h"


@interface OpenGLWaveFrontObject (private)
//- (void)calculateVertexNormals;
//- (void)calculateSurfaceNormals;
- (void)calculateNormals;
@end

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
		NSUInteger vertexCount = 0, faceCount = 0, textureCoordsCount=0, materialCount = 1, groupCount = 0;
		// Iterate through file once to discover how many vertices, normals, and faces there are
		NSArray *lines = [objData componentsSeparatedByString:@"\n"];
		for (NSString * line in lines)
		{
			if ([line hasPrefix:@"v "])
				vertexCount++;
			//			else if ([line hasPrefix:@"vn "])
			//				normalCount++;
			else if ([line hasPrefix:@"vt "])
				textureCoordsCount++;
//			else if ([line hasPrefix:@"vn "])
//				normalCount++;
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
		NSLog(@"Vertices: %d, Faces: %d, Texture Coords: %d, Materials: %d, Groups: %d", vertexCount, faceCount, textureCoordsCount, materialCount, groupCount);
		vertices = malloc(sizeof(Vertex3D) * vertexCount);
		//textureCoords = malloc(sizeof(Vertex3D) * textureCoordsCount);

		// Store the counts
		numberOfFaces = faceCount;
		//numberOfNormals = normalCount;
		numberOfVertices = vertexCount;
		numberOfTextureCoords = textureCoordsCount;
		
		NSUInteger groupFaceCount = 0;
		// Reuse our count variables for second time through
		vertexCount = 0;
		faceCount = 0;
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
			else if ([line hasPrefix: @"vt "])
			{
				NSString *lineTrunc = [line substringFromIndex:2];
				NSArray *lineCoords = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				textureCoords[vertexCount].x = [[lineCoords objectAtIndex:0] floatValue];
				textureCoords[vertexCount].y = [[lineCoords objectAtIndex:1] floatValue];
				textureCoords[vertexCount].z = [[lineCoords objectAtIndex:2] floatValue];
				// Ignore weight if it exists..
				textureCoordsCount++;
			}
			else if ([line hasPrefix:@"g "])
			{
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
														 hasTextureCoords:(numberOfTextureCoords > 0) 
																 material:material];
				[groups addObject:currentGroup];
				[currentGroup release];
				groupFaceCount = 0;
			}
			
			
			else if ([line hasPrefix:@"f "])
			{
				NSString *lineTrunc = [line substringFromIndex:2];
				NSArray *faceIndexGroups = [lineTrunc componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				
				// If no groups in file, create one group that has all the vertices and uses the default material
				if (currentGroup == nil)
				{
					currentGroup = [[OpenGLWaveFrontGroup alloc] initWithName:@"default" 
																numberOfFaces:numberOfFaces 
															 hasTextureCoords:(numberOfTextureCoords > 0) 
																	 material:[OpenGLWaveFrontMaterial defaultMaterial]];
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
				currentGroup.faces[groupFaceCount].v1 =  [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;

			
				oneFaceGroup = [faceIndexGroups objectAtIndex:1];
				groupParts = [oneFaceGroup componentsSeparatedByString:@"/"];
				currentGroup.faces[groupFaceCount].v2 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;	
				oneFaceGroup = [faceIndexGroups objectAtIndex:2];
				groupParts = [oneFaceGroup componentsSeparatedByString:@"/"];
				currentGroup.faces[groupFaceCount].v3 = [[groupParts objectAtIndex:kGroupIndexVertex] intValue]-1;
				
				faceCount++;
				groupFaceCount++;
			}
			lineNum++;
		}
		[self calculateNormals];

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
	glEnableClientState(GL_NORMAL_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, vertices); 
	glNormalPointer(GL_FLOAT, 0, vertexNormals);
	// Loop through each group
	for (OpenGLWaveFrontGroup *group in groups)
	{
		// Set color and materials based on group's material
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
	glDisableClientState(GL_NORMAL_ARRAY);
	// Restore the current transformation by popping it off
	glPopMatrix();
}

- (void)calculateNormals
{
	if (surfaceNormals)
		free(surfaceNormals);	
	
	// Calculate surface normals and keep running sum of vertex normals
	surfaceNormals = calloc(numberOfFaces, sizeof(Vector3D));
	vertexNormals = calloc(numberOfVertices, sizeof(Vector3D));

	NSUInteger index = 0;
	NSUInteger *facesUsedIn = calloc(numberOfVertices, sizeof(NSUInteger)); // Keeps track of how many triangles any given vertex is used in
	for (int i = 0; i < [groups count]; i++)
	{
		OpenGLWaveFrontGroup *oneGroup = [groups objectAtIndex:i];
		for (int j = 0; j < oneGroup.numberOfFaces; j++)
		{
			Triangle3D triangle = Triangle3DMake(vertices[oneGroup.faces[j].v1], vertices[oneGroup.faces[j].v2], vertices[oneGroup.faces[j].v3]);
			
			surfaceNormals[index] = Triangle3DCalculateSurfaceNormal(triangle);
			vectorNormalize(&surfaceNormals[index]);
			vertexNormals[oneGroup.faces[j].v1] = Vector3DAdd(surfaceNormals[index], vertexNormals[oneGroup.faces[j].v1]);
			vertexNormals[oneGroup.faces[j].v2] = Vector3DAdd(surfaceNormals[index], vertexNormals[oneGroup.faces[j].v2]);
			vertexNormals[oneGroup.faces[j].v3] = Vector3DAdd(surfaceNormals[index], vertexNormals[oneGroup.faces[j].v3]);
			
			facesUsedIn[oneGroup.faces[j].v1]++;
			facesUsedIn[oneGroup.faces[j].v2]++;
			facesUsedIn[oneGroup.faces[j].v3]++;
			
			
			index++;
		}
	}

	// Loop through vertices again, dividing those that are used in multiple faces by the number of faces they are used in
	for (int i = 0; i < numberOfVertices; i++)
	{
		if (facesUsedIn[i] > 1)
		{
			vertexNormals[i].x /= facesUsedIn[i];
			vertexNormals[i].y /= facesUsedIn[i];
			vertexNormals[i].z /= facesUsedIn[i];
		}
		vectorNormalize(&vertexNormals[i]);
	}
	free(facesUsedIn);
}
- (void)dealloc
{
	[materials release];
	[groups release];
	[sourceObjFilePath release];
	[sourceMtlFilePath release];
	if (vertices)
		free(vertices);
	if (surfaceNormals)
		free(surfaceNormals);
	if (vertexNormals)
		free(vertexNormals);
	if (textureCoords)
		free(textureCoords);
	[super dealloc];
}
@end
