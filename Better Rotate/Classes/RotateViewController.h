#import <UIKit/UIKit.h>
static inline CGFloat angleBetweenLinesInRadians(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {
	
	CGFloat a = line1End.x - line1Start.x;
	CGFloat b = line1End.y - line1Start.y;
	CGFloat c = line2End.x - line2Start.x;
	CGFloat d = line2End.y - line2Start.y;
    
    CGFloat line1Slope = (line1End.y - line1Start.y) / (line1End.x - line1Start.x);
    CGFloat line2Slope = (line2End.y - line2Start.y) / (line2End.x - line2Start.x);
	
	CGFloat degs = acosf(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
	

	return (line2Slope > line1Slope) ? degs : -degs;	
}

@interface RotateViewController : UIViewController {
    UILabel             *label;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@end

