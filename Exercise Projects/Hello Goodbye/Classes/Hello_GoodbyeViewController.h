//
//  Hello_GoodbyeViewController.h
//  Hello Goodbye
//
//  Created by jeff on 8/10/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hello_GoodbyeViewController : UIViewController <UITextFieldDelegate> {
    UILabel *outputLabel;
    UITextField *nameField;
}
@property (nonatomic, retain) IBOutlet UILabel *outputLabel;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
- (IBAction)sayHello;
- (IBAction)sayGoodbye;
- (IBAction)retractKeyboard;
@end

