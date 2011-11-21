//
//  CGAffineTransformShear.m
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import "CGAffineTransformShear.h"
CGAffineTransform CGAffineTransformMakeXShear(CGFloat proportion)
{
	return CGAffineTransformMake(1.0, 0.0, proportion, 1.0, 0.0, 0.0);
}
CGAffineTransform CGAffineTransformXShear(CGAffineTransform src, CGFloat proportion)
{
	return CGAffineTransformConcat(src, CGAffineTransformMakeXShear(proportion));
}
CGAffineTransform CGAffineTransformMakeYShear(CGFloat proportion)
{
	return CGAffineTransformMake(1.0, proportion, 0.0, 1.0, 0.0, 0.0);

}
CGAffineTransform CGAffineTransformYShear(CGAffineTransform src, CGFloat proportion)
{
	return CGAffineTransformConcat(src, CGAffineTransformMakeYShear(proportion));
}