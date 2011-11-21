//
//  GLViewController.m
//  Face
//
//  Created by jeff on 9/20/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "GLViewController.h"
#import "GLView.h"
#import "NSColor-Random.h"

@interface GLViewController ()
- (void) startAnimation;
- (void) stopAnimation;
- (void) toggleAnimation;

- (void) startAnimationTimer;
- (void) stopAnimationTimer;
- (void) animationTimerFired:(NSTimer *)timer;
@end


@implementation GLViewController
@synthesize window, glView, timer, animating, fullScreenOptions, rotSpeed;
#pragma mark -
- (NSDictionary *)fullScreenOptions 
{       
    static NSDictionary *opts = nil;
    if (opts == nil)
        opts = [[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSFullScreenModeSetting] retain];
    return opts;
}
- (IBAction) toggleFullScreen:(id)sender
{
    if (![self.glView isInFullScreenMode]) 
        [self.glView enterFullScreenMode:[self.window screen] withOptions:self.fullScreenOptions];
    else 
        [self.glView exitFullScreenModeWithOptions:self.fullScreenOptions];
    

}
#pragma mark -
- (void)awakeFromNib
{
    self.rotSpeed = 1.0;
    [self startAnimation];
}
- (BOOL) acceptsFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark Key Events
- (void) keyDown:(NSEvent *)event
{
    unichar c = [[event charactersIgnoringModifiers] characterAtIndex:0];
    switch (c) {
        case NSUpArrowFunctionKey:
        case NSRightArrowFunctionKey:
            self.rotSpeed = self.rotSpeed + 0.5;
            break;
        case NSDownArrowFunctionKey:
        case NSLeftArrowFunctionKey:
            self.rotSpeed = self.rotSpeed - 0.5;
            break;
            
            // escape
        case 27: 
            break;
            // [space]
        case 32:
            [self toggleAnimation];
            break;
        default:
            break;
    }
}
#pragma mark -
#pragma mark Animation Methods
- (void) startAnimation
{
    if (!self.animating)
    {    
        self.animating = YES;
        [self startAnimationTimer];
    }
   
}
- (void) stopAnimation
{
    if (self.animating) {
        if (timer != nil) {
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
    if (self.timer == nil) {
        self.timer = [[NSTimer scheduledTimerWithTimeInterval:1.0/kAttemptedUpdatesPerSecond target:self selector:@selector(animationTimerFired:) userInfo:nil repeats:YES] retain];
    }
}
- (void) stopAnimationTimer
{
    if (self.timer != nil) {
        [self.timer invalidate];
        [self.timer release];
        self.timer = nil;
    }
}
- (void) animationTimerFired:(NSTimer *)timer
{
    [glView setNeedsDisplay:YES];
}
@end
