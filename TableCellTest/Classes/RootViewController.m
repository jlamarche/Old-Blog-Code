//
//  RootViewController.m
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "TestCell.h"

@implementation RootViewController
@synthesize loadCell;


- (void)dealloc 
{
    [loadCell release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table view Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    TestCell *cell = (TestCell *)[tableView dequeueReusableCellWithIdentifier:[TestCell reuseIdentifier]];
    if (cell == nil) 
    {
        NSLog(@"Loading new cell");
        [[NSBundle mainBundle] loadNibNamed:@"TestCell" owner:self options:nil];
        cell = loadCell;
        self.loadCell = nil;
    }
    cell.cellLabel.text = [NSString stringWithFormat:@"Row %d", [indexPath row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

@end

