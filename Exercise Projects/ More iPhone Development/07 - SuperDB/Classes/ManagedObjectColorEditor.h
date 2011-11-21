#import <UIKit/UIKit.h>
#import "ManagedObjectAttributeEditor.h"

#define kNumberOfSections           2
#define kNumberOfRowsInSection0     1
#define kSliderTag                  5000
#define kColorViewTag               5001

enum colorSliders {
    kRedRow = 0,
    kGreenRow,
    kBlueRow,
    kAlphaRow,
    kNumberOfColorRows
};

@interface ManagedObjectColorEditor : ManagedObjectAttributeEditor {
    UIColor *color;
}
@property (nonatomic, retain) UIColor *color;
- (IBAction)sliderChanged;
@end
