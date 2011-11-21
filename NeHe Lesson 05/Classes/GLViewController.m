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
		0, 1, 5, // Half of top face
		0, 5, 4, // Other half of top face
		
		4, 6, 5, // Half of front face
		4, 6, 7,    // Other half of front face
		
		0, 1, 2, // Half of back face
		0, 3, 2, // Other half of back face
		
		1, 2, 5, // Half of right face
		2, 5, 6, // Other half of right face
		
		0, 3, 4, // Half of left face
		7, 4, 3, // Other half of left face
		
		3, 6, 2, // Half of bottom face
		6, 7, 3, // Other half of bottom face
		
	}; 
	const GLubyte cubeFaceColors[] = { 
		0, 255,   0, 255,
		255, 125,   0, 255,
		255,   0,   0, 255,
		255, 255,   0, 255,
		0,   0, 255, 255,
		255,   0, 255, 255
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
	
	glDisableClientState (GL_COLOR_ARRAY);
	
	// Quad
	glLoadIdentity();
	glTranslatef(2.0f,1.0f,-6.0f);
	glRotatef(rquad, 1.0f, 1.0f, 1.0f);	
	glVertexPointer(3, GL_FLOAT, 0, cubeVertices);
	int colorIndex = 0;
	for(int i = 0; i < cubeNumberOfIndices; i += 3) 
	{ 
		glColor4ub(cubeFaceColors[colorIndex], cubeFaceColors[colorIndex+1], cubeFaceColors[colorIndex+2], cubeFaceColors[colorIndex+3]);
		int face = (i / 3.0);
		if (face%2 != 0.0)
			colorIndex+=4;
		
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &cubeVertexFaces[i]);
	} 
	glDisableClientState(GL_VERTEX_ARRAY);
	
	// NEW
	static NSTimeInterval lastDrawTime;
	if (lastDrawTime)
	{
		NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rtri+=50 * timeSinceLastDraw;				
		rquad-=40 * timeSinceLastDraw;	
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
