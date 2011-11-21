//
//  NSMutableArray-QueueAndStack.h
//
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "NSMutableArray-QueueAndStack.h"


@implementation NSMutableArray(QueueAndStack)

// This method allows the mutable array to act as a queue. The first object in the array is returned, and simultaneously, it becomes the last object in the queue
- (id)popThenPush
{
	// We don't use -pop or -push: to avoid unnecessary use of autorelease pool
	id ret = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	[self addObject:ret];
	[ret release];
	return ret;
}

// The following two methods allow NSArray to act as a last-in/first-out stack. The push: method allows you to add new objects to the stack, pop returns the last object pushed onto the stack and removes it from the stack
- (id)pop
{
	id ret = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	return [ret autorelease];
}
- (void)push:(id)newObject
{
	[self addObject:newObject];
}

@end
