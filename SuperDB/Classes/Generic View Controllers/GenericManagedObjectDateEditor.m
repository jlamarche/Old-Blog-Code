//
//  GenericManagedObjectDateEditor.m
//  SuperDB
//
//  Created by jeff on 7/10/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "GenericManagedObjectDateEditor.h"


@implementation GenericManagedObjectDateEditor
@synthesize datePicker;
@synthesize dateTableView;
@synthesize date;
#pragma mark -
#pragma mark Custom Methods
-(IBAction)dateChanged
{
    self.date = self.datePicker.date;
	[dateTableView reloadData];
}
#pragma mark -
#pragma mark Superclass Overrides
-(IBAction)save {
    [self.managedObject setValue:date forKey:self.keypath];
    
    NSError *error;
    if (![managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadView
{
    [super loadView];
    
    UIView *theView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = theView;
    [theView release];
	
	UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 67.0, 320.0, 480.0) style:UITableViewStyleGrouped];
	theTableView.delegate = self;
	theTableView.dataSource = self;
	[self.view addSubview:theTableView];
	self.dateTableView = theTableView;
	[theTableView release];
	
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, 320.0, 216.0)];
	theDatePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker = theDatePicker;
    [theDatePicker release];
    [datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.date = [self.managedObject valueForKeyPath:self.keypath];
}
- (void)viewWillAppear:(BOOL)animated {
    if (date != nil)
		[self.datePicker setDate:date animated:YES];	
    else 
		[self.datePicker setDate:[NSDate date] animated:YES];
	[self dateChanged];
	
    [super viewWillAppear:animated];
}
-(void)dealloc {
    [datePicker release];
    [dateTableView release];
    [date release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    static NSString *GenericManagedObjectDateEditorCell = @"GenericManagedObjectDateEditorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GenericManagedObjectDateEditorCell];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GenericManagedObjectDateEditorCell] autorelease];
		cell.textLabel.font = [UIFont systemFontOfSize:17.0];
		cell.textLabel.textColor = [UIColor colorWithRed:0.243 green:0.306 blue:0.435 alpha:1.0];
    }
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMMM dd, yyyy"];
	cell.textLabel.text = [formatter stringFromDate:date];
	[formatter release];
	
	return cell;
}
@end
