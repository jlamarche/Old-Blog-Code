//
//  HeroEditViewController.h
//  SuperDB
//
//  Created by jeff on 7/8/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagedObjectDetailEditor : UITableViewController {
    NSManagedObject *managedObject;
    
    NSArray *layout;
    
    NSMutableDictionary *_orderedRelationships;  // Dictionary of NSArrays to make sure objects in relationship don't change order (NSSet doesn't)
}

@property (nonatomic, retain) NSManagedObject *managedObject;
- (id)initWithLayoutFile:(NSString *)filepath;
@end
