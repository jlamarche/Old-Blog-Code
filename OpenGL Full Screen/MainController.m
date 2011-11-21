/*
 MainController.m
 A controller object that demonstrates full-screen rendering and interaction using the
 NSOpenGL classes.
 
 Copyright (c) 2003, Apple Computer, Inc., all rights reserved.
 
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

#import "MainController.h"
#import "MyOpenGLView.h"
#import "Scene.h"
#import <OpenGL/OpenGL.h>

@interface MainController (AnimationMethods)
- (void) startAnimation;
- (void) stopAnimation;
- (void) toggleAnimation;

- (void) startAnimationTimer;
- (void) stopAnimationTimer;
- (void) animationTimerFired:(NSTimer *)timer;
@end

@implementation MainController
@synthesize animating, animationTimer, timeBefore, window, openGLView, fullscreenMode, fullScreenOptions;
- (void)bringGLViewToFront 
{
    [openGLView becomeFirstResponder]; 
}
- (void) awakeFromNib
{
    self.animating = NO;
    [self startAnimation];
}
- (IBAction) goFullScreen:(id)sender
{
    [openGLView enterFullScreenMode:[self.window screen] withOptions:self.fullScreenOptions];
    self.fullscreenMode = YES;
}

- (void) keyDown:(NSEvent *)event
{
    Scene *scene = [openGLView scene];
    unichar c = [[event charactersIgnoringModifiers] characterAtIndex:0];
    switch (c) {
        case 27:
            if (self.fullscreenMode) 
            {
                self.fullscreenMode = NO;
                [self.openGLView exitFullScreenModeWithOptions:self.fullScreenOptions];
            
            }
            break;
            // [space] toggles rotation of the globe.
        case 32:
            [self toggleAnimation];
            break;
            
            // [W] toggles wireframe rendering
        case 'w':
        case 'W':
            [scene toggleWireframe];
            break;
            
        default:
            break;
    }
}

// Holding the mouse button and dragging the mouse changes the "roll" angle (y-axis) and the direction from which sunlight is coming (x-axis).
- (void)mouseDown:(NSEvent *)theEvent
{
    Scene *scene = [openGLView scene];
    BOOL wasAnimating = [self isAnimating];
    BOOL dragging = YES;
    NSPoint windowPoint;
    NSPoint lastWindowPoint = [theEvent locationInWindow];
    float dx, dy;
    
    if (wasAnimating) {
        [self stopAnimation];
    }
    while (dragging) {
        theEvent = [self.window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask];
        windowPoint = [theEvent locationInWindow];
        switch ([theEvent type]) {
            case NSLeftMouseUp:
                dragging = NO;
                break;
                
            case NSLeftMouseDragged:
                dx = windowPoint.x - lastWindowPoint.x;
                dy = windowPoint.y - lastWindowPoint.y;
                [scene setSunAngle:[scene sunAngle] - 1.0 * dx];
                [scene setRollAngle:[scene rollAngle] - 0.5 * dy];
                lastWindowPoint = windowPoint;
                
                // Render a frame.
                
                [openGLView display];
                break;
                
            default:
                break;
        }
    }
    if (wasAnimating) {
        [self startAnimation];
        timeBefore = CFAbsoluteTimeGetCurrent();
    }
}
- (NSDictionary *)fullScreenOptions 
{       
    static NSDictionary *opts = nil;
    if (opts == nil)
        opts = [[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSFullScreenModeSetting] retain];
    return opts;
}
@end

@implementation MainController (AnimationMethods)

- (void) startAnimation
{
    if (!self.animating) {
        self.animating = YES;
        if (!self.fullscreenMode) {
            [self startAnimationTimer];
        }
    }
}

- (void) stopAnimation
{
    if (self.animating) {
        if (animationTimer != nil) {
            [self stopAnimationTimer];
        }
        self.animating = NO;
    }
}

- (void) toggleAnimation
{
    if ([self isAnimating]) {
        [self stopAnimation];
    } else {
        [self startAnimation];
    }
}

- (void) startAnimationTimer
{
    if (animationTimer == nil) {
        animationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.017 target:self selector:@selector(animationTimerFired:) userInfo:nil repeats:YES] retain];
    }
}

- (void) stopAnimationTimer
{
    if (animationTimer != nil) {
        [animationTimer invalidate];
        [animationTimer release];
        animationTimer = nil;
    }
}

- (void) animationTimerFired:(NSTimer *)timer
{
    Scene *scene = [openGLView scene];
    [scene advanceTimeBy:0.017];
    [openGLView setNeedsDisplay:YES];
}

@end

