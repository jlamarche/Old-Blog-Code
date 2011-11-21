//
//  RootViewController.h
//  KVOTables
//
//  Created by jeff on 11/25/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UITableViewController {
    NSMutableArray  *items;
}
@property (nonatomic, retain) NSMutableArray *items;
- (void)insertNewObject;

// KVO - array accessors
- (void)insertObject:(id)anObject inItemsAtIndex:(NSUInteger)idx;
- (id)objectInItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
@end
