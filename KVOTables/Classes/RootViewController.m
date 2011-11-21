//
//  RootViewController.m
//  KVOTables
//
//  Created by jeff on 11/25/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize items;
- (void)insertNewObject {
    NSDate *now = [NSDate date];
    [self willChangeValueForKey:@"items"];
    [self insertObject:[NSString stringWithFormat:@"%@", now] inItemsAtIndex:0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    [self addObserver:self
            forKeyPath:@"items"
               options:0
               context:NULL];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
}
#pragma mark Array Accessors
- (NSUInteger)countOfItems
{
    return [items count];
}

- (id)objectInItemsAtIndex:(NSUInteger)idx
{
    return [items objectAtIndex:idx];
}

- (void)insertObject:(id)anObject inItemsAtIndex:(NSUInteger)idx
{
    [items insertObject:anObject atIndex:idx];
}

- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx
{ 
    [items removeObjectAtIndex:idx];
}
#pragma mark KVO 
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSIndexSet *indices = [change objectForKey:NSKeyValueChangeIndexesKey];
    if (indices == nil)
        return; // Nothing to do
    
    
    // Build index paths from index sets
    NSUInteger indexCount = [indices count];
    NSUInteger buffer[indexCount];
    [indices getIndexes:buffer maxCount:indexCount inIndexRange:nil];
    
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < indexCount; i++) {
        NSUInteger indexPathIndices[2];
        indexPathIndices[0] = 0;
        indexPathIndices[1] = buffer[i];
        NSIndexPath *newPath = [NSIndexPath indexPathWithIndexes:indexPathIndices length:2];
        [indexPathArray addObject:newPath];
    }
    
    NSNumber *kind = [change objectForKey:NSKeyValueChangeKindKey];
    if ([kind integerValue] == NSKeyValueChangeInsertion)  // Operations were added
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    else if ([kind integerValue] == NSKeyValueChangeRemoval)  // Operations were removed
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    
}
#pragma mark Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	cell.textLabel.text = [self objectInItemsAtIndex:[indexPath row]];
    return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [self removeObjectFromItemsAtIndex:[indexPath row]];
}


- (void)dealloc {
    [items release];
    [super dealloc];
}


@end

