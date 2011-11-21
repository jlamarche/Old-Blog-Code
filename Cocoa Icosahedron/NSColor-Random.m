//
//  NSColor-Random.m
//  Face
//
//  Created by jeff on 9/20/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "NSColor-Random.h"


@implementation NSColor(Random)
+(NSColor *)randomColor
{
	CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
}
- (void)setOpenGLColor
{
	int numComponents = [self numberOfComponents];
    CGFloat components[numComponents];
    [self getComponents:&components[0]];
	if (numComponents == 2)
	{
		CGFloat all = components[0];
		CGFloat alpha = components[1];		
		glColor4f(all,all, all, alpha);
	}
	else
	{
		CGFloat red = components[0];
		CGFloat green = components[1];
		CGFloat blue = components[2];
		CGFloat alpha = components[3];
		glColor4f(red,green, blue, alpha);
	}
	
}
- (void)setColorArrayToColor:(NSColor *)toColor
{
	GLfloat *colorArray = malloc(sizeof(GLfloat) * 8);
    
	int numComponents = [self numberOfComponents];
    CGFloat components[numComponents];
    [self getComponents:&components[0]];
    
	
	if (numComponents == 2)
	{
		colorArray[0] = components[0];
		colorArray[1] = components[0];
		colorArray[2] = components[0];
		colorArray[3] = components[1];
	}
	else
	{
		// Assuming RGBA if not grayscale
		colorArray[0] = components[0];
		colorArray[1] = components[1];
		colorArray[2] = components[2];
		colorArray[3] = components[3];
	}
	
    int otherColorNumComponents = [toColor numberOfComponents];
    CGFloat otherComponents[otherColorNumComponents];
    [toColor getComponents:&otherComponents[0]];
    
	if (otherColorNumComponents == 2)
	{
		colorArray[4] = otherComponents[0];
		colorArray[5] = otherComponents[0];
		colorArray[6] = otherComponents[0];
		colorArray[7] = otherComponents[1];
	}
	else
	{
		// Assuming RGBA if not grayscale
		colorArray[4] = otherComponents[0];
		colorArray[5] = otherComponents[1];
		colorArray[6] = otherComponents[2];
		colorArray[7] = otherComponents[3];
	}
	
	glColorPointer (4, GL_FLOAT, 4*sizeof(GLfloat), colorArray);
	free(colorArray);
	
}
@end
