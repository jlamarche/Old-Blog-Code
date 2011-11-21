//
//  NSColor-Random.m
//  QuartzFun
//
//  Created by Jeff LaMarche on 7/31/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UIColor-Random.h"


@implementation UIColor(Random)
+(UIColor *)randomColor
{
	CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
