//
//  NKDMovieFilmstripView.m
//  MovieStepper
//
//  Created by jeff on 5/18/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "NKDMovieFilmstripView.h"
#import "QTMovie-Frames.h"


@implementation NKDMovieFilmstripView
@synthesize movie;
@synthesize frameCache;
- (void)updateCurrentFrame
{
    [frameCache removeAllObjects];
    [self setNeedsDisplay:YES];
}
- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
    [self updateCurrentFrame];
}
- (void)drawRect:(NSRect)rect 
{
    if (movie == nil)
        return;
    
    if (frameCache == nil)
        self.frameCache = [NSMutableArray array];
    
    NSSize frameSize = [[movie currentFrameImage] size];
    CGFloat aspectRatio  = frameSize.width / frameSize.height;
    CGFloat frameWidth = aspectRatio * ([self frame].size.height - 10.0); // Leave five pixels at top and bottom for film holes
    CGFloat numFrames = [self frame].size.width / frameWidth;
    
    BOOL hasCached = ([frameCache count] == (int)numFrames + 1 && [frameCache count] > 0) ? YES : NO;
    
    for (int i = 0; i <= numFrames; i++)
    { 
        
        int frameNumber = i * ([movie numberOfFrames] / numFrames);
        NSImage *frameImage = nil;
        
        if (hasCached)
        {
            frameImage = [frameCache objectAtIndex:i];
        }
        else
        {
            frameImage = [movie frameImageForFrame:frameNumber];
            [frameCache addObject:frameImage];
        }
        
        CGFloat leftPoint = frameWidth * i;
        
        [[NSColor redColor] set];
        NSRect frameRect = NSMakeRect(leftPoint, 5.0, frameWidth, [self bounds].size.height - 10.0);
        NSRect fromRect = NSMakeRect(0.0, 0.0, [frameImage size].width, [frameImage size].height);
        
        if (frameRect.origin.x + frameRect.size.width >= [self frame].size.width)
        {
            frameRect.size.width = [self frame].size.width - frameRect.origin.x;
            CGFloat truncAspectRatio = frameRect.size.width / frameRect.size.height;
            fromRect.size.width = fromRect.size.height * truncAspectRatio;
        }
        [frameImage drawInRect:frameRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1.0];   
        
        NSRect topStripRect = NSMakeRect(leftPoint, 0.0, [self frame].size.width, 5.0);
        NSRect bottomStripRect = NSMakeRect(leftPoint, [self frame].size.height - 5.0, [self frame].size.width, 5.0);
        [[NSColor blackColor] set];
        [NSBezierPath fillRect:topStripRect];
        [NSBezierPath fillRect:bottomStripRect];
        for (int i = 0; i < [self frame].size.width / 5; i++)
        {
            CGFloat left = i * 5 + 2;
            NSRect topSocketRect = NSMakeRect(left, [self frame].size.height - 4.0, 3, 3);
            NSRect bottomSocketRect = NSMakeRect(left, 1, 3, 3);
            [[NSColor whiteColor] set];
            [NSBezierPath fillRect:topSocketRect];
            [NSBezierPath fillRect:bottomSocketRect];
        }
        
    }
    
    int currentFrameNumber = [movie currentFrameNumber];
    int frameCount = [movie numberOfFrames];
    CGFloat percentage = (CGFloat)currentFrameNumber / (CGFloat)frameCount;
    CGFloat lineXPosition = percentage * [self frame].size.width;
    [[NSColor redColor] set];
    [NSBezierPath setDefaultLineWidth:2.0];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(lineXPosition, 0.0) toPoint:NSMakePoint(lineXPosition, [self frame].size.height)];
}
@end
