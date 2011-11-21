#import "MailPicViewController.h"

@implementation MailPicViewController
@synthesize message;
- (IBAction)selectAndMailPic {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker =
    [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)mailImage:(UIImage *)image {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer setSubject:NSLocalizedString(@"Here's a picture...", @"Here's a picture...")];
        [mailComposer addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"image"];
        [mailComposer setMessageBody:NSLocalizedString(@"Here's a picture that I took with my iPhone.", @"Here's a picture that I took with my iPhone.") isHTML:NO];
        [self presentModalViewController:mailComposer animated:YES];
        [mailComposer release];
        [image release];
    }
    else 
        message.text = NSLocalizedString(@"Can't send e-mail...", @"Can't send e-mail...");
}

- (void)viewDidUnload {
    self.message = nil;
}

- (void)dealloc {
    [message release];
    [super dealloc];
}
#pragma mark -
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] retain];
    [self performSelector:@selector(mailImage:) 
               withObject:image 
               afterDelay:0.5];
    message.text = @"";
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
    message.text = NSLocalizedString(@"Cancelled...", @"Cancelled...");
}

#pragma mark -
#pragma mark Mail Compose Delegate Methods
- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error
{	
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message.text = NSLocalizedString(@"Canceled...",@"Canceled...");
			break;
		case MFMailComposeResultSaved:
			message.text = NSLocalizedString(@"Saved to send later...", @"Saved to send later...");
			break;
		case MFMailComposeResultSent:
			message.text = NSLocalizedString(@"Mail sent...", @"Mail sent...");
			break;
		case MFMailComposeResultFailed: {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error sending mail...",@"Error sending mail...") 
                                                            message:[error localizedDescription] 
                                                           delegate:nil 
                                                  cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer") 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            message.text = NSLocalizedString(@"Send failed...", @"Send failed...");
            break;
        }
        default: 
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}
@end
