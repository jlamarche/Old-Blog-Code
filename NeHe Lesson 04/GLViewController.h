//
//  GLViewController.h
//  NeHe Lesson 04
//
//  Created by Jeff LaMarche on 12/12/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

@class GLView;
@interface GLViewController : UIViewController {

}
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;

@end
