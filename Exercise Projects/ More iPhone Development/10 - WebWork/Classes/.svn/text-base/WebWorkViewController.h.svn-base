#import <UIKit/UIKit.h>

#define kImageURL   @"http://iphonedevbook.com/more/10/cover.png"
#define kTextURL    @"http://iphonedevbook.com/more/10/text.txt"

typedef enum RequestTypes {
    kRequestTypeImage,
    kRequestTypeText,
} RequestType;

@interface WebWorkViewController : UIViewController {
    UIActivityIndicatorView *spinner;
    UIImageView             *imageView;
    UITextView              *textView;
    
    NSMutableData           *receivedData;
    RequestType             requestType;
}
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) NSMutableData *receivedData;

- (void)clear;

- (IBAction)getImageUsingNSData;
- (IBAction)getImageSynchronously;
- (IBAction)getImageAsynchronously;

- (IBAction)getTextUsingNSString;
- (IBAction)getTextSynchronously;
- (IBAction)getTextAsynchronously;
@end