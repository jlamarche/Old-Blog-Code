//
//  GLViewController.h
//  NeHe Lesson 05
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"

@implementation GLViewController
- (void)drawView:(GLView*)view;
{
	static GLfloat		rtri;		// Angle For The Triangle ( NEW )
	static GLfloat		rquad;		// Angle For The Quad     ( NEW )
	
	
	static const GLfloat pyramidVertices[] = { 
		0.0f,  1.0f,  0.0f,  
		-1.0f, -1.0f,  1.0f, 
		1.0f, -1.0f,  1.0f,  
		1.0f, -1.0f, -1.0f,  
		-1.0f, -1.0f, -1.0f  
	}; 
	static const GLubyte pyramidVertexFaces[] = { 
		0, 1, 2,  // Defines Front Face 
		0, 3, 2,  // Defines Right Face 
		0, 3, 4,  // Defines Back Face  
		0, 1, 4   // Defines Left Face  
	};
	static const GLubyte triVertexColors[] = { 
		255,   0,   0, 255,  
          0, 255,   0, 255,  
		  0,   0, 255, 255,  
		  0, 255,   0, 255,  
		  0,   0, 255, 255  
	}; 
	static const GLubyte triNumberOfIndices = 12;
	
	static const GLfloat cubeVertices[] = { 
		-1.0f, 1.0f, 1.0f,
		1.0f, 1.0f, 1.0f, 
		1.0f,-1.0f, 1.0f, 
		-1.0f,-1.0f, 1.0f,
		-1.0f, 1.0f,-1.0f,
		1.0f, 1.0f,-1.0f, 
		1.0f,-1.0f,-1.0f, 
		-1.0f,-1.0f,-1.0f 
	};
	static const GLubyte cubeNumberOfIndices = 36;
	
	const GLubyte cubeVertexFaces[] = { 
		
		0, 1, 2, // Half of front face
		0, 3, 2, // Other half of front face		
		
		6, 4, 5, // Half of back face
		6, 7, 4, // Other half of back face
		
		5, 0, 1, // Other half of top face
		5, 4, 0, // Half of top face

		1, 2, 5, // Half of right face
		2, 5, 6, // Other half of right face
		
		0, 3, 4, // Half of left face
		7, 4, 3, // Other half of left face
		
		3, 6, 2, // Half of bottom face
		6, 7, 3, // Other half of bottom face
		
	}; 
	const GLfloat cubeTextureCoords[] = {
		1.0, 1.0, // Front
		0.0, 1.0,
		0.0, 0.0,
		1.0, 0.0,
		
		0.0, 0.0, // Back
		0.0, 1.0,
		1.0, 1.0, 
		1.0, 0.0,
		
		0.0, 0.0, // Top
		1.0, 1.0,
		1.0, 1.0,  
		1.0, 1.0,
		
		0.0, 0.0, // Bottom
		0.0, 1.0,
		1.0, 1.0,  
		1.0, 1.0,
		
		0.0, 0.0, // Left
		1.0, 1.0,
		1.0, 1.0,  
		1.0, 1.0,
		
		0.0, 0.0, // Right
		1.0, 1.0,
		1.0, 1.0,  
		1.0, 1.0,
	};
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Pyramid
	glLoadIdentity(); 
	glTranslatef(-2.0f,1.0f,-6.0f);
	glRotatef(rtri,0.0f,1.0f,0.0f);	 // NEW
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState (GL_COLOR_ARRAY);
	
	glVertexPointer(3, GL_FLOAT, 0, pyramidVertices); 
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, triVertexColors); 
	
	for(int i = 0; i < triNumberOfIndices; i += 3)
	{ 
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &pyramidVertexFaces[i]); 
	}
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	// Quad
	glLoadIdentity();
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glTranslatef(2.0f,1.0f,-6.0f);
	glRotatef(rquad, 1.0f, 1.0f, 1.0f);	
	glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
	glTexCoordPointer(2, GL_FLOAT, 0, cubeTextureCoords);
	for(int i = 0; i < cubeNumberOfIndices; i += 3) 
	{ 
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &cubeVertexFaces[i]);
	} 
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);

	
	static NSTimeInterval lastDrawTime;
	if (lastDrawTime)
	{
		NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rtri+=50 * timeSinceLastDraw;				
		rquad-=70 * timeSinceLastDraw;	
	}
	lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

-(void)setupView:(GLView*)view
{
	const GLfloat zNear = 0.1, 
	zFar = 1000.0, 
	fieldOfView = 60.0; 
	GLfloat size; 
	
	glMatrixMode(GL_PROJECTION); 
	glEnable(GL_DEPTH_TEST); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height); 
	glMatrixMode(GL_MODELVIEW); 
	
	// Begin New for Lesson 06
	
	glShadeModel(GL_SMOOTH);													
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);  
	
	
	glGenTextures(1, &texture[0]);
	glBindTexture(GL_TEXTURE_2D, texture[0]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NeHe" ofType:@"pvr4"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
	// Instead of glTexImage2D, we have to use glCompressedTexImage2D
	glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 256.0, 256.0, 0, (256.0 * 256.0) / 2, [texData bytes]);
	[texData release];
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
	
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);

	// End changes for Lesson 06
	
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
    [super dealloc];
}

@end
