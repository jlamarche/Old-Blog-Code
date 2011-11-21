//
//  CircleView.m
//  Circle
//
//  Created by jeff on 4/28/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "CircleView.h"
#import "CGPointUtils.h"

@implementation CircleView
@synthesize label;
@synthesize points;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    if (firstTouch.x != 0.0 && firstTouch.y != 0.0) {
        CGRect dotRect = CGRectMake(firstTouch.x - 3, firstTouch.y - 3.0, 5.0, 5.0);
        CGContextAddEllipseInRect(context, dotRect);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGContextMoveToPoint(context, firstTouch.x, firstTouch.y);
        for (NSString *onePointString in points) {
            CGPoint nextPoint = CGPointFromString(onePointString);
            CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
            
        }
        CGContextStrokePath(context);
    }
    else {
        CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
        CGContextAddRect(context, self.bounds);
        CGContextFillPath(context);
    }
}
- (void)dealloc {
    [label release];
    [points release];
    [super dealloc];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (points == nil)
        self.points = [NSMutableArray array];
    else
        [points removeAllObjects];
    
    firstTouch = [[touches anyObject] locationInView:self];
    firstTouchTime = [NSDate timeIntervalSinceReferenceDate];
    [self setNeedsDisplay];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint startPoint = [[touches anyObject] locationInView:self];
    [points addObject:NSStringFromCGPoint(startPoint)];    
    
    // TODO: We should calculate the redraw rect here
    [self setNeedsDisplay];
}
- (void)eraseText
{
    label.text = @"";
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint endPoint = [[touches anyObject] locationInView:self];
    [points addObject:NSStringFromCGPoint(endPoint)];
    
    // Didn't finish close enough to starting point
    if (distanceBetweenPoints(firstTouch, endPoint) > kCircleClosureDistanceVariance) {
        label.text = @"End point too far away from Start";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
        return;
    }
    // Took too long to draw
    if ([NSDate timeIntervalSinceReferenceDate] - firstTouchTime > kMaximumCircleTime){
        label.text = @"Too slow!";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
        return;
    }
    // Not enough points
    if ([points count] < 6) {
        label.text = @"Too short!";
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
        return;
    }
    
    CGPoint leftMost = firstTouch;
    NSUInteger leftMostIndex = NSUIntegerMax;
    CGPoint topMost = firstTouch;
    NSUInteger topMostIndex = NSUIntegerMax;
    CGPoint rightMost = firstTouch;
    NSUInteger  rightMostIndex = NSUIntegerMax;
    CGPoint bottomMost = firstTouch;
    NSUInteger bottomMostIndex = NSUIntegerMax;
    
    // Loop through touches and find out if outer limits of the circle
    int index = 0;
    for (NSString *onePointString in points){
        CGPoint onePoint = CGPointFromString(onePointString);
        if (onePoint.x > rightMost.x) {
            rightMost = onePoint;
            rightMostIndex = index;
        }
        if (onePoint.x < leftMost.x) {
            leftMost = onePoint;
            leftMostIndex = index;
        }
        if (onePoint.y > topMost.y) {
            topMost = onePoint;
            topMostIndex = index;
        }
        if (onePoint.y < bottomMost.y) {
            onePoint = bottomMost;
            bottomMostIndex = index;
        }
        index++;
    }
    
    // If startPoint is one of the extreme points, take set it
    if (rightMostIndex == NSUIntegerMax)
        rightMost = firstTouch;
    if (leftMostIndex == NSUIntegerMax)
        leftMost = firstTouch;
    if (topMostIndex == NSUIntegerMax)
        topMost = firstTouch;
    if (bottomMostIndex == NSUIntegerMax)
        bottomMost = firstTouch;
    
    // Figure out the approx middle of the circle
    CGPoint center = CGPointMake(leftMost.x + (rightMost.x - leftMost.x) / 2.0, bottomMost.y + (topMost.y - bottomMost.y) / 2.0);
    
    // This check is probably not necessary
    // Make sure they closed the circle - the startPoint and endPoint should be within a few degrees of each other.
//    CGFloat angle = angleBetweenLines(firstTouch, center, endPoint, center);
//    
//    if (fabs(angle) > kCircleClosureAngleVariance ) {
//        label.text = [NSString stringWithFormat:@"Didn't close circle, angle (%f) too large!", fabs(angle)];
//        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
//        return;
//    }
    
    // Calculate the radius by looking at the first point and the center
    CGFloat radius = fabsf(distanceBetweenPoints(center, firstTouch));
    
    CGFloat currentAngle = 0.0; 
    BOOL    hasSwitched = NO;
    
    // Start Circle Check=========================================================
    // Make sure all points on circle are within a certain percentage of the radius from the center
    // Make sure that the angle switches direction only once. As we go around the circle,
    //    the angle between the line from the start point to the end point and the line from  the
    //    current point and the end point should go from 0 up to about 180.0, and then come 
    //    back down to 0 (the function returns the smaller of the angles formed by the lines, so
    //    180° is the highest it will return, 0 the lowest. If it switches direction more than once, 
    //    then it's not a circle
    CGFloat minRadius = radius - (radius * kRadiusVariancePercent);
    CGFloat maxRadius = radius + (radius * kRadiusVariancePercent);
    index = 0;
    for (NSString *onePointString in points) {
        CGPoint onePoint = CGPointFromString(onePointString);
        CGFloat distanceFromRadius = fabsf(distanceBetweenPoints(center, onePoint));
        if (distanceFromRadius < minRadius || distanceFromRadius > maxRadius) {
            label.text = [NSString stringWithFormat:@"Not round enough", fabs(currentAngle)];
            [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
            return;
        }
        
        
        CGFloat pointAngle = angleBetweenLines(firstTouch, center, onePoint, center);
        
        if ((pointAngle > currentAngle && hasSwitched) && (index < [points count] - kOverlapTolerance) ) {
            label.text = [NSString stringWithFormat:@"Sequence of angles is wrong for circle!", fabs(currentAngle)];
            [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
            return;
        }
            
        if (pointAngle < currentAngle){
            if (!hasSwitched)
                hasSwitched = YES;
        }
        
        currentAngle = pointAngle;
                index++;
    }
    // End Circle Check=========================================================
    
    label.text = @"Circle Detected!";
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2.0];
    [points removeAllObjects];
    firstTouch = CGPointZero;
    
}

@end
