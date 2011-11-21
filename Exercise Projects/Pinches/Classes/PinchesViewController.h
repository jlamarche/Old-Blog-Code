//
//  PinchesViewController.h
//  Pinches
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMinimumPinchDelta 100

static inline CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
	CGFloat deltaX = second.x - first.x;
	CGFloat deltaY = second.y - first.y;
	return sqrtf(deltaX*deltaX + deltaY*deltaY);
};

@interface PinchesViewController : UIViewController {
    UILabel *label;
    CGFloat initialDistance;    // CGFloat is just a float
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property CGFloat initialDistance;
- (void)eraseLabel;
@end

