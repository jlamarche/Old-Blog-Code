#import <UIKit/UIKit.h>
#import "SquareRootOperation.h"

@interface StalledViewController : UIViewController <SquareRootOperationDelegate, UITableViewDelegate, UITableViewDataSource> {
    UITextField     *numOperationsInput;
    UITableView     *tableView;
    
    NSOperationQueue    *queue;
}
@property (nonatomic, retain) IBOutlet UITextField *numOperationsInput;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSOperationQueue *queue;
- (IBAction)go;
- (IBAction)cancelOperation:(id)sender;
- (IBAction)backgroundClick;
@end

