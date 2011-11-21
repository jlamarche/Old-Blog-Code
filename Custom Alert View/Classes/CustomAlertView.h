//
//  CustomAlertView.h
//  Custom Alert View
//
//  Created by jeff on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum 
{
    CustomAlertViewButtonTagOk = 1000,
    CustomAlertViewButtonTagCancel
};

@class CustomAlertView;

@protocol CustomAlertViewDelegate
@required
- (void) CustomAlertView:(CustomAlertView *)alert wasDismissedWithValue:(NSString *)value;

@optional
- (void) customAlertViewWasCancelled:(CustomAlertView *)alert;
@end


@interface CustomAlertView : UIViewController <UITextFieldDelegate>
{
    UIView                                  *alertView;
    UIView                                  *backgroundView;
    UITextField                             *inputField;
    
    id<NSObject, CustomAlertViewDelegate>   delegate;
}
@property (nonatomic, retain) IBOutlet  UIView *alertView;
@property (nonatomic, retain) IBOutlet  UIView *backgroundView;
@property (nonatomic, retain) IBOutlet  UITextField *inputField;

@property (nonatomic, assign) IBOutlet id<CustomAlertViewDelegate, NSObject> delegate;
- (IBAction)show;
- (IBAction)dismiss:(id)sender;
@end
