#import <UIKit/UIKit.h>

#define DEVIANT_CELL_IDENTIFIER     @"Deviant Cell Identifier"

@interface DeviantDisplayCell : UITableViewCell 
{
    // Since this class will be "sharing" a nib, we'll prefix
    // all outlets with "cell" so it's obvious in IB which ones
    // belong to the controller and which belong to us.
    UIImageView                 *cellImageView;
    UILabel                     *cellLabel;
    UIActivityIndicatorView     *cellSpinner;
}
@property (nonatomic, retain) IBOutlet  UIImageView *cellImageView;
@property (nonatomic, retain) IBOutlet  UILabel *cellLabel;
@property (nonatomic, retain) IBOutlet  UIActivityIndicatorView *cellSpinner;
+ (NSString *)reuseIdentifier;
@end
