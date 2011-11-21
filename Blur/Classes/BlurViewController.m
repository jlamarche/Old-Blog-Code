//
//  BlurViewController.m
//  Blur
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BlurViewController.h"
#import "UIImage-Blur.h"

@implementation BlurViewController
@synthesize imageView, blurButton;
- (IBAction)reset
{
    imageView.image = [UIImage imageNamed:@"image.png"];
    [blurButton setTitle:@"Blur" forState:UIControlStateNormal];
}
- (IBAction)blur
{
    UIImage *image = imageView.image;
    imageView.image = [image blurredCopyUsingGuassFactor:5 andPixelRadius:5];
    [blurButton setTitle:@"Blur More" forState:UIControlStateNormal];
}
@end
