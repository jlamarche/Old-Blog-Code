//
//  ButtonGradientView.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AbstractGradientButton : UIButton 
{

}
- (CGGradientRef)createNormalGradient;
- (CGGradientRef)createHighlightGradient;
- (CGFloat)cornerRadius;
@end
