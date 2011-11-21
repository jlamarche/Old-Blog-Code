//
//  RootViewController.h
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITextFieldDelegate>
{
    UITextField     *inputField;
}
@property (nonatomic, retain) IBOutlet  UITextField *inputField;

- (IBAction)backgroundTapped;
@end
