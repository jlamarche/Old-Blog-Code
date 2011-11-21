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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[NSString alloc] initWithFormat:@"You tapped section %d, row %d", [indexPath section], [indexPath row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Thank you, that is all" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Yes, Yes I did" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [title release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[NSString alloc] initWithFormat:@"You tapped the dislcosure button for section %d, row %d", [indexPath section], [indexPath row]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"Thank you, that is all" 
                                                   delegate:self 
                                          cancelButtonTitle:@"Yes, Yes I did" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [title release];
}
- (void)dealloc {
    [super dealloc];
}


@end

