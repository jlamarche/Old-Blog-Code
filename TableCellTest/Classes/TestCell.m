//
//  TestCell.m
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestCell.h"


@implementation TestCell
@synthesize cellImageView;
@synthesize cellLabel;
+ (NSString *)reuseIdentifier
{
    return (NSString *)TABLE_CELL_IDENTIFIER;
}
- (NSString *)reuseIdentifier
{
    return [[self class] reuseIdentifier];
}
- (void)dealloc 
{
    [cellImageView release];
    [cellLabel release];
    [super dealloc];
}


@end
