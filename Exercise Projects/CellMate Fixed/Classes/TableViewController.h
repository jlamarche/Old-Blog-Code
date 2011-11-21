//
//  TableViewController.h
//  Simple Table
//
//  Created by jeff on 8/12/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableCell;
@interface TableViewController : UITableViewController {
    TableCell *tableCell;
}
@property (nonatomic, assign) IBOutlet TableCell *tableCell;
@end
