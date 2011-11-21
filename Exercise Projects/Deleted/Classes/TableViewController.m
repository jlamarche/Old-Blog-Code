//
//  TableViewController.m
//  Deleted
//
//  Created by jeff on 8/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "TableViewController.h"


@implementation TableViewController
@synthesize tableData;
@synthesize editButton;
- (IBAction)toggleEditMode
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        self.editButton.title = @"Done";
    else
        self.editButton.title = @"Edit"; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"Charlie Brown ", @"Snoopy ", @"Linus van Pelt ", @"Lucy van Pelt ", @"Schroeder ", @"Woodstock ", @"Sally Brown ", @"Marcie ", @"Peppermint Patty ", @"Franklin ", @"Pig-Pen ", @"Frieda ", @"Rerun van Pelt ", @"Patty ", @"Shermy", nil];
    self.tableData = array;
    [array release];
    
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


- (void)tableView:(UITableView *)tableView 
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
        forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSUInteger row = [indexPath row];
        [self.tableData removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)dealloc {
    [tableData release];
    [editButton release];
    [super dealloc];
}


@end

