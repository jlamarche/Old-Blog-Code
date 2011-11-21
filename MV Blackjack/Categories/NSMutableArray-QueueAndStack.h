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

#import <Foundation/Foundation.h>


@interface NSMutableArray (QueueAndStack) 
// This method will return the object at index 0 and then take that object and move it to be the last object in the array.
- (id)popThenPush;
- (id)pop;
- (void)push:(id)newObject;
@end
