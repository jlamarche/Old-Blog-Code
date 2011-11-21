//
//  ButtonGradientView.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlueGradientButton.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#define kCornerRadius       7

@implementation BlueGradientButton

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self setOpaque:NO];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setOpaque:NO];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	return self;
}
- (void)drawRect:(CGRect)rect 
{
    self.backgroundColor = [UIColor clearColor];
	CGRect imageBounds = CGRectMake(0.0, 0.0, self.bounds.size.width - 0.5, self.bounds.size.height);
	CGFloat alignStroke;
	CGFloat resolution;
	CGFloat stroke;
	CGMutablePathRef path;
	CGPoint point;
	CGPoint controlPoint1;
	CGPoint controlPoint2;
	CGGradientRef gradient;
	NSMutableArray *colors;
	UIColor *color;
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint point2;
	CGFloat locations[3];
	resolution = 0.5 * (self.bounds.size.width / imageBounds.size.width + self.bounds.size.height / imageBounds.size.height);
	
	stroke = 1.0;
	stroke *= resolution;
	if (stroke < 1.0)
		stroke = ceil(stroke);
	else
		stroke = round(stroke);
	stroke /= resolution;
	alignStroke = fmod(0.5 * stroke * resolution, 1.0);
	path = CGPathCreateMutable();
	point = CGPointMake((self.bounds.size.width - kCornerRadius), self.bounds.size.height);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - kCornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake((self.bounds.size.width - (kCornerRadius / 2.f)), self.bounds.size.height);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake(self.bounds.size.width - 0.5f, (self.bounds.size.height - (kCornerRadius / 2.f)));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(self.bounds.size.width - 0.5f, kCornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake((self.bounds.size.width - kCornerRadius), 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(self.bounds.size.width - 0.5f, (kCornerRadius / 2.f));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake((self.bounds.size.width - (kCornerRadius / 2.f)), 0.0);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(kCornerRadius, 0.0);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(0.0, kCornerRadius);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake((kCornerRadius / 2.f), 0.0);
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake(0.0, (kCornerRadius / 2.f));
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake(0.0, (self.bounds.size.height - kCornerRadius));
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	point = CGPointMake(kCornerRadius, self.bounds.size.height);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	controlPoint1 = CGPointMake(0.0, (self.bounds.size.height - (kCornerRadius / 2.f)));
	controlPoint1.x = (round(resolution * controlPoint1.x + alignStroke) - alignStroke) / resolution;
	controlPoint1.y = (round(resolution * controlPoint1.y + alignStroke) - alignStroke) / resolution;
	controlPoint2 = CGPointMake((kCornerRadius / 2.f), self.bounds.size.height);
	controlPoint2.x = (round(resolution * controlPoint2.x + alignStroke) - alignStroke) / resolution;
	controlPoint2.y = (round(resolution * controlPoint2.y + alignStroke) - alignStroke) / resolution;
	CGPathAddCurveToPoint(path, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, point.x, point.y);
	point = CGPointMake((self.bounds.size.width - kCornerRadius), self.bounds.size.height);
	point.x = (round(resolution * point.x + alignStroke) - alignStroke) / resolution;
	point.y = (round(resolution * point.y + alignStroke) - alignStroke) / resolution;
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	CGPathCloseSubpath(path);
    if (self.state == UIControlStateHighlighted)
    {
        colors = [NSMutableArray arrayWithCapacity:4];
    	color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[0] = 0.0;
        color = [UIColor colorWithRed:0.656 green:0.683 blue:0.713 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[1] = 1.0;
        color = [UIColor colorWithRed:0.137 green:0.155 blue:0.208 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[2] = 0.51;
        color = [UIColor colorWithRed:0.237 green:0.257 blue:0.305 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[3] = 0.654;
    }
    else
    {
        colors = [NSMutableArray arrayWithCapacity:3];
        color = [UIColor colorWithRed:0.283 green:0.32 blue:0.414 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[0] = 0.0;
        color = [UIColor colorWithRed:0.82 green:0.834 blue:0.87 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[1] = 1.0;
        color = [UIColor colorWithRed:0.186 green:0.223 blue:0.326 alpha:1.0];
        [colors addObject:(id)[color CGColor]];
        locations[2] = 0.483;        
    }
    gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
	point = CGPointMake((self.bounds.size.width / 2.0), self.bounds.size.height);
	point2 = CGPointMake((self.bounds.size.width / 2.0), 0.0);
	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	CGGradientRelease(gradient);
	color = [UIColor colorWithRed:0.076 green:0.103 blue:0.195 alpha:1.0];
	[color setStroke];
	CGContextSetLineWidth(context, stroke);
	CGContextSetLineCap(context, kCGLineCapSquare);
	CGContextAddPath(context, path);
	CGContextStrokePath(context);
	CGPathRelease(path);
    
	CGColorSpaceRelease(space);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
    previousState = self.state;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (previousState != self.state)
        [self setNeedsDisplay];
    previousState = self.state;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}
@end
