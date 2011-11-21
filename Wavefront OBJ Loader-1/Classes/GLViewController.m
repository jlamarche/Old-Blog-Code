//
//  GLViewController.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
@implementation GLViewController
@synthesize plane;
@synthesize cylinder;
@synthesize cube;
- (void)drawView:(GLView*)view;
{
	static GLfloat rotation = 0.0;
	
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glLoadIdentity(); 
	glColor4f(0.0, 0.5, 1.0, 1.0);
	[plane drawSelf];
	
	glColor4f(1.0, 0.6, 0.3, 1.0);
	[cylinder drawSelf];
	
	glColor4f(0.3, 1.0, 0.5, 1.0);
	[cube drawSelf];
	
	static NSTimeInterval lastDrawTime;
	if (lastDrawTime)
	{
		NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
		rotation+=50 * timeSinceLastDraw;				
		Rotation3D rot;
		rot.x = rotation;
		rot.y = rotation;
		rot.z = rotation;
		plane.currentRotation = rot;
		cylinder.currentRotation = rot;
		cube.currentRotation = rot;
	}
	lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

-(void)setupView:(GLView*)view
{
	// Don't want to enable lighting until we get the normals working
//	const GLfloat			lightAmbient[] = {0.2, 0.2, 0.2, 1.0};
//	const GLfloat			lightDiffuse[] = {1.0, 0.6, 0.0, 1.0};
//	const GLfloat			matAmbient[] = {0.6, 0.6, 0.6, 1.0};
//	const GLfloat			matDiffuse[] = {1.0, 1.0, 1.0, 1.0};	
//	const GLfloat			matSpecular[] = {1.0, 1.0, 1.0, 1.0};
//	const GLfloat			lightPosition[] = {0.0, 0.0, 1.0, 0.0}; 
//	const GLfloat			lightShininess = 100.0;
	const GLfloat			zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
//	glEnable(GL_LIGHTING);
//	glEnable(GL_LIGHT0);
//	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, matAmbient);
//	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, matDiffuse);
//	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, matSpecular);
//	glMaterialf(GL_FRONT_AND_BACK, GL_SHININESS, lightShininess);
//	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
//	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
//	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition); 		
	
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 	
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"coloredcube" ofType:@"obj"];
	OpenGLWaveFrontObject *theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	Vertex3D position;

	position.z = -8.0;
	position.y = -3.0;
	position.x = -1.5;
	theObject.currentPosition = position;
	self.cube = theObject;
	[theObject release];
	
	path = [[NSBundle mainBundle] pathForResource:@"plane3" ofType:@"obj"];
	theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	position.z = -8.0;
	position.y = 3.0;
	position.x = 0.0;
	theObject.currentPosition = position;
	self.plane = theObject;
	[theObject release];
	
	

	
	
	path = [[NSBundle mainBundle] pathForResource:@"cylinder2" ofType:@"obj"];
	theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	position.z = -8.0;
	position.y = -0.3;
	position.x = 1.1;
	theObject.currentPosition = position;
	self.cylinder = theObject;
	[theObject release];
	
	
	
}
- (void)didReceiveMemoryWarning 
{
	
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
	[plane release];
	[cylinder release];
	[cube release];
    [super dealloc];
}

@end
