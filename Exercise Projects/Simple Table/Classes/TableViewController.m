//
//  TableViewController.m
//  Simple Table
//
//  Created by jeff on 8/12/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "TableViewController.h"


@implementation TableViewController
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    NSString *rowText = [[NSString alloc] initWithFormat:@"Section %d, Row %d", [indexPath section], [indexPath row]];
	cell.textLabel.text = rowText;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    [rowText release];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %d", section];
}
- (void)dealloc {
    [super dealloc];
}


@end

