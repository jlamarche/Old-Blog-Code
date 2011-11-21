#import "ManagedObjectColorEditor.h"

@implementation ManagedObjectColorEditor
@synthesize color;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.color = [self.managedObject valueForKey:self.keypath];
}
- (IBAction)sliderChanged {
    
    CGFloat components[4];
    for (int i =0; i < kNumberOfColorRows; i++) {
        NSUInteger indices[] = {1, i};
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indices length:2];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UISlider *slider = (UISlider *)[cell viewWithTag:kSliderTag];
        components[i] = slider.value;
    }
    self.color = [UIColor colorWithRed:components[0] green:components[1] blue:components[2] alpha:components[3]];
    
    NSUInteger indices[] = {0,0};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indices length:2];
    UITableViewCell *colorCell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIView *colorView = [colorCell viewWithTag:kColorViewTag];
    colorView.backgroundColor = self.color;
}
-(IBAction)save {
    [self.managedObject setValue:self.color forKey:self.keypath];
    [self validateAndPop];
}

- (void)dealloc {
    [color release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return kNumberOfRowsInSection0;
    else 
        return kNumberOfColorRows;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    static NSString *GenericManagedObjectColorEditorColorCell = @"GenericManagedObjectColorEditorColorCell";
    static NSString *GenericManagedObjectColorEditorSliderCell =  @"GenericManagedObjectColorEditorSliderCell";
    
    NSString *cellIdentifier = nil;
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0)
        cellIdentifier = GenericManagedObjectColorEditorColorCell;
    else
        cellIdentifier = GenericManagedObjectColorEditorSliderCell;
    
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:cellIdentifier] autorelease];
        
        UIView *contentView = cell.contentView;
        
        if (section == 0){
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 5.0, 290.0, 33.0)];
            colorView.backgroundColor = self.color;
            colorView.tag = kColorViewTag;  
            [contentView addSubview:colorView];
        }
        else {
            
            const CGFloat *components;
            
            // Protect against leftover data with nil color
            if (color == nil)
                self.color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            
            components = CGColorGetComponents(color.CGColor);  
            
            UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(70.0, 10.0, 210.0, 20.0)];
            slider.tag = kSliderTag;
            slider.maximumValue = 1.0;
            slider.minimumValue = 0.0;
            slider.value = components[row];
            [slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, 50.0, 20.0)];
            switch (row) {
                case kRedRow:
                    label.text = NSLocalizedString(@"R", @"R (short for red)");
                    label.textColor = [UIColor redColor];
                    break;
                case kGreenRow:
                    label.text = NSLocalizedString(@"G", @"G (short for green)");
                    label.textColor = [UIColor greenColor];
                    break;
                case kBlueRow:
                    label.text = NSLocalizedString(@"B", @"B (short for blue)");
                    label.textColor = [UIColor blueColor];
                    break;
                case kAlphaRow:
                    label.text = NSLocalizedString(@"A", @"A (short for alpha)");
                    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
                    break;
                default:
                    break;
            }
            [contentView addSubview:slider];
            [contentView addSubview:label];
            
            [slider release];
            [label release];
        }
        
    }
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
@end
