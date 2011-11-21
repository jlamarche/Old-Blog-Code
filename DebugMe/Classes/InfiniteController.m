//
//  InfiniteController.m
//  Nav
//
//  Created by jeff on 8/16/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "InfiniteController.h"


@implementation InfiniteController

@synthesize hierarchyLevel;
@dynamic titleString;
@synthesize rowImage;
- (NSString *)titleString 
{
    return [NSString stringWithFormat:@"Level %d", self.hierarchyLevel];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.title = self.titleString;
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"InfiniteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *rowString = [[NSString alloc] initWithFormat:@"Row %d", [indexPath row]];
    cell.textLabel.text = rowString;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [rowString release];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InfiniteController *controller = [[InfiniteController alloc] initWithStyle:UITableViewStylePlain];
    controller.hierarchyLevel = self.hierarchyLevel + 1;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

