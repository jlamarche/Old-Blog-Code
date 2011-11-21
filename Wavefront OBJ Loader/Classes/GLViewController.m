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
@synthesize cone;
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
	[cone drawSelf];
	
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
		cone.currentRotation = rot;
	}
	lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}

-(void)setupView:(GLView*)view
{
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 

	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"plane" ofType:@"obj"];
	OpenGLWaveFrontObject *theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	Vertex3D position;
	position.z = -8.0;
	position.y = 3.0;
	position.x = 0.0;
	theObject.currentPosition = position;
	self.plane = theObject;
	[theObject release];
	
	
	path = [[NSBundle mainBundle] pathForResource:@"Cylinder" ofType:@"obj"];
	theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	position.z = -8.0;
	position.y = -3.0;
	position.x = -1.5;
	theObject.currentPosition = position;
	self.cylinder = theObject;
	[theObject release];
	
	
	path = [[NSBundle mainBundle] pathForResource:@"cone" ofType:@"obj"];
	theObject = [[OpenGLWaveFrontObject alloc] initWithPath:path];
	position.z = -8.0;
	position.y = -1.0;
	position.x = 1.0;
	theObject.currentPosition = position;
	self.cone = theObject;
	[theObject release];
	
	
	
}
- (void)didReceiveMemoryWarning 
{
	
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
	[plane release];
    [super dealloc];
}

@end
