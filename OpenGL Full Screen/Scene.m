/*
 Scene.m
 A delegate object used by MyOpenGLView and MainController to render a simple scene.

 Troy Stephens

 Copyright (c) 2003, Apple Computer, Inc., all rights reserved.
*/
/*
 IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc. ("Apple") in
 consideration of your agreement to the following terms, and your use, installation, 
 modification or redistribution of this Apple software constitutes acceptance of these 
 terms.  If you do not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject to these 
 terms, Apple grants you a personal, non-exclusive license, under Apple’s copyrights in 
 this original Apple software (the "Apple Software"), to use, reproduce, modify and 
 redistribute the Apple Software, with or without modifications, in source and/or binary 
 forms; provided that if you redistribute the Apple Software in its entirety and without 
 modifications, you must retain this notice and the following text and disclaimers in all 
 such redistributions of the Apple Software.  Neither the name, trademarks, service marks 
 or logos of Apple Computer, Inc. may be used to endorse or promote products derived from 
 the Apple Software without specific prior written permission from Apple. Except as expressly
 stated in this notice, no other rights or licenses, express or implied, are granted by Apple
 herein, including but not limited to any patent rights that may be infringed by your 
 derivative works or by other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO WARRANTIES, 
 EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, 
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS 
 USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, 
 REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND 
 WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR 
 OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "Scene.h"
#import "Texturing.h"
#import <OpenGL/glu.h>

static double dtor( double degrees )
{
    return degrees * M_PI / 180.0;
}

@implementation Scene

- init
{
    self = [super init];
    if (self) {
        NSImage *textureImage = [NSImage imageNamed:@"Earth.png"];
        if (textureImage) {
            NSImageRep *imageRep = [textureImage bestRepresentationForRect:[[NSScreen mainScreen] frame] context:[NSGraphicsContext currentContext] hints:nil];
            //            NSImageRep *imageRep = [textureImage bestRepresentationForDevice:nil];
            if ([imageRep isKindOfClass:[NSBitmapImageRep class]]) {
                textureBitmapImageRep = (NSBitmapImageRep *)[imageRep retain];
            }
        }
        textureName = 0;
        animationPhase = 0.0;
        rollAngle = 0.0;
        sunAngle = 135.0;
        wireframe = NO;
    }
    return self;
}

- (void)dealloc
{
    [textureBitmapImageRep release];
    [super dealloc];
}

- (float)rollAngle
{
    return rollAngle;
}

- (void)setRollAngle:(float)newRollAngle
{
    rollAngle = newRollAngle;
}

- (float)sunAngle
{
    return sunAngle;
}

- (void)setSunAngle:(float)newSunAngle
{
    sunAngle = newSunAngle;
}

- (void)advanceTimeBy:(float)seconds
{
    float phaseDelta = seconds - floor(seconds);
    float newAnimationPhase = animationPhase + 0.015625 * phaseDelta;
    newAnimationPhase = newAnimationPhase - floor(newAnimationPhase);
    [self setAnimationPhase:newAnimationPhase];
}

- (void)setAnimationPhase:(float)newAnimationPhase
{
    animationPhase = newAnimationPhase;
}

- (void)toggleWireframe
{
    wireframe = !wireframe;
}

- (void)setViewportRect:(NSRect)bounds
{
    glViewport( bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);

    glMatrixMode( GL_PROJECTION );
    glLoadIdentity();
    gluPerspective( 30, bounds.size.width / bounds.size.height, 1.0, 1000.0 );

    glMatrixMode( GL_MODELVIEW );
    glLoadIdentity();
}

// This method renders our scene.  We could optimize it in any of several ways, including factoring out the repeated OpenGL initialization calls and either hanging onto the GLU quadric object or creating a display list thet draws the Earth, but the details of how it's implemented aren't important here.  The main thing to note is that we've factored our drawing code out of our NSOpenGLView subclass to enable MainController to use it when rendering in FullScreen mode.
- (void)render
{
    static GLfloat lightDirection[] = { -0.7071, 0.0, 0.7071, 0.0 };
    static GLfloat radius = 0.25;
    static GLfloat materialAmbient[4] = { 0.0, 0.0, 0.0, 0.0 };
    static GLfloat materialDiffuse[4] = { 1.0, 1.0, 1.0, 1.0 };
    GLUquadric *quadric = NULL;

    // Set up rendering state.
    glEnable( GL_DEPTH_TEST );
    glEnable( GL_CULL_FACE );
    glEnable( GL_LIGHTING );
    glEnable( GL_LIGHT0 );

    // Upload the texture.  Since we are sharing OpenGL object between our FullScreen and non-FullScreen contexts, we only need to do this once.
    if (textureName == 0) {
        glGenTextures( 1, &textureName );
        [textureBitmapImageRep uploadAsOpenGLTexture:textureName];
    }

    // Set up texturing parameters.
    glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
    glEnable( GL_TEXTURE_2D );
    glBindTexture( GL_TEXTURE_2D, textureName );

    // Clear the framebuffer.
    glClearColor( 0, 0, 0, 0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    glPushMatrix();
    
        // Set up our single directional light (the Sun!).
        lightDirection[0] = cos(dtor(sunAngle));
        lightDirection[2] = sin(dtor(sunAngle));
        glLightfv( GL_LIGHT0, GL_POSITION, lightDirection );

        // Back the camera off a bit.
        glTranslatef( 0.0, 0.0, -1.5 );
        
        // Draw the Earth!
        quadric = gluNewQuadric();
        if (wireframe) {
            gluQuadricDrawStyle( quadric, GLU_LINE );
        }
        gluQuadricTexture( quadric, GL_TRUE );
        glMaterialfv( GL_FRONT, GL_AMBIENT, materialAmbient );
        glMaterialfv( GL_FRONT, GL_DIFFUSE, materialDiffuse );
        glRotatef( rollAngle, 1.0, 0.0, 0.0 );
        glRotatef( -23.45, 0.0, 0.0, 1.0 ); // Earth's axial tilt is 23.45 degrees from the plane of the ecliptic.
        glRotatef( animationPhase * 360.0, 0.0, 1.0, 0.0 );
        glRotatef( 90.0, 1.0, 0.0, 0.0 );
        gluSphere( quadric, radius, 48, 24 );
        gluDeleteQuadric(quadric);
        quadric = NULL;

    glPopMatrix();
    
    // Flush out any unfinished rendering before swapping.
    glFinish();
}

@end
