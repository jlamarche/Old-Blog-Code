//
//  UIImage-RawData.m
//  test
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage-Alpha.h"
#import <CoreGraphics/CoreGraphics.h>

CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    

    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@implementation UIImage(Alpha)
- (NSData *)ARGBData
{
    CGContextRef cgctx = CreateARGBBitmapContext(self.CGImage);
    if (cgctx == NULL) 
        return nil;

    size_t w = CGImageGetWidth(self.CGImage);
    size_t h = CGImageGetHeight(self.CGImage);
    CGRect rect = {{0,0},{w,h}}; 
    CGContextDrawImage(cgctx, rect, self.CGImage); 
    
    void *data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx); 
    if (!data)
        return nil;
    
    size_t dataSize = 4 * w * h; // ARGB = 4 8-bit components
    return [NSData dataWithBytes:data length:dataSize];
}    
- (BOOL)isPointTransparent:(CGPoint)point
{
    NSData *rawData = [self ARGBData];  // See about caching this
    if (rawData == nil)
        return NO;
    
    size_t bpp = 4;
    size_t bpr = self.size.width * 4;
    
    NSUInteger index = point.x * bpp + (point.y * bpr);
    char *rawDataBytes = (char *)[rawData bytes];

    return rawDataBytes[index] == 0;
    
}
@end
