//
//  CGAffineTransformShear.h
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

CGAffineTransform CGAffineTransformMakeXShear(CGFloat proportion);
CGAffineTransform CGAffineTransformXShear(CGAffineTransform src, CGFloat proportion);
CGAffineTransform CGAffineTransformMakeYShear(CGFloat proportion);
CGAffineTransform CGAffineTransformYShear(CGAffineTransform src, CGFloat proportion);