#import <UIKit/UIKit.h>

#define kSelectedTabDefaultsKey @"Selected Tab"
enum {
    kByName = 0,
    kBySecretIdentity,
};

@interface HeroListViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>{
    
    UITableView *tableView;
    UITabBar    *tabBar;
    
@private
    NSFetchedResultsController *_fetchedResultsController;
    NSUInteger                  sectionInsertCount;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
- (void)addHero;
- (IBAction)toggleEdit;
@end
