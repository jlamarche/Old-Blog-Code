//
//  MailPicViewController.h
//  MailPic
//
//  Created by jeff on 11/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface MailPicViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MFMailComposeViewControllerDelegate> {
    UILabel *message;
}
@property (nonatomic, retain) IBOutlet UILabel *message;
- (IBAction)selectAndMailPic;
- (void)mailImage:(UIImage *)image;
@end

