//
//  NSMutableArray-Swap.m
//  Deleted
//
//  Created by jeff on 8/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "NSMutableArray-Swap.h"

@implementation NSMutableArray(Swap)
- (void)swapObjectAtIndex:(NSUInteger)from withObjectAtIndex:(NSUInteger)to
{
    id object = [[self objectAtIndex:from] retain];
    [self removeObjectAtIndex:from];
    [self insertObject:object atIndex:to];
    [object release]; 
}
@end
