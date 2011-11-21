//
//  GenericManagedObjectDateEditor.h
//  SuperDB
//
//  Created by jeff on 7/10/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractGenericManagedObjectEditor.h"

@interface GenericManagedObjectDateEditor : AbstractGenericManagedObjectEditor {
    UIDatePicker    *datePicker;
    UITableView		*dateTableView;
    NSDate          *date;  // holds temporary value
}
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UITableView *dateTableView;
@property (nonatomic, retain) NSDate *date;
-(IBAction)dateChanged;
@end
