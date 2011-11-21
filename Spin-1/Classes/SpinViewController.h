//
//  SpinViewController.h
//  Spin
//
//  Created by Jeff LaMarche on 1/28/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRowMultiplier				100
#define kAccelerationThreshold		2.2
#define kUpdateInterval				(1.0f/10.0f)

@class JLPickerView;

@interface SpinViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIAccelerometerDelegate>
{
	JLPickerView	*longPicker;
	UIPickerView	*shortPicker;
	
	UIButton		*spinButton;
	
	NSArray			*component1Data;
	NSArray			*component2Data;
	NSArray			*component3Data;
	
	NSArray			*component1Labels;
	NSArray			*component2Labels;
	NSArray			*component3Labels;
	
	NSArray			*component1BlurredLabels;
	NSArray			*component2BlurredLabels;
	NSArray			*component3BlurredLabels;
	
	NSArray			*component1DataShort;
	NSArray			*component2DataShort;
	NSArray			*component3DataShort;
	
	NSArray			*component1LabelsShort;
	NSArray			*component2LabelsShort;
	NSArray			*component3LabelsShort;
	
	@private
	BOOL			isSpinning;
	NSUInteger		spin1;
	NSUInteger		spin2;	
	NSUInteger		spin3;

}
@property (nonatomic, retain) IBOutlet JLPickerView *longPicker;
@property (nonatomic, retain) IBOutlet UIPickerView *shortPicker;
@property (nonatomic, retain) IBOutlet UIButton *spinButton;
@property (nonatomic, retain) NSArray *component1Data;
@property (nonatomic, retain) NSArray *component2Data;
@property (nonatomic, retain) NSArray *component3Data;
@property (nonatomic, retain) NSArray *component1Labels;
@property (nonatomic, retain) NSArray *component2Labels;
@property (nonatomic, retain) NSArray *component3Labels;
@property (nonatomic, retain) NSArray *component1BlurredLabels;
@property (nonatomic, retain) NSArray *component2BlurredLabels;
@property (nonatomic, retain) NSArray *component3BlurredLabels;
@property (nonatomic, retain) NSArray *component1DataShort;
@property (nonatomic, retain) NSArray *component2DataShort;
@property (nonatomic, retain) NSArray *component3DataShort;
@property (nonatomic, retain) NSArray *component1LabelsShort;
@property (nonatomic, retain) NSArray *component2LabelsShort;
@property (nonatomic, retain) NSArray *component3LabelsShort;
- (IBAction)spin;
- (NSArray *)blurredLabelArrayFromLabelArray:(NSArray *)labelArray;
- (NSArray *)labelArrayFromStringArray:(NSArray *)stringArray;
- (NSArray *)arrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker;
- (NSArray *)blurredArrayForComponent:(NSInteger)index inPicker:(UIPickerView *)thePicker;
@end

