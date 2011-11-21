//
//  GLViewController.h
//  NeHe Lesson 05
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
#import "UIColor-OpenGL.h"
#import "UIColor-Random.h"

@implementation GLViewController
- (void)drawView:(GLView*)view;
{
	static GLfloat		rico;	
	static const GLfloat icosahedronVertices[]= {
		0, -0.525731, 0.850651,
		0.850651, 0, 0.525731,
		0.850651, 0, -0.525731,
		-0.850651, 0, -0.525731,
		-0.850651, 0, 0.525731,
		-0.525731, 0.850651, 0,
		0.525731, 0.850651, 0,
		0.525731, -0.850651, 0,
		-0.525731, -0.850651, 0,
		0, -0.525731, -0.850651,
		0, 0.525731, -0.850651,
		0, 0.525731, 0.850651,
	};
	static const GLubyte icosahedronFaces[] = {
		1, 2, 6,
		1, 7, 2,
		3, 4, 5,
		4, 3, 8,
		6, 5, 11,
		5, 6, 10,
		9, 10, 2,
		10, 9, 3,
		7, 8, 9,
		8, 7, 0,
		11, 0, 1,
		0, 11, 4,
		6, 2, 10,
		1, 6, 11,
		3, 5, 10,
		5, 4, 11,
		2, 7, 9,
		7, 1, 0,
		3, 9, 8,
		4, 8, 0,
	};
	static const GLubyte icosahedronNumberOfFaces = 60;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Icosahedron
	glLoadIdentity(); 
	glEnableClientState(GL_VERTEX_ARRAY);
	glTranslatef(0.0f,0.0f,-2.0f);
	glRotatef(rico,1.0f,1.0f,1.0f);
	
	glVertexPointer(3, GL_FLOAT, 0, icosahedronVertices);
	for(int i = 0; i < icosahedronNumberOfFaces; i += 3) 
	{ 
		UIColor *oneColor = [colors objectAtIndex:i/3];
		[oneColor setOpenGLColor];
		
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &icosahedronFaces[i]);
	} 
	glDisableClientState(GL_VERTEX_ARRAY);
	
	static NSTimeInterval lastDrawTime;
	if (lastDrawTime)
	{
		NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rico+=50 * timeSinceLastDraw;				
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
	colors = [[NSMutableArray alloc] initWithCapacity:20];
	for (int i =0; i < 20; i++)
		[colors addObject:[UIColor randomColor]];
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
