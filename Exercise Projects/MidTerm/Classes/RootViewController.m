//
//  RootViewController.m
//  MidTerm
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "RootViewController.h"
#import "EditViewController.h"

@implementation RootViewController
@synthesize tableData;
@synthesize editController;
- (void)viewDidLoad {

    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             @"Charlie Brown ", @"Snoopy ", @"Linus van Pelt ", @"Lucy van Pelt ", @"Schroeder ", @"Woodstock ", @"Sally Brown ", @"Marcie ", @"Peppermint Patty ", @"Franklin ", @"Pig-Pen ", @"Frieda ", @"Rerun van Pelt ", @"Patty ", @"Shermy", nil];
    self.tableData = array;
    [array release];
    self.title = @"Peanuts";
    
}
- (void)viewWillAppear:(BOOL)animated 
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}
- (void)dealloc {
    [tableData release];
    [editController release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DeletedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    NSString *rowString = [tableData objectAtIndex:row];
    cell.textLabel.text = rowString;
	
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editController.index = [indexPath row];
    editController.array = self.tableData;
    [self.navigationController pushViewController:editController animated:YES];
}
#pragma mark -
#pragma mark Text Field Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end

