//
//  GLViewController.m
//  Ship
//
//  Created by jeff on 7/17/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
#import "ship.h"
#import "OpenGLTexture3D.h"
@implementation GLViewController
@synthesize texture;
- (void)drawView:(UIView *)theView
{
     static GLfloat  rot = 0.0;
    
    glLoadIdentity();
    glColor4f(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.texture bind];
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnable(GL_BLEND);
    glTranslatef(0.0, 0.0, -15.0);
    glRotatef(rot, 1.0, 1.0, 1.0);
    
    
    glVertexPointer(3, GL_FLOAT, sizeof(TexturedVertexData3D), &CubeVertexData[0].vertex);
    glNormalPointer(GL_FLOAT, sizeof(TexturedVertexData3D), &CubeVertexData[0].normal);
    glTexCoordPointer(2, GL_FLOAT, sizeof(TexturedVertexData3D), &CubeVertexData[0].texCoord);
    glDrawArrays(GL_TRIANGLES, 0, kCubeNumberOfVertices);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=50 * timeSinceLastDraw;  
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
    
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.6, 0.6, 0.6, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.8, 0.8, 0.8, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the position of the first light
    static const Vertex3D light0Position[] = {{0.0, 0.0, 2.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
    
    OpenGLTexture3D *theTexture = [[OpenGLTexture3D alloc] initWithFilename:@"texture.jpg" width:512 height:512];
    self.texture = theTexture;
    [theTexture release];
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
}
- (void)dealloc 
{
    [texture release];
    [super dealloc];
}
@end
