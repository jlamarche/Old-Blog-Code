//
//  UIView-GetImageOf.m
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import "UIView-GetImageOf.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(GetImageOf)
- (UIImage *)getAsImage
{
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	return viewImage;
}
@end
