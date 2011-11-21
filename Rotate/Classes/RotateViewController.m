//
//  RotateViewController.m
//  Rotate
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//


#import "RotateViewController.h"

@implementation RotateViewController
@synthesize label;
@synthesize initialAngle;
@synthesize initialTransform;
- (void)eraseLabel {
    label.text = @"";
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    label = nil;
}


- (void)dealloc {
    [label release];
    [super dealloc];
}

#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 2) {
        NSArray *twoTouches = [touches allObjects];
        UITouch *first = [twoTouches objectAtIndex:0];
        UITouch *second = [twoTouches objectAtIndex:1];
        self.initialAngle = angleBetweenPoints([first locationInView:self.view], [second locationInView:self.view]);
        self.initialTransform  = label.transform;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 2) {
        NSArray *twoTouches = [touches allObjects];
        UITouch *first = [twoTouches objectAtIndex:0];
        UITouch *second = [twoTouches objectAtIndex:1];
        CGFloat currentAngle = angleBetweenPoints([first locationInView:self.view], [second locationInView:self.view]);
        if (self.initialAngle = 0.0)
        {
            self.initialAngle = currentAngle;
            self.initialTransform = label.transform;
        }
        else
        {
            CGFloat angleDiff = self.initialAngle - currentAngle;
            NSLog(@"angleDiff: %f", angleDiff);
            CGAffineTransform newTransform = CGAffineTransformRotate(initialTransform, angleDiff);
            label.transform = newTransform;
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.initialAngle = 0.0;
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.initialAngle = 0.0;
    label.transform = initialTransform;
}

@end
