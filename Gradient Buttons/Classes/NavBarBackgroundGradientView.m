//
//  NavBarBackgroundGradientView.m
//  CG Test
//
//  Created by jeff on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NavBarBackgroundGradientView.h"


@implementation NavBarBackgroundGradientView
- (void)drawRect:(CGRect)rect 
{
    CGRect imageBounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
	CGFloat alignStroke;
	CGFloat resolution;
	CGMutablePathRef path;
	CGRect drawRect;
	CGGradientRef gradient;
	NSMutableArray *colors;
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point;
	CGPoint point2;
	CGFloat locations[5];
	resolution = 0.5 * (self.bounds.size.width / imageBounds.size.width + self.bounds.size.height / imageBounds.size.height);
	
	alignStroke = 0.0;
	path = CGPathCreateMutable();
	drawRect = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
	drawRect.origin.x = (round(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
	drawRect.origin.y = (round(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
	drawRect.size.width = round(resolution * drawRect.size.width) / resolution;
	drawRect.size.height = round(resolution * drawRect.size.height) / resolution;
	CGPathAddRect(path, NULL, drawRect);
	colors = [NSMutableArray arrayWithCapacity:5];
	color = [UIColor colorWithRed:0.351 green:0.444 blue:0.573 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	locations[0] = 0.0;
	color = [UIColor colorWithRed:0.62 green:0.676 blue:0.754 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	locations[1] = 1.0;
	color = [UIColor colorWithRed:0.563 green:0.627 blue:0.713 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	locations[2] = 0.743;
	color = [UIColor colorWithRed:0.479 green:0.553 blue:0.66 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	locations[3] = 0.498;
	color = [UIColor colorWithRed:0.43 green:0.51 blue:0.63 alpha:1.0];
	[colors addObject:(id)[color CGColor]];
	locations[4] = 0.465;
	gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake(100.0, self.bounds.size.height);
	point2 = CGPointMake(100.0, 0.0);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	CGPathRelease(path);
	CGColorSpaceRelease(space);
}
@end
