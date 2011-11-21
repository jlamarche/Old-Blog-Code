//
//  SwipesViewController.h
//  Swipes
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMinimumGestureLength       50
#define kMaximumVariance            5

@interface SwipesViewController : UIViewController {
    UILabel    *label;
    CGPoint    gestureStartPoint; 
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property CGPoint gestureStartPoint;
- (void)eraseText;
@end

