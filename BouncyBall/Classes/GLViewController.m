//
//  GLViewController.m
//  BouncyBall
//
//  Created by jeff on 12/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"
#import "ball1.h"
#import "ball2.h"

@implementation GLViewController
- (void)drawView:(UIView *)theView
{
    static NSTimeInterval lastKeyframeTime = 0.0;
    if (lastKeyframeTime == 0.0) 
        lastKeyframeTime = [NSDate timeIntervalSinceReferenceDate];
    static AnimationDirection direction = kAnimationDirectionForward;
    
    glClearColor(1.0, 1.0, 1.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    glTranslatef(0.0f,2.2f,-6.0f);
    glRotatef(-90.0, 1.0, 0.0, 0.0); // Blender uses Z-up, not Y-up like OpenGL ES
    
    static VertexData3D ballVertexData[kBall1NumberOfVertices];
    
    glColor4f(0.0, 0.3, 1.0, 1.0);
    glEnable(GL_COLOR_MATERIAL);
    NSTimeInterval timeSinceLastKeyFrame = [NSDate timeIntervalSinceReferenceDate] - lastKeyframeTime;
    if (timeSinceLastKeyFrame > kAnimationDuration) {
        direction = !direction;
        timeSinceLastKeyFrame = timeSinceLastKeyFrame - kAnimationDuration;
        lastKeyframeTime = [NSDate timeIntervalSinceReferenceDate];
    }
    NSTimeInterval percentDone = timeSinceLastKeyFrame / kAnimationDuration;
    
    VertexData3D *source, *dest;
    if (direction == kAnimationDirectionForward)
    {
        source = (VertexData3D *)Ball1VertexData;
        dest = (VertexData3D *)Ball2VertexData;
    }
    else 
    {
        source = (VertexData3D *)Ball2VertexData;
        dest = (VertexData3D *)Ball1VertexData;
    }
    
    for (int i = 0; i < kBall1NumberOfVertices; i++) 
    {
        GLfloat diffX = dest[i].vertex.x - source[i].vertex.x;
        GLfloat diffY = dest[i].vertex.y - source[i].vertex.y;
        GLfloat diffZ = dest[i].vertex.z - source[i].vertex.z;
        GLfloat diffNormalX = dest[i].normal.x - source[i].normal.x;
        GLfloat diffNormalY = dest[i].normal.y - source[i].normal.y;
        GLfloat diffNormalZ = dest[i].normal.z - source[i].normal.z;
        
        ballVertexData[i].vertex.x = source[i].vertex.x + (percentDone * diffX);
        ballVertexData[i].vertex.y = source[i].vertex.y + (percentDone * diffY);
        ballVertexData[i].vertex.z = source[i].vertex.z + (percentDone * diffZ);
        ballVertexData[i].normal.x = source[i].normal.x + (percentDone * diffNormalX);
        ballVertexData[i].normal.y = source[i].normal.y + (percentDone * diffNormalY);
        ballVertexData[i].normal.z = source[i].normal.z + (percentDone * diffNormalZ);

    }
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, sizeof(VertexData3D), &ballVertexData[0].vertex);
    glNormalPointer(GL_FLOAT, sizeof(VertexData3D), &ballVertexData[0].normal);
    glDrawArrays(GL_TRIANGLES, 0, kBall1NumberOfVertices);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    
    
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
    static const Color3D light0Ambient[] = {{0.3, 0.3, 0.3, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.4, 0.4, 0.4, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const Color3D light0Specular[] = {{0.7, 0.7, 0.7, 1.0}};
    glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
    
    // Define the position of the first light
    // const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    static const Vertex3D light0Position[] = {{10.0, 10.0, 10.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
	
    // Calculate light vector so it points at the object
    static const Vertex3D objectPoint[] = {{0.0, 0.0, -3.0}};
    const Vertex3D lightVector = Vector3DMakeWithStartAndEndPoints(light0Position[0], objectPoint[0]);
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, (GLfloat *)&lightVector);
    
    // Define a cutoff angle. This defines a 90° field of vision, since the cutoff
    // is number of degrees to each side of an imaginary line drawn from the light's
    // position along the vector supplied in GL_SPOT_DIRECTION above
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 25.0);
    
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 
}
- (void)dealloc 
{
    [super dealloc];
}
@end
