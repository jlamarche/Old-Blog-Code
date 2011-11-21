//
//  MultiRowDeleteTableViewController.m
//  MultiRowDelete
//
//  Created by Jeff LaMarche on 10/25/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import "MultiRowDeleteTableViewController.h"


@implementation MultiRowDeleteTableViewController
@synthesize toolbar;
@synthesize countries;
@synthesize selectedArray;
@synthesize inPseudoEditMode;
@synthesize selectedImage;
@synthesize unselectedImage;
@synthesize deleteButton;
-(IBAction)doDelete
{
	NSMutableArray *rowsToBeDeleted = [[NSMutableArray alloc] init];
	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	int index = 0;
	for (NSNumber *rowSelected in selectedArray)
	{
		if ([rowSelected boolValue])
		{
			
			[rowsToBeDeleted addObject:[countries objectAtIndex:index]];
			NSUInteger pathSource[2] = {0, index};
			NSIndexPath *path = [NSIndexPath indexPathWithIndexes:pathSource length:2];
			[indexPaths addObject:path];
		}		
		index++;
	}
	
	for (id value in rowsToBeDeleted)
	{
		[countries removeObject:value];
	}
	
	[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
	[indexPaths release];
	[rowsToBeDeleted release];
	inPseudoEditMode = NO;
	[self populateSelectedArray];
	[self.tableView reloadData];
}
-(IBAction)togglePseudoEditMode
{
	self.inPseudoEditMode = !inPseudoEditMode;
	toolbar.hidden = !inPseudoEditMode;
	
	[self.tableView reloadData];
	
}
- (void)populateSelectedArray
{
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[countries count]];
	for (int i=0; i < [countries count]; i++)
		[array addObject:[NSNumber numberWithBool:NO]];
	self.selectedArray = array;
	[array release];
}
- (void)viewDidLoad {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"txt"];
	NSString *countryData = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	self.countries = [NSMutableArray arrayWithArray:[countryData componentsSeparatedByString:@"\n"]];
	[countryData release];
	
	self.inPseudoEditMode = NO;
	
	self.selectedImage = [UIImage imageNamed:@"selected.png"];
	self.unselectedImage = [UIImage imageNamed:@"unselected.png"];
	

	[self populateSelectedArray];
	
	deleteButton.target = self;
	deleteButton.action = @selector(doDelete);
	
    [super viewDidLoad];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [countries count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
	static NSString *EditCellIdentifier = @"EditCell";
    

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EditCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:EditCellIdentifier] autorelease];
		
	
		UILabel *label = [[UILabel alloc] initWithFrame:kLabelRect];
		label.tag = kCellLabelTag;
		[cell.contentView addSubview:label];
		[label release];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage:unselectedImage];
		imageView.frame = CGRectMake(5.0, 10.0, 23.0, 23.0);
		[cell.contentView addSubview:imageView];
		imageView.hidden = !inPseudoEditMode;
		imageView.tag = kCellImageViewTag;
		[imageView release];
		
	}
	
	[UIView beginAnimations:@"cell shift" context:nil];
	
	UILabel *label = (UILabel *)[cell.contentView viewWithTag:kCellLabelTag];
	label.text = [countries objectAtIndex:[indexPath row]];
	label.frame = (inPseudoEditMode) ? kLabelIndentedRect : kLabelRect;
	label.opaque = NO;
	
	UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:kCellImageViewTag];
	NSNumber *selected = [selectedArray objectAtIndex:[indexPath row]];
	imageView.image = ([selected boolValue]) ? selectedImage : unselectedImage;
	imageView.hidden = !inPseudoEditMode;
	[UIView commitAnimations];
	

	return cell;
}


 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (inPseudoEditMode)
	{
		BOOL selected = [[selectedArray objectAtIndex:[indexPath row]] boolValue];
		[selectedArray replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithBool:!selected]];
		[self.tableView reloadData];
	}
	
	
 }
- (void)dealloc {
	[toolbar release];
	[countries release];
	[selectedArray release];
	[selectedImage release];
	[unselectedImage release];
	[deleteButton release];
	[super dealloc];
}


@end

