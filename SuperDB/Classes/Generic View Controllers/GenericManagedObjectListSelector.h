//
//  GenericManagedObjectListSelector.h
//  SuperDB
//
//  Created by jeff on 7/9/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractGenericManagedObjectEditor.h"

@interface GenericManagedObjectListSelector : AbstractGenericManagedObjectEditor {
    NSArray *list;
    
    NSIndexPath		*lastIndexPath;
}
@property (nonatomic, retain) NSArray *list;
@end
