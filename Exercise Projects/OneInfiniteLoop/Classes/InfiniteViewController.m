//
//  RootViewController.m
//  OneInfiniteLoop
//
//  Created by jeff on 8/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "InfiniteViewController.h"


@implementation InfiniteViewController
@synthesize hierarchyLevel;
@dynamic titleString;
- (NSString *)titleString 
{
    return [NSString stringWithFormat:@"Level %d", self.hierarchyLevel];
}
- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.title = self.titleString;
}
#pragma mark -
#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
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
    InfiniteViewController *controller = [[InfiniteViewController alloc] initWithStyle:UITableViewStylePlain];
    controller.hierarchyLevel = self.hierarchyLevel + 1;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

