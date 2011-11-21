//
//  AbstractGenericViewController.h
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kNonEditableTextColor    [UIColor colorWithRed:.318 green:0.4 blue:.569 alpha:1.0]

@interface AbstractGenericManagedObjectEditor : UITableViewController {
    NSManagedObject         *managedObject;
    NSString                *keypath;
    NSString                *labelString;

}
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSString *keypath;
@property (nonatomic, retain) NSString *labelString;
-(IBAction)cancel;
-(IBAction)save;
@end
