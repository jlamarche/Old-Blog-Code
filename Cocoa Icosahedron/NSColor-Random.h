//
//  NSColor-Random.h
//  Face
//
//  Created by jeff on 9/20/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSColor (Random) 
+(NSColor *)randomColor;
- (void)setOpenGLColor;
- (void)setColorArrayToColor:(NSColor *)toColor;
@end
