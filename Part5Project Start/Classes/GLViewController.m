//
//  GLViewController.h
//  Part5Project
//
//  Created by jeff on 5/4/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
#import "ConstantsAndMacros.h"


                                                            // =========================================================
void getSolidSphere(Vertex3D **triangleStripVertexHandle,   // Will hold vertices to be drawn as a triangle strip. 
                                                            //      Calling code responsible for freeing if not NULL
                    Vector3D **triangleStripNormalHandle,   // Will hold normals for vertices to be drawn as triangle 
                                                            //      strip. Calling code is responsible for freeing if 
                                                            //      not NULL
                    GLuint *triangleStripVertexCount,       // On return, will hold the number of vertices contained in
                                                            //      triangleStripVertices
                                                            // =========================================================
                    Vertex3D **triangleFanVertexHandle,     // Will hold vertices to be drawn as a triangle fan. Calling
                                                            //      code responsible for freeing if not NULL
                    Vector3D **triangleFanNormalHandle,     // Will hold normals for vertices to be drawn as triangle 
                                                            //      strip. Calling code is responsible for freeing if 
                                                            //      not NULL
                    GLuint *triangleFanVertexCount,         // On return, will hold the number of vertices contained in
                                                            //      the triangleFanVertices
                                                            // =========================================================
                    GLfloat radius,                         // The radius of the circle to be drawn
                    GLuint slices,                          // The number of slices, determines vertical "resolution"
                    GLuint stacks)                          // the number of stacks, determines horizontal "resolution"
                                                            // =========================================================
{
    
    GLfloat rho, drho, theta, dtheta;
    GLfloat x, y, z;
    GLfloat s, ds;
    GLfloat nsign;
    drho = M_PI / (GLfloat) stacks;
    dtheta = 2.0 * M_PI / (GLfloat) slices;
    
    Vertex3D *triangleStripVertices, *triangleFanVertices;
    Vector3D *triangleStripNormals, *triangleFanNormals;
    
    // Calculate the Triangle Fan for the endcaps
    *triangleFanVertexCount = slices+2;
    triangleFanVertices = calloc(*triangleFanVertexCount, sizeof(Vertex3D));
    triangleFanVertices[0].x = 0.0;
    triangleFanVertices[0].y = 0.0; 
    triangleFanVertices[0].z = nsign * radius;
    int counter = 1;
    for (int j = 0; j <= slices; j++) 
    {
        theta = (j == slices) ? 0.0 : j * dtheta;
        x = -sin(theta) * sin(drho);
        y = cos(theta) * sin(drho);
        z = nsign * cos(drho);
        triangleFanVertices[counter].x = x * radius;
        triangleFanVertices[counter].y = y * radius;
        triangleFanVertices[counter++].z = z * radius;
    }
    
    
    // Normals for a sphere around the origin are darn easy - just treat the vertex as a vector and normalize it.
    triangleFanNormals = malloc(*triangleFanVertexCount * sizeof(Vertex3D));
    memcpy(triangleFanNormals, triangleFanVertices, *triangleFanVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleFanVertexCount; i++)
        Vector3DNormalize(&triangleFanNormals[i]);
    
    // Calculate the triangle strip for the sphere body
    *triangleStripVertexCount = (slices + 1) * 2 * stacks;
    triangleStripVertices = calloc(*triangleStripVertexCount, sizeof(Vertex3D));
    counter = 0;
    for (int i = 0; i < stacks; i++) {
        rho = i * drho;

        s = 0.0;
        for (int j = 0; j <= slices; j++) 
        {
            theta = (j == slices) ? 0.0 : j * dtheta;
            x = -sin(theta) * sin(rho);
            y = cos(theta) * sin(rho);
            z = nsign * cos(rho);
            // TODO: Implement texture mapping if texture used
            //                TXTR_COORD(s, t);
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
            x = -sin(theta) * sin(rho + drho);
            y = cos(theta) * sin(rho + drho);
            z = nsign * cos(rho + drho);
            //                TXTR_COORD(s, t - dt);
            s += ds;
            triangleStripVertices[counter].x = x * radius;
            triangleStripVertices[counter].y = y * radius;
            triangleStripVertices[counter++].z = z * radius;
        }
    }
    
    triangleStripNormals = malloc(*triangleStripVertexCount * sizeof(Vertex3D));
    memcpy(triangleStripNormals, triangleStripVertices, *triangleStripVertexCount * sizeof(Vertex3D));
    for (int i = 0; i < *triangleStripVertexCount; i++)
            Vector3DNormalize(&triangleStripNormals[i]);
    
    *triangleStripVertexHandle = triangleStripVertices;
    *triangleStripNormalHandle = triangleStripNormals;
    *triangleFanVertexHandle = triangleFanVertices;
    *triangleFanNormalHandle = triangleFanNormals;
}
    


@implementation GLViewController
- (void)drawView:(GLView*)view;
{
    
    static GLfloat rot = 0.0;

    glLoadIdentity();
    glTranslatef(0.0f,0.0f,-3.0f);  
    glRotatef(rot,1.0f,1.0f,1.0f);
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, sphereTriangleFanVertices);
    glNormalPointer(GL_FLOAT, 0, sphereTriangleFanNormals);
    glDrawArrays(GL_TRIANGLE_FAN, 0, sphereTriangleFanVertexCount);
    
    glVertexPointer(3, GL_FLOAT, 0, sphereTriangleStripVertices);
    glNormalPointer(GL_FLOAT, 0, sphereTriangleStripNormals);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, sphereTriangleStripVertexCount);
    
    glDisableClientState(GL_VERTEX_ARRAY);
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
    glShadeModel(GL_SMOOTH);
    // Enable lighting
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.2, 0.2, 0.2, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.8, 0.8, 0.8, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const Color3D light0Specular[] = {{0.6, 0.6, 0.6, 1.0}};
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
    
    getSolidSphere(&sphereTriangleStripVertices, &sphereTriangleStripNormals, &sphereTriangleStripVertexCount, &sphereTriangleFanVertices, &sphereTriangleFanNormals, &sphereTriangleFanVertexCount, 1.0, 50, 50);
}
- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
    if(sphereTriangleStripVertices)
        free(sphereTriangleStripVertices);
    if (sphereTriangleStripNormals)
        free(sphereTriangleStripNormals);
    
    if (sphereTriangleFanVertices)
        free(sphereTriangleFanVertices);
    if (sphereTriangleFanNormals)
        free(sphereTriangleFanNormals);
    
    [super dealloc];
}

@end
