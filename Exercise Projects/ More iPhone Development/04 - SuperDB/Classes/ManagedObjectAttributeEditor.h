#import <UIKit/UIKit.h>
#define kNonEditableTextColor    [UIColor colorWithRed:.318 green:0.4 blue:.569 alpha:1.0]

@interface ManagedObjectAttributeEditor : UITableViewController {
    NSManagedObject         *managedObject;
    NSString                *keypath;
    NSString                *labelString;
    
}
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSString *keypath;
@property (nonatomic, retain) NSString *labelString;
-(IBAction)cancel;
-(IBAction)save;
@end
