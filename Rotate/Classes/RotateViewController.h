//
//  RotateViewController.h
//  Rotate
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
static inline CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat height = second.y - first.y;
	CGFloat width = first.x - second.x;
	CGFloat rads = atan(height/width);
	return rads;

}
@interface RotateViewController : UIViewController {
    UILabel             *label;
    CGFloat             initialAngle;
    CGAffineTransform   initialTransform;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property CGFloat initialAngle;
@property CGAffineTransform initialTransform;
@end

