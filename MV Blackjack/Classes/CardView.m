//
//  CardView.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "CardView.h"
#import "Card.h"
@implementation CardView
@synthesize card;
- (id)initWithCoder:(NSCoder *) coder
{
	if (self = [super initWithCoder:coder])
	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) 
	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)newBGColor
{
	// Ignore any attempt to set background color - backgroundColor must stay set to clearColor
	// We could throw an exception here, but that would cause problems with IB, since backgroundColor
	// is a palletized property, IB will attempt to set backgroundColor for any view that is loaded
	// from a nib, so instead, we just quietly ignore this.
	//
	// Alternatively, we could put an NSLog statement here to tell the programmer to set rectColor...
}
- (void)setOpaque:(BOOL)newIsOpaque
{
	// Ignore attempt to set opaque to YES.
	
}
- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, kBackgroundColor);
	CGContextSetFillColorWithColor(context, kBackgroundColor);
	
	CGRect rrect = self.bounds;
	
	CGFloat radius = 6.0;
	CGFloat width = CGRectGetWidth(rrect);
	CGFloat height = CGRectGetHeight(rrect);
	
	// Make sure corner radius isn't larger than half the shorter side
	if (radius > width/2.0)
		radius = width/2.0;
	if (radius > height/2.0)
		radius = height/2.0;	
	
	CGFloat minx = CGRectGetMinX(rrect);
	CGFloat midx = CGRectGetMidX(rrect);
	CGFloat maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect);
	CGFloat midy = CGRectGetMidY(rrect);
	CGFloat maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
	// Get the correct image	
	NSString *path = [[NSBundle mainBundle] pathForResource:[card imageName] ofType:@"png"];
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
	
	[image drawAtPoint:CGPointMake(2.0, 2.0)];
	
	[image release];
}



@end
