//
//  Transformation_FunViewController.h
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#define degreesToRadians(x) (M_PI * x / 180.0)

@interface Transformation_FunViewController : UIViewController {
	UIView	*translateView;
	UIView	*rotateView;
	UIView	*scaleView;
	UIView	*translateThenRotate;
	UIView	*rotateThenTranslate;
}
@property (nonatomic, retain) IBOutlet UIView *translateView;
@property (nonatomic, retain) IBOutlet UIView *rotateView;
@property (nonatomic, retain) IBOutlet UIView *scaleView;
@property (nonatomic, retain) IBOutlet UIView *translateThenRotate;
@property (nonatomic, retain) IBOutlet UIView *rotateThenTranslate;
@end

