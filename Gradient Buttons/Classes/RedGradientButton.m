//
//  ButtonGradientView.m
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RedGradientButton.h"

@implementation RedGradientButton
- (CGGradientRef)createNormalGradient
{
    CGFloat locations[5];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
    UIColor *color = [UIColor colorWithRed:0.667 green:0.15 blue:0.152 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[0] = 0.0;
    color = [UIColor colorWithRed:0.841 green:0.566 blue:0.566 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[1] = 1.0;
    color = [UIColor colorWithRed:0.75 green:0.341 blue:0.345 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[2] = 0.582;
    color = [UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[3] = 0.418;
    color = [UIColor colorWithRed:0.592 green:0.0 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[4] = 0.346;
    
    CGGradientRef ret = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(space);
    return ret;
}
- (CGGradientRef)createHighlightGradient
{
    CGFloat locations[5];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:5];
    UIColor * color = [UIColor colorWithRed:0.467 green:0.009 blue:0.005 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[0] = 0.0;
    color = [UIColor colorWithRed:0.754 green:0.562 blue:0.562 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[1] = 1.0;
    color = [UIColor colorWithRed:0.543 green:0.212 blue:0.212 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[2] = 0.715;
    color = [UIColor colorWithRed:0.5 green:0.153 blue:0.152 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[3] = 0.513;
    color = [UIColor colorWithRed:0.388 green:0.004 blue:0.0 alpha:1.0];
    [colors addObject:(id)[color CGColor]];
    locations[4] = 0.445;
    
    CGGradientRef ret = CGGradientCreateWithColors(space, (CFArrayRef)colors, locations);
    CGColorSpaceRelease(space);
    return ret;
}
- (CGFloat)cornerRadius
{
    return 9.0;
}
@end