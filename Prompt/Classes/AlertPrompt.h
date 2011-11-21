//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertPrompt : UIAlertView 
{
	UITextField	*textField;
}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end
