//
//  UIImage-RawData.m
//  test
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage-Alpha.h"
#import <CoreGraphics/CoreGraphics.h>

CGContextRef CreateAlphaBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    void *          bitmapData;
    int             bitmapByteCount;

    

    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);

    bitmapByteCount     = (pixelsWide * pixelsHigh);
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
        return nil;
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     pixelsWide,
                                     NULL,
                                     kCGImageAlphaOnly);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }    
    return context;
}

@implementation UIImage(Alpha)
- (NSData *)alphaData
{
    CGContextRef cgctx = CreateAlphaBitmapContext(self.CGImage);
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
    
    size_t dataSize = w * h;
    return [NSData dataWithBytes:data length:dataSize];
}    

@end
