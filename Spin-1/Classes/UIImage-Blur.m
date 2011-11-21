//
//  UIImage-Blur.m
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "UIImage-Blur.h"
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
        return NULL;
	
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL) 
        CGColorSpaceRelease( colorSpace );
	
    context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,    
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst );
    if (context == NULL)
        free (bitmapData);

    CGColorSpaceRelease( colorSpace );
	
    return context;
}


CGImageRef CreateCGImageByBlurringImage(CGImageRef inImage, NSUInteger pixelRadius)
{
	unsigned char *srcData, *destData, *finalData;

    CGContextRef context = CreateARGBBitmapContext(inImage);
    if (context == NULL) 
        return NULL;

    size_t width = CGBitmapContextGetWidth(context);
    size_t height = CGBitmapContextGetHeight(context);
    size_t bpr = CGBitmapContextGetBytesPerRow(context);
	size_t bpp = (CGBitmapContextGetBitsPerPixel(context) / 8);
	CGRect rect = {{0,0},{width,height}}; 
	
    CGContextDrawImage(context, rect, inImage); 
	
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    srcData = (unsigned char *)CGBitmapContextGetData (context);
    if (srcData != NULL)
    {
		
		size_t dataSize = bpr * height;
		finalData = malloc(dataSize);
		destData = malloc(dataSize);
		memcpy(finalData, srcData, dataSize);
		memcpy(destData, srcData, dataSize);

		int sums[5];
		int i, x, y, k;
		int gauss_sum=0;
		int radius = pixelRadius * 2 + 1;
		int *gauss_fact = malloc(radius * sizeof(int));
		
		for (i = 0; i < pixelRadius; i++)
		{
			
			gauss_fact[i] = 1 + (5*i);
			gauss_fact[radius - (i + 1)] = 1 + (5 * i);
			gauss_sum += (gauss_fact[i] + gauss_fact[radius - (i + 1)]);
		}
		gauss_fact[(radius - 1)/2] = 1 + (5*pixelRadius);
		gauss_sum += gauss_fact[(radius-1)/2];
		
		unsigned char *p1, *p2, *p3;
		
		for ( y = 0; y < height; y++ ) 
		{
			for ( x = 0; x < width; x++ ) 
			{
				p1 = srcData + bpp * (y * width + x); 
				p2 = destData + bpp * (y * width + x);
				
				for (i=0; i < 5; i++)
					sums[i] = 0;
				
				for(k=0;k<radius;k++)
				{
					if ((y-((radius-1)>>1)+k) < height)
						p1 = srcData + bpp * ( (y-((radius-1)>>1)+k) * width + x); 
					else
						p1 = srcData + bpp * (y * width + x);
					
					for (i = 0; i < bpp; i++)
						sums[i] += p1[i]*gauss_fact[k];
					
				}
				for (i=0; i < bpp; i++)
					p2[i] = sums[i]/gauss_sum;
			}
		}
		for ( y = 0; y < height; y++ ) 
		{
			for ( x = 0; x < width; x++ ) 
			{
				p2 = destData + bpp * (y * width + x);
				p3 = finalData + bpp * (y * width + x);
				
				
				for (i=0; i < 5; i++)
					sums[i] = 0;
				
				for(k=0;k<radius;k++)
				{
					if ((x -((radius-1)>>1)+k) < width)
						p1 = srcData + bpp * ( y * width + (x -((radius-1)>>1)+k)); 
					else
						p1 = srcData + bpp * (y * width + x);
					
					for (i = 0; i < bpp; i++)
						sums[i] += p2[i]*gauss_fact[k];
					
				}
				for (i=0; i < bpp; i++)
				{
						p3[i] = sums[i]/gauss_sum;
				}
			}
		}
    }
	
	size_t bitmapByteCount = bpr * height;
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, srcData, bitmapByteCount, NULL);
	
    CGImageRef cgImage = CGImageCreate(width, height, CGBitmapContextGetBitsPerComponent(context),
									   CGBitmapContextGetBitsPerPixel(context), CGBitmapContextGetBytesPerRow(context), CGBitmapContextGetColorSpace(context), CGBitmapContextGetBitmapInfo(context), 
									   dataProvider, NULL, true, kCGRenderingIntentDefault);
	
    CGDataProviderRelease(dataProvider);
    CGContextRelease(context); 
	if (destData)
		free(destData);
    if (finalData)
        free(finalData);
	
	return cgImage;
}




@implementation UIImage(Blur)
- (UIImage *)blurredCopy:(int)pixelRadius
{
	// THIS DOESN"T WORK! Not sure why, though...
	CGImageRef retCGImage = CreateCGImageByBlurringImage(self.CGImage, pixelRadius);
	UIImage *retUIImage = [UIImage imageWithCGImage:retCGImage];
	CGImageRelease(retCGImage);
	return retUIImage;
	
}

@end
