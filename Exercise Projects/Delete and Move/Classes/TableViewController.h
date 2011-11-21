//
//  TableViewController.h
//  Deleted
//
//  Created by jeff on 8/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSMutableArray-Swap.h"

@interface TableViewController : UITableViewController {
    NSMutableArray      *tableData;
    UIBarButtonItem     *editButton;
}
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
- (IBAction)toggleEditMode;
@end
