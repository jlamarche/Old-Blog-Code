//
//  RootViewController.h
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TestCell;

@interface RootViewController : UITableViewController 
{
    TestCell *loadCell;
}
@property (nonatomic, retain) IBOutlet TestCell *loadCell;
@end
