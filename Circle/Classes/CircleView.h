//
//  CircleView.h
//  Circle
//
//  Created by jeff on 4/28/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCircleClosureAngleVariance     45.0
#define kCircleClosureDistanceVariance  50.0
#define kMaximumCircleTime              2.0
#define kRadiusVariancePercent          25.0
#define kOverlapTolerance               3
@interface CircleView : UIView {
    UILabel *label;
    NSMutableArray *points;
    CGPoint firstTouch;
    NSTimeInterval firstTouchTime;
}
@property (nonatomic, retain) IBOutlet UILabel * label;
@property (nonatomic, retain) NSMutableArray *points;
- (void)eraseText;
@end
