//
//  UIImage-Blur.h
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define BITS_PER_BYTE			8

@interface UIImage(Blur)
- (UIImage *)blurredCopyUsingGuassFactor:(int)gaussFactor andPixelRadius:(int)pixelRadius;
@end
