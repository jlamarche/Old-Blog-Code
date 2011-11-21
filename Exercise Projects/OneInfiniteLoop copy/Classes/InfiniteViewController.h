//
//  RootViewController.h
//  OneInfiniteLoop
//
//  Created by jeff on 8/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface InfiniteViewController : UITableViewController {
    NSUInteger  hierarchyLevel;
    NSUInteger  rowInParent;
}
@property NSUInteger hierarchyLevel;
@property (nonatomic, readonly) NSString *titleString;
@property NSUInteger rowInParent;
@end
