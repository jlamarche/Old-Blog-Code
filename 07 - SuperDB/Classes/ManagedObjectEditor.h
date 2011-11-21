#import <UIKit/UIKit.h>

#define kToManyRelationship    @"ManagedObjectToManyRelationship"
#define kSelectorKey            @"selector"


@interface ManagedObjectEditor : UITableViewController {
    NSManagedObject *managedObject;
    BOOL            showSaveCancelButtons;
    
@private   
    NSArray         *sectionNames;
    NSArray         *rowLabels;
    NSArray         *rowKeys;
    NSArray         *rowControllers;
    NSArray         *rowArguments; 
    
}
@property (nonatomic, retain) NSManagedObject *managedObject;
@property BOOL showSaveCancelButtons;
- (IBAction)save;
- (IBAction)cancel;
@end
