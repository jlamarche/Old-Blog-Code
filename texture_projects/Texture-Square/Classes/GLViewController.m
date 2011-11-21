//
//  GLViewController.h
//  Texture
//
//  Created by jeff on 5/23/09.
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
    
    
    glColor4f(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    static const Vertex3D vertices[] = {
        {-1.0,  1.0, -0.0},
        { 1.0,  1.0, -0.0},
        {-1.0, -1.0, -0.0},
        { 1.0, -1.0, -0.0}
    };
    
    static const Vector3D normals[] = {
        {0.0, 0.0, 1.0},
        {0.0, 0.0, 1.0},
        {0.0, 0.0, 1.0},
        {0.0, 0.0, 1.0}
    };

    // Feel free to comment these texture coordinates out and use one
    // of the ones below instead, or play around with your own values.
    static const GLfloat texCoords[] = {
        0.0, 0.5,
        0.5, 0.5,
        0.0, 0.0,
        0.5, 0.0
    };

//    static const GLfloat texCoords[] = {
//        0.25, 0.75,
//        0.75, 0.75,
//        0.25, 0.25,
//        0.75, 0.25
//    };
//    
//    static const GLfloat texCoords[] = {
//        0.0, 1.0,
//        1.0, 1.0,
//        0.0, 0.0,
//        1.0, 0.0
//    };
    
    glLoadIdentity();
    glTranslatef(0.0, 0.0, -3.0);
    glRotatef(rot, 1.0, 1.0, 1.0);
    
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glNormalPointer(GL_FLOAT, 0, normals);
    glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rot+=  60 * timeSinceLastDraw;                
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
    
    // Turn necessary features on
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    
    //glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);  
    
    // Bind the number of textures we need, in this case one.
    glGenTextures(1, &texture[0]);
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
    
    
#ifdef USE_PVRTC_TEXTURE    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"pvrtc"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    
	// This assumes that source PVRTC image is 4 bits per pixel and RGB not RGBA
	// If you use the default settings in texturetool, e.g.:
	//
	// 		texturetool -e PVRTC -o texture.pvrtc texture.png
	//
	// then this code should work fine for you. Notice, the source image has had
    // its y-axis inverted to deal with the t-axis inversion issue.
	glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 512, 512, 0, [texData length], [texData bytes]);
#else  
    NSString *path = [[NSBundle mainBundle] pathForResource:@"texture" ofType:@"png"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    
    if (image == nil)
        NSLog(@"Do real error checking here");
    
 	GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc( height * width * 4 );
    CGContextRef context = CGBitmapContextCreate( imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );

    // Flip the Y-axis
    CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
    
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, width, height ) );
    CGContextDrawImage( context, CGRectMake( 0, 0, width, height ), image.CGImage );
   
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);

    CGContextRelease(context);
    
    free(imageData);
    [image release];
    [texData release];
#endif
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.4, 0.4, 0.4, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.8, 0.8, 0.8, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the position of the first light
    // const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    static const Vertex3D light0Position[] = {{10.0, 10.0, 10.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
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
