//
//  GLViewController.h
//  Part2Project
//
//  Created by jeff on 4/30/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
#import "OpenGLCommon.h"
#import "ConstantsAndMacros.h"

@implementation GLViewController
- (void)drawView:(GLView*)view;
{
    
    static GLfloat rot = 0.0;
    
    // This is the same result as using Vertex3D, just faster to type and
    // can be made const this way
    static const Vertex3D vertices[]= {
        {0, -0.525731, 0.850651},             // vertices[0]
        {0.850651, 0, 0.525731},              // vertices[1]
        {0.850651, 0, -0.525731},             // vertices[2]
        {-0.850651, 0, -0.525731},            // vertices[3]
        {-0.850651, 0, 0.525731},             // vertices[4]
        {-0.525731, 0.850651, 0},             // vertices[5]
        {0.525731, 0.850651, 0},              // vertices[6]
        {0.525731, -0.850651, 0},             // vertices[7]
        {-0.525731, -0.850651, 0},            // vertices[8]
        {0, -0.525731, -0.850651},            // vertices[9]
        {0, 0.525731, -0.850651},             // vertices[10]
        {0, 0.525731, 0.850651}               // vertices[11]
    };
    
    static const Color3D colors[] = {
        {1.0, 0.0, 0.0, 1.0},
        {1.0, 0.5, 0.0, 1.0},
        {1.0, 1.0, 0.0, 1.0},
        {0.5, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.0, 1.0},
        {0.0, 1.0, 0.5, 1.0},
        {0.0, 1.0, 1.0, 1.0},
        {0.0, 0.5, 1.0, 1.0},
        {0.0, 0.0, 1.0, 1.0},
        {0.5, 0.0, 1.0, 1.0},
        {1.0, 0.0, 1.0, 1.0},
        {1.0, 0.0, 0.5, 1.0}
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
    
    static const Vector3D normals[] = {
        {0.000000, -0.417775, 0.675974},
        {0.675973, 0.000000, 0.417775},
        {0.675973, -0.000000, -0.417775},
        {-0.675973, 0.000000, -0.417775},
        {-0.675973, -0.000000, 0.417775},
        {-0.417775, 0.675974, 0.000000},
        {0.417775, 0.675973, -0.000000},
        {0.417775, -0.675974, 0.000000},
        {-0.417775, -0.675974, 0.000000},
        {0.000000, -0.417775, -0.675973},
        {0.000000, 0.417775, -0.675974},
        {0.000000, 0.417775, 0.675973},
    };
    
    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);  
    glRotatef(rot,1.0f,1.0f,1.0f);
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnable(GL_COLOR_MATERIAL);
    glEnableClientState(GL_NORMAL_ARRAY);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    glNormalPointer(GL_FLOAT, 0, normals);
    glDrawElements(GL_TRIANGLES, 60, GL_UNSIGNED_BYTE, icosahedronFaces);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisable(GL_COLOR_MATERIAL);
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
    const GLfloat light0Ambient[] = {0.1, 0.1, 0.1, 1.0};
	glLightfv(GL_LIGHT0, GL_AMBIENT, light0Ambient);
    
    // Define the diffuse component of the first light
    const GLfloat light0Diffuse[] = {0.7, 0.7, 0.7, 1.0};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, light0Diffuse);
    
    // Define the specular component and shininess of the first light
    const GLfloat light0Specular[] = {0.7, 0.7, 0.7, 1.0};
    const GLfloat light0Shininess = 0.4;
    glLightfv(GL_LIGHT0, GL_SPECULAR, light0Specular);
    glLightfv(GL_LIGHT0, GL_SHININESS, &light0Shininess);
    
    // Define the position of the first light
    const GLfloat light0Position[] = {0.0, 10.0, 10.0, 0.0}; 
	glLightfv(GL_LIGHT0, GL_POSITION, light0Position); 
	
    // Define a direction vector for the light, this one points right down the Z axis
    const GLfloat light0Direction[] = {0.0, 0.0, -1.0};
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light0Direction);

    // Define a cutoff angle. This defines a 90° field of vision, since the cutoff
    // is number of degrees to each side of an imaginary line drawn from the light's
    // position along the vector supplied in GL_SPOT_DIRECTION above
    glLightf(GL_LIGHT0, GL_SPOT_CUTOFF, 45.0);
    
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 
}
@end
