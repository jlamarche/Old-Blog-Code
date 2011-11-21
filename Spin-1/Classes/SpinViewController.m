//
//  SpinViewController.m
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import "SpinViewController.h"
#import "UIView-GetImageOf.h"
#import "UIImage-Blur.h"
#import "JLPickerView.h"

@interface UIPickerView(SoundsEnabledPrivate)
- (void)setSoundsEnabled:(BOOL)isEnabled;
@end

@interface UIImage(ResizePrivate)
- (id)_imageScaledToSize:(struct CGSize)size interpolationQuality:(int)quality;
@end

@implementation SpinViewController
@synthesize longPicker;
@synthesize shortPicker;
@synthesize spinButton;
@synthesize component1Data;
@synthesize component2Data;
@synthesize component3Data;
@synthesize component1Labels;
@synthesize component2Labels;
@synthesize component3Labels;
@synthesize component1BlurredLabels;
@synthesize component2BlurredLabels;
@synthesize component3BlurredLabels;
@synthesize component1DataShort;
@synthesize component2DataShort;
@synthesize component3DataShort;
@synthesize component1LabelsShort;
@synthesize component2LabelsShort;
@synthesize component3LabelsShort;

- (void)unhideShortPicker
{
	shortPicker.hidden = NO;
	longPicker.hidden = YES;
}
- (void)stopBlurring
{
	isSpinning = NO;
}
- (IBAction)spin
{	
	if (! isSpinning)
	{
		shortPicker.hidden = YES;
		longPicker.hidden = NO;
		// Calculate a random index in the array
		spin1 = arc4random()%[component1Data count];
		spin2 = arc4random()%[component1Data count];
		spin3 = arc4random()%[component1Data count];	
		
		// Put first and third component near top, second near bottom
		[longPicker selectRow:([longPicker selectedRowInComponent:0]%[component1Data count]) + [component1Data count] inComponent:0 animated:NO];
		[longPicker selectRow:(kRowMultiplier - 2) * [component2Data count] + spin2 inComponent:1 animated:NO];
		[longPicker selectRow:([longPicker selectedRowInComponent:2]%[component3Data count]) + [component3Data count] inComponent:2 animated:NO];
		
		
		// Spin to the selected value
		[longPicker selectRow:(kRowMultiplier - 2) * [component1Data count] + spin1 inComponent:0 animated:YES];
		[longPicker selectRow:spin2 + [component2Data count] inComponent:1 animated:YES];
		[longPicker selectRow:(kRowMultiplier - 2) * [component3Data count] + spin3 inComponent:2 animated:YES];
		[shortPicker selectRow:(kRowMultiplier - 2) * [component1Data count] + spin1 inComponent:0 animated:YES];
		[shortPicker selectRow:spin2 + [component2Data count] inComponent:1 animated:YES];
		[shortPicker selectRow:(kRowMultiplier - 2) * [component3Data count] + spin3 inComponent:2 animated:YES];
		
		
		// Set Slow Mode
		isSpinning = YES;
		
		// Need to have it stop blurring a fraction of a second before it stops spinning so that the final appearance is not blurred.
		[self performSelector:@selector(stopBlurring) withObject:nil afterDelay:4.7];
		[self performSelector:@selector(unhideShortPicker) withObject:nil afterDelay:5.1];
	}
}
- (NSArray *)arrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker
{
	NSString *arrayName = (thePicker == longPicker) ? [NSString stringWithFormat:@"component%dLabels", index+1] : [NSString stringWithFormat:@"component%dLabelsShort", index+1];
	return [self valueForKey:arrayName];
}
- (NSArray *)blurredArrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker
{
	NSString *arrayName = (thePicker == longPicker) ? [NSString stringWithFormat:@"component%dBlurredLabels", index+1] : [NSString stringWithFormat:@"component%dLabelsShort", index+1];
	return [self valueForKey:arrayName];
}
#pragma mark -
- (void)_reenablePickerSound
{
	[longPicker setSoundsEnabled:YES];
	[shortPicker setSoundsEnabled:YES];
}
- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray
{
	NSMutableArray *blurred = [NSMutableArray array];
	for (UILabel *oneLabel in labelArray)
	{
		UIImage *image = [oneLabel getAsImage];
		UIImage *scaledImage = [image _imageScaledToSize:CGSizeMake(image.size.width / 5.0, image.size.width / 5.0) interpolationQuality:3.0];
		UIImage *labelImage = [scaledImage _imageScaledToSize:image.size interpolationQuality:3.0];
		UIImageView *labelView = [[UIImageView alloc] initWithImage:labelImage];
		[blurred addObject:labelView];
		[labelView release];
		
	}
	return blurred;
}
- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray
{
	NSMutableArray *labels = [NSMutableArray array];
	for (NSString *oneValue in stringArray)
	{
		UILabel *tempLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 25.0)];
		tempLabel.text = oneValue;
		tempLabel.font = [UIFont boldSystemFontOfSize:20.0];
		tempLabel.backgroundColor = [UIColor clearColor];
		[labels addObject:tempLabel];
		[tempLabel release];
	}
	return labels;
}
#pragma mark -
- (void)viewDidLoad 
{	
	
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
	accel.delegate = self;
	accel.updateInterval = kUpdateInterval;
	
	isSpinning = NO;
	[longPicker setSoundsEnabled:NO];
	[shortPicker setSoundsEnabled:NO];
	// Dummy data to display
	self.component1Data = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	self.component2Data = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	self.component3Data = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	
	// Create UILabels out of them
	self.component1Labels = [self labelArrayFromStringArray:component1Data];
	self.component2Labels = [self labelArrayFromStringArray:component2Data];
	self.component3Labels = [self labelArrayFromStringArray:component3Data];
	
	// Create blurred UIImageViews out of the labels - we don't want to be blurring every time, so we do on load and cache
	self.component1BlurredLabels = [self blurredLabelArrayFromLabelArray:component1Labels];
	self.component2BlurredLabels = [self blurredLabelArrayFromLabelArray:component2Labels];
	self.component3BlurredLabels = [self blurredLabelArrayFromLabelArray:component3Labels];
	
	self.component1DataShort = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	self.component2DataShort = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	self.component3DataShort = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", nil];
	self.component1LabelsShort = [self labelArrayFromStringArray:component1DataShort];
	self.component2LabelsShort = [self labelArrayFromStringArray:component2DataShort];
	self.component3LabelsShort = [self labelArrayFromStringArray:component3DataShort];
	
	[longPicker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[longPicker selectRow: [component2Data count] * (kRowMultiplier / 2) inComponent:1 animated:NO];
	[longPicker selectRow: [component3Data count] * (kRowMultiplier / 2) inComponent:2 animated:NO];
	[shortPicker selectRow: [component1Data count] * (kRowMultiplier / 2) inComponent:0 animated:NO];
	[shortPicker selectRow: [component2Data count] * (kRowMultiplier / 2) inComponent:1 animated:NO];
	[shortPicker selectRow: [component3Data count] * (kRowMultiplier / 2) inComponent:2 animated:NO];
	
	[self performSelector:@selector(_reenablePickerSound) withObject:nil afterDelay:0.25];
	
    [super viewDidLoad];
}

- (void)dealloc 
{
	[longPicker release];
	[shortPicker release];
	[spinButton release];
	[component1Data release];
	[component2Data release];
	[component3Data release];
	[component1Labels release];
	[component2Labels release];
	[component3Labels release];
	[component1BlurredLabels release];
	[component2BlurredLabels release];
	[component3BlurredLabels release];
    [super dealloc];
}
#pragma mark -
#pragma mark UIPickerViewDelegate Methods
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{	
	int actualRow = row%[[self arrayForComponent:component inPicker:pickerView] count];
	
	if (!isSpinning)
	{
		NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
		return [componentArray objectAtIndex:actualRow];
	}
	
	NSArray *componentArray = [self blurredArrayForComponent:component inPicker:pickerView];
	return [componentArray objectAtIndex:actualRow];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSLog(@"Did select row %d in component %d", row, component);
	NSArray *componentArray = [self arrayForComponent:component inPicker:pickerView];
	int actualRow = row%[componentArray count];
	
	int newRow = ([componentArray count] * (kRowMultiplier / 2)) + actualRow;
	[longPicker selectRow:newRow inComponent:component animated:NO];
	[shortPicker selectRow:newRow inComponent:component animated:NO];
	
}
#pragma mark -
#pragma mark UIPickerViewDatasource Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [[self arrayForComponent:component inPicker:pickerView] count] * kRowMultiplier;
}
#pragma mark -
#pragma mark UIAccelerometerDelegate Methods
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{	
	if (fabsf(acceleration.x) > kAccelerationThreshold || fabsf(acceleration.y) > kAccelerationThreshold || fabsf(acceleration.z) > kAccelerationThreshold) 
		[self spin];	
}
@end
