//
//  Custom_Alert_ViewViewController.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomAlertView.h"

@interface Custom_Alert_ViewViewController : UIViewController <CustomAlertViewDelegate>
{
    UILabel         *feedbackLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *feedbackLabel;

- (IBAction)showCustomAlert;
@end

