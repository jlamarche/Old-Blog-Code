//
//  ButtonGradientView.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BlueGradientButton.h"

@implementation BlueGradientButton
- (CGGradientRef)createNormalGradient
{
    CGFloat locations[3];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:3];
    UIColor *color = [UIColor colorWithRed:0.283 green:0.32 blue:0.414 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[0] = 0.0;
    color = [UIColor colorWithRed:0.82 green:0.834 blue:0.87 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[1] = 1.0;
    color = [UIColor colorWithRed:0.186 green:0.223 blue:0.326 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[2] = 0.483;  
    
    CGGradientRef ret = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(space);
    return ret;
}
- (CGGradientRef)createHighlightGradient
{
    CGFloat locations[4];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:4];
    UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[0] = 0.0;
    color = [UIColor colorWithRed:0.656 green:0.683 blue:0.713 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[1] = 1.0;
    color = [UIColor colorWithRed:0.137 green:0.155 blue:0.208 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[2] = 0.51;
    color = [UIColor colorWithRed:0.237 green:0.257 blue:0.305 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[3] = 0.654;

    CGGradientRef ret = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(space);
    return ret;
}
- (CGFloat)cornerRadius
{
    return 7.0;
}

@end
