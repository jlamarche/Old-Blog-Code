//
//  GLViewController.h
//  NeHe Lesson 04
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"

@implementation GLViewController
- (void)drawView:(GLView*)view;
{
	static GLfloat		rtri;						// Angle For The Triangle ( NEW )
	static GLfloat		rquad;						// Angle For The Quad     ( NEW )
	
	const GLfloat triVertices[] = { 
		0.0f, 1.0f, 0.0f, 
		-1.0f, -1.0f, 0.0f, 
		1.0f, -1.0f, 0.0f 
	}; 
	const GLfloat triVertexColors[] = {
		1.0f, 0.0f, 0.0f, 1.0f,  // Red
		0.0f, 1.0f, 0.0f, 1.0f,  // Green
		0.0f, 0.0f, 1.0f, 1.0f  // Blue
	};
	const GLfloat quadVertices[] = {
		-1.0f,  1.0f, 0.0f,
		1.0f,  1.0f, 0.0f,
		1.0f, -1.0f, 0.0f,
		-1.0f, -1.0f, 0.0f
		
	};
	glClear(GL_COLOR_BUFFER_BIT);
	
	// Triangle
	glLoadIdentity(); 
	glTranslatef(-2.0f,1.0f,-6.0f);
	glRotatef(rtri,0.0f,1.0f,0.0f);	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState (GL_COLOR_ARRAY);
	glColorPointer (4, GL_FLOAT, 0, triVertexColors);
	glVertexPointer(3, GL_FLOAT, 0, triVertices); 
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
	glDisableClientState (GL_COLOR_ARRAY);
	
	// Square
	glLoadIdentity();
	glColor4f(0.0, 0.0, 1.0, 1.0);
	glTranslatef(2.0f,1.0f,-6.0f);
	glRotatef(rquad,1.0f,0.0f,0.0f);
	glVertexPointer(3, GL_FLOAT, 0, quadVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4); 
	glDisableClientState(GL_VERTEX_ARRAY);
	
	static NSTimeInterval lastDrawTime;
	if (lastDrawTime)
	{
		NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rtri+=20.0 * timeSinceLastDraw;    
		if (rtri > 360.0)
			rtri -= 360.0;
		
		rquad-=15.0 * timeSinceLastDraw; 
		if (rquad < 0.0)
			rquad += 360.0;
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
