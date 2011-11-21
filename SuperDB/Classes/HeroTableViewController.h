//
//  HeroTableViewController.h
//  SuperDB
//
//  Created by jeff on 7/7/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperDBAppDelegate.h"

@interface HeroTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@end
