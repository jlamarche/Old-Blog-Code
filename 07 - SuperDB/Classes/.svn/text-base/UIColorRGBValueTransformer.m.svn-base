//
//  UIColorRGBValueTransformer.m
//  SuperDB
//
//  Created by jeff on 9/24/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "UIColorRGBValueTransformer.h"


@implementation UIColorRGBValueTransformer
+ (Class)transformedValueClass {
    return [NSData class];
}
+ (BOOL)allowsReverseTransformation {
    return YES;
}
// Takes a UIColor, returns an NSData
- (id)transformedValue:(id)value {
    UIColor *color = value;
    const CGFloat *components = CGColorGetComponents(color.CGColor);  
    NSString *colorAsString = [NSString stringWithFormat:@"%f,%f,%f,%f", components[0], components[1], components[2], components[3]];
    return [colorAsString dataUsingEncoding:NSUTF8StringEncoding];
}
// Takes an NSData, returns a UIColor
- (id)reverseTransformedValue:(id)value {
    NSString *colorAsString = [[[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding] autorelease];
    NSArray *components = [colorAsString componentsSeparatedByString:@","];
    CGFloat r = [[components objectAtIndex:0] floatValue];
    CGFloat g = [[components objectAtIndex:1] floatValue];
    CGFloat b = [[components objectAtIndex:2] floatValue];
    CGFloat a = [[components objectAtIndex:3] floatValue];
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
@end
