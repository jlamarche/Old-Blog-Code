//
//  UIImage-Blur.h
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

// THIS CODE DOES NOT CURRENTL WORK AND IS NOT BEING USED. IF ANYONE FIGURES OUT WHY IT'S NOT WORKING, PLEASE LET ME KNOW

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define BITS_PER_BYTE			8

@interface UIImage(Blur)
- (UIImage *)blurredCopy:(int)pixelRadius;
@end
