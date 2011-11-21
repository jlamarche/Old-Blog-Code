#import <UIKit/UIKit.h>


@interface OnlinePeerBrowser : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView         *tableView;
    NSNetServiceBrowser *netServiceBrowser;
    
    NSMutableArray      *discoveredServices;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSNetServiceBrowser *netServiceBrowser;
@property (nonatomic, retain) NSMutableArray *discoveredServices;
- (IBAction)cancel;
@end
