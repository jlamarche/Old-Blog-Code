//
//  GLViewController.m
//  ExportTest
//
//  Created by jeff on 6/24/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
#import "OpenGLTexture3D.h"
#import "cube.h"

@implementation GLViewController
@synthesize texture;
- (void)drawView:(UIView *)theView
{
    static GLfloat  rot = 0.0;
    
    glColor4f(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    
    [texture bind];
    glLoadIdentity();
    glTranslatef(0.0, 0.0, -5.0);
    glRotatef(rot, 1.0, 1.0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, CubeVertices);
    glNormalPointer(GL_FLOAT, 0, CubeNormals);
    glTexCoordPointer(2, GL_FLOAT, 0, CubeTexCoords);
    glDrawArrays(GL_TRIANGLES, 0, kCubeNumberOfVertices);
    //glDrawElements(GL_TRIANGLES, kCubeNumberOfVertices, GL_FLOAT, CubeFaces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);
    
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
	
    
    // Enable lighting
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.4, 0.4, 0.4, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.7, 0.7, 0.7, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const Color3D light0Specular[] = {{0.7, 0.7, 0.7, 1.0}};
    glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
    
    // Define the position of the first light
    // const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    static const Vertex3D light0Position[] = {{5.0, 5.0, 5.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
	
    // Calculate light vector so it points at the object
    static const Vertex3D objectPoint[] = {{0.0, 0.0, -5.0}};
    const Vertex3D lightVector = Vector3DMakeWithStartAndEndPoints(light0Position[0], objectPoint[0]);
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, (GLfloat *)&lightVector);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cubeimage" ofType:@"jpg"];
    OpenGLTexture3D *newTexture = [[OpenGLTexture3D alloc] initWithFilename:path width:512 height:512];
    self.texture = newTexture;
    [newTexture release];
    
	glLoadIdentity(); 
}
- (void)dealloc 
{
    [super dealloc];
    [texture release];
}
@end
