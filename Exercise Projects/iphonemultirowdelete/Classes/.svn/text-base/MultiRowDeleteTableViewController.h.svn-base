//
//  MultiRowDeleteTableViewController.h
//  MultiRowDelete
//
//  Created by Jeff LaMarche on 10/25/08.
//  Copyright 2008 Jeff LaMarche Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellImageViewTag		1000
#define kCellLabelTag			1001

#define kLabelIndentedRect	CGRectMake(40.0, 12.0, 275.0, 20.0)
#define kLabelRect			CGRectMake(15.0, 12.0, 275.0, 20.0)

@interface MultiRowDeleteTableViewController : UITableViewController {
	UIToolbar *toolbar;
	NSMutableArray *countries;
	NSMutableArray *selectedArray;
	BOOL inPseudoEditMode;
	
	UIImage *selectedImage;
	UIImage *unselectedImage;
	
	UIBarButtonItem	*deleteButton;
}
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSMutableArray *countries;
@property (nonatomic, retain) NSMutableArray *selectedArray;

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *deleteButton;
@property BOOL inPseudoEditMode;
- (IBAction)togglePseudoEditMode;
- (IBAction)doDelete;
- (void)populateSelectedArray;
@end
