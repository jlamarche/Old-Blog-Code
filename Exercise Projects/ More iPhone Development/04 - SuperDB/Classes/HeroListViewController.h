#import <UIKit/UIKit.h>

#define kSelectedTabDefaultsKey @"Selected Tab"
enum {
    kByName = 0,
    kBySecretIdentity,
};
@class HeroEditController;
@interface HeroListViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>{
    
    UITableView *tableView;
    UITabBar    *tabBar;
    HeroEditController *detailController;
    
@private
    NSFetchedResultsController *_fetchedResultsController;
    NSUInteger                  sectionInsertCount;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet HeroEditController *detailController;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
- (void)addHero;
- (IBAction)toggleEdit;
@end
