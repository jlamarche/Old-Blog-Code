//
//  TableViewController.m
//  Simple Table
//
//  Created by jeff on 8/12/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "TableViewController.h"
#import "TableCell.h"

@implementation TableViewController
@synthesize tableCell;
@synthesize stateArray;
- (void)viewDidLoad {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    self.stateArray = array;
    [array release];
    
    NSInteger sections = [self numberOfSectionsInTableView:(UITableView *)self.view];
    for (int i = 0; i < sections; i++)
    {
        NSInteger rows = [self tableView:(UITableView *)self.view numberOfRowsInSection:i];
        for (int j = 0; j < rows; j++) {
            [self.stateArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellMateTableViewCell";
    
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = tableCell;
        self.tableCell = nil;
    }
    
    // Set up the cell...
    NSString *rowText = [[NSString alloc] initWithFormat:@"Section %d, Row %d", [indexPath section], [indexPath row]];
	cell.mainLabel.text = rowText;
    NSString *oddEvenText = ([indexPath row]%2) ? @"This is an odd numbered row" : @"This is an even numbered row";
    cell.secondaryLabel.text = oddEvenText;
    cell.bigImageView.image = ([indexPath row]%2) ? [UIImage imageNamed:@"oldSchool.png"] : [UIImage imageNamed:@"newSchool.png"];
    
    NSUInteger section = [indexPath section];
    int index = 0;
    
    for (int i = 0; i < section; i++)
    {
        NSUInteger row = [self tableView:(UITableView *)self.view numberOfRowsInSection:i];
        index += row;
    }
    index += [indexPath row];
    BOOL isSpinning = [[stateArray objectAtIndex:index] boolValue];
    if (isSpinning) 
        [cell.spinner startAnimating];
    else 
        [cell.spinner stopAnimating];
    
    
    [rowText release];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %d", section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    int index = 0;
    
    for (int i = 0; i < section; i++)
    {
        NSUInteger row = [self tableView:(UITableView *)self.view numberOfRowsInSection:i];
        index += row;
    }
    index += [indexPath row];
    BOOL isSpinning = [[stateArray objectAtIndex:index] boolValue];
    
    TableCell *cell = (TableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [stateArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isSpinning]];
    if (isSpinning)
        [cell.spinner stopAnimating];
    else
        [cell.spinner startAnimating];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

