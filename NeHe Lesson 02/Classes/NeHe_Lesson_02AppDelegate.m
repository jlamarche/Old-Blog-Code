//
//  NeHe_Lesson_02AppDelegate.m
//  NeHe Lesson 02
//
//  Created by Jeff LaMarche on 12/11/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

// This is a port of the code from
// http://nehe.gamedev.net/data/lessons/lesson.asp?lesson=02
//
// Because OpenGL ES doesn't support glBegin or glEnd, this code
// uses vertex arrays, which the NeHe tutorials don't cover until 
// much later, but we have no choice.

#import "NeHe_Lesson_02AppDelegate.h"
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define kRenderingFrequency 60.0

@implementation NeHe_Lesson_02AppDelegate
@synthesize window;

- (void)drawView:(GLView*)view;
{
	const GLfloat triVertices[] = { 
		0.0f, 1.0f, 0.0f, 
		-1.0f, -1.0f, 0.0f, 
		1.0f, -1.0f, 0.0f 
	}; 
	const GLfloat quadVertices[] = {
		-1.0f,  1.0f, 0.0f,
		1.0f,  1.0f, 0.0f,
		1.0f, -1.0f, 0.0f,
		-1.0f, -1.0f, 0.0f
		
	};
	glClear(GL_COLOR_BUFFER_BIT); 
	glLoadIdentity(); 
	glTranslatef(-2.0f,1.0f,-6.0f);
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, triVertices); 
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 3); 
	glTranslatef(4.0f, 0.0f, 0.0f);
	glVertexPointer(3, GL_FLOAT, 0, quadVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4); 
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
- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	CGRect	rect = [[UIScreen mainScreen] bounds];
	
	window = [[UIWindow alloc] initWithFrame:rect];
	
	GLView *glView = [[GLView alloc] initWithFrame:rect];
	[window addSubview:glView];

	glView.delegate = self;
	glView.animationInterval = 1.0 / kRenderingFrequency;
	[glView startAnimation];
	[glView release];
	
	[window makeKeyAndVisible];
	

}

- (void)dealloc
{
	[window release];
	[super dealloc];
}
@end
