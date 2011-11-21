//
//  GLViewController.h
//  NeHe Lesson 05
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
#import "UIColor-OpenGL.h"
#import "UIColor-Random.h"
#import "Texture2D.h"
@implementation GLViewController
- (void)drawView:(GLView*)view;
{
    
    
    static GLfloat		rico;	
    static const GLfloat icosahedronVertices[]= {
        0, -0.525731, 0.850651,
        0.850651, 0, 0.525731,
        0.850651, 0, -0.525731,
        -0.850651, 0, -0.525731,
        -0.850651, 0, 0.525731,
        -0.525731, 0.850651, 0,
        0.525731, 0.850651, 0,
        0.525731, -0.850651, 0,
        -0.525731, -0.850651, 0,
        0, -0.525731, -0.850651,
        0, 0.525731, -0.850651,
        0, 0.525731, 0.850651,
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
    static const GLubyte icosahedronNumberOfFaces = 60;
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Icosahedron
    glLoadIdentity(); 
    glEnableClientState(GL_VERTEX_ARRAY);
    glTranslatef(0.0f,0.0f,-2.0f);
    glRotatef(rico,1.0f,1.0f,1.0f);
    
    glVertexPointer(3, GL_FLOAT, 0, icosahedronVertices);
    for(int i = 0; i < icosahedronNumberOfFaces; i += 3) 
    { 
        UIColor *oneColor = [colors objectAtIndex:i/3];
        [oneColor setOpenGLColor];
        
        glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &icosahedronFaces[i]);
    } 
    
    glDisableClientState(GL_VERTEX_ARRAY);
    
    static NSTimeInterval lastDrawTime;
    if (lastDrawTime)
    {
        NSTimeInterval timeSinceLastDraw = [NSDate timeIntervalSinceReferenceDate] - lastDrawTime;
        rico+=50 * timeSinceLastDraw;				
    }
    
    // ------------------------------------------------
    // Draw HUD ---------------------------------------
    // ------------------------------------------------
    [self switchToOrtho];
    
    static const GLfloat squareVertices[] = {
        5.0f, 150.0f,
        5.0f, 250.0f,
        100.0f, 250.0f,
        100.0f, 150.0f
    };
	
    glLineWidth(3.0);
    glColor4f(0.0, 0.0, 1.0, 1.0); // blue
    glTranslatef(5.0, 0.0, 0.0);
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);

    glDrawArrays(GL_LINE_LOOP, 0, 4);
    glTranslatef(100.0, 0.0, 0.0);
    glColor4f(1.0, 0.0, 0.0, 1.0);  // Red
    glDrawArrays(GL_LINE_LOOP, 0, 4);
    glTranslatef(100.0, 0.0, 0.0);
    glColor4f(1.0, 1.0, 0.0, 1.0);  // Yellow
    glDrawArrays(GL_LINE_LOOP, 0, 4);
    
    
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc (GL_ONE, GL_ONE);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glColor4f(1.0, 1.0, 1.0, 1.0);
    glLoadIdentity();
    Texture2D *textTex = [[Texture2D alloc] initWithString:@"Text" 
                                                dimensions:CGSizeMake(100., 40.0) 
                                                 alignment:UITextAlignmentCenter 
                                                      font:[UIFont boldSystemFontOfSize:36.0]];
    [textTex drawAtPoint:CGPointMake(160.0, 440.0) depth:-1];
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    [self switchBackToFrustum];
    
    lastDrawTime = [NSDate timeIntervalSinceReferenceDate];
}
-(void)switchBackToFrustum 
{
    glEnable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);			
	glPopMatrix();							
	glMatrixMode(GL_MODELVIEW);			
}
-(void)switchToOrtho 
{
    glDisable(GL_DEPTH_TEST);
    glMatrixMode(GL_PROJECTION);			
	glPushMatrix();							
	glLoadIdentity();						
	glOrthof(0, self.view.bounds.size.width, 0, self.view.bounds.size.height, -5, 1);		
	glMatrixMode(GL_MODELVIEW);										
    glLoadIdentity();		
}
-(void)setupView:(GLView*)view
{
    GLfloat size; 
    const GLfloat zNear = 0.1, 
    zFar = 1000.0, 
    fieldOfView = 60.0;
    size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
    CGRect rect = self.view.bounds; 
    glMatrixMode(GL_PROJECTION);
    glEnable(GL_DEPTH_TEST);
    glDepthMask(GL_TRUE);
    glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
               (rect.size.width / rect.size.height), zNear, zFar); 
    
    glViewport(0, 0, rect.size.width, rect.size.height); 
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity(); 
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 
    colors = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i =0; i < 20; i++)
        [colors addObject:[UIColor randomColor]];
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
