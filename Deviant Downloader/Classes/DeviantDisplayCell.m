//
//  DeviantDisplayCell.m
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DeviantDisplayCell.h"


@implementation DeviantDisplayCell
@synthesize cellImageView;
@synthesize cellLabel;
@synthesize cellSpinner;
+ (NSString *)reuseIdentifier
{
    return (NSString *)DEVIANT_CELL_IDENTIFIER;
}
- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}
- (void)dealloc 
{
    [cellImageView release];
    [cellLabel release];
    [cellSpinner release];
    [super dealloc];
}
@end
