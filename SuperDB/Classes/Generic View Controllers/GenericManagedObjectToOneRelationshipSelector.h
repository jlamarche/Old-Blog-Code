//
//  GenericMangedObjectToOneRelationshipSelector.h
//  SuperDB
//
//  Created by jeff on 7/13/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractGenericManagedObjectEditor.h"

@interface GenericManagedObjectToOneRelationshipSelector : AbstractGenericManagedObjectEditor <NSFetchedResultsControllerDelegate> {    

    NSString                    *relationship;
    NSString                    *displayKey;
    NSEntityDescription         *dest;
    BOOL                        allowAdd;
    NSString                    *layoutFilename;
    
    NSFetchedResultsController  *_fetchedResultsController;
    NSIndexPath                 *lastIndexPath;
}

@property (nonatomic, retain) NSString *relationship;
@property (nonatomic, retain) NSString *displayKey;
@property (nonatomic, retain) NSEntityDescription *dest;
@property BOOL allowAdd;
@property (nonatomic, retain) NSString *layoutFilename;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@end
