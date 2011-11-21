/*
 MyOpenGLView.m
	An NSOpenGLView subclass that delegates to separate "scene" and "controller" objects for
	OpenGL rendering and input event handling, respectively -- facilitating sharing of this
	functionality by code that renders in FullScreen mode.

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

#import "MyOpenGLView.h"
#import "Scene.h"

@implementation MyOpenGLView

- (id) initWithCoder:(NSCoder *)aDecoder 
{
    if (self = [super initWithCoder:aDecoder])
    {
        if (self) {
            scene = [[Scene alloc] init];
        }
        return self;
    }
    return self;
}
- initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect pixelFormat:[[self class] defaultPixelFormat]];
    if (self) {
        scene = [[Scene alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [scene release];
    [super dealloc];
}

- (Scene *)scene
{
    return scene;
}

- (void) drawRect:(NSRect)aRect
{
    // Delegate to our scene object for rendering.
    [scene render];
    [[self openGLContext] flushBuffer];
}

- (void) reshape
{
    // Delegate to our scene object to update for a change in the view size.
    [scene setViewportRect:[self bounds]];
}

- (BOOL) acceptsFirstResponder
{
    // We want this view to be able to receive key events.
    return YES;
}

- (void) keyDown:(NSEvent *)theEvent
{
    // Delegate to our controller object for handling key events.
    [controller keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    // Delegate to our controller object for handling mouse events.
    [controller mouseDown:theEvent];
}

@end
