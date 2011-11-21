//
//  RootViewController.h
//  MidTerm
//
//  Created by jeff on 8/14/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

@class EditViewController;
@interface RootViewController : UITableViewController {
    NSMutableArray      *tableData;
    EditViewController  *editController;
}
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) IBOutlet EditViewController *editController;
@end
