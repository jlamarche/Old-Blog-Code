//
//  getViewController.h
//  get
//
//  Created by jeff on 8/16/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getViewController : UIViewController {
    UITextView  *textView;
    NSMutableData   *receivedData;
}
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSMutableData *receivedData;
- (IBAction)fetch;
@end

