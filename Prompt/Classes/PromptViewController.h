//
//  PromptViewController.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//  Copyright Jeff LaMarche Consulting 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptViewController : UIViewController  <UIAlertViewDelegate>
{
	UILabel	*label;
}
@property (nonatomic, retain) IBOutlet UILabel *label;
- (IBAction)buttonPressed;
@end

