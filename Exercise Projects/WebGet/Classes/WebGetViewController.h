#import <UIKit/UIKit.h>

#define kImageURL   @"http://iphonedevbook.com/more/10/cover.png"

@interface WebGetViewController : UIViewController {
    UIImageView             *imageView;
    NSMutableData           *receivedData;
}
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSMutableData *receivedData;
- (IBAction)fetch;
@end

