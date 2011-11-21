#import "RotateViewController.h"

@implementation RotateViewController
@synthesize label;

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.label = nil;
}

- (void)dealloc {
    [label release];
    [super dealloc];
}

#pragma mark -
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    if ([touches count] == 2) {
        NSArray *twoTouches = [touches allObjects];
        UITouch *first = [twoTouches objectAtIndex:0];
        UITouch *second = [twoTouches objectAtIndex:1];
        
        CGFloat currentAngle = angleBetweenLinesInRadians([first previousLocationInView:self.view], [second previousLocationInView:self.view], [first locationInView:self.view], [second locationInView:self.view]);
        
        label.transform = CGAffineTransformRotate(label.transform, currentAngle);
    }
}
@end
