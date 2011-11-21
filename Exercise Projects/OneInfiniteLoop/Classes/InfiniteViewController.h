//
//  RootViewController.h
//  OneInfiniteLoop
//
//  Created by jeff on 8/13/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@interface InfiniteViewController : UITableViewController {
    NSUInteger  hierarchyLevel;
}
@property NSUInteger hierarchyLevel;
@property (nonatomic, readonly) NSString *titleString;
@end
