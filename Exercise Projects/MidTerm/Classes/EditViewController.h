//
//  EditViewController.h
//  MidTerm
//
//  Created by jeff on 8/15/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController  <UITextFieldDelegate> {
    UITextField     *textField;
    NSMutableArray  *array;
    NSUInteger      index;
}
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) NSMutableArray *array;
@property NSUInteger index;
- (IBAction)backgroundClick;
- (IBAction)save;
- (IBAction)cancel;
@end
