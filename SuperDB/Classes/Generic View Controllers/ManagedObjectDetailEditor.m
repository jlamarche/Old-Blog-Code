//
//  HeroEditViewController.m
//  SuperDB
//
//  Created by jeff on 7/8/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "ManagedObjectDetailEditor.h"
#import "GenericManagedObjectStringEditor.h"
#import <objc/objc-class.h>
#import "NSArray-Set.h"

@implementation ManagedObjectDetailEditor
#pragma mark Properties
@synthesize managedObject;
#pragma mark -
#pragma mark Custom Methods
- (id)initWithLayoutFile:(NSString *)filepath {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        layout = [[NSArray alloc] initWithContentsOfFile:filepath];
        
        _orderedRelationships = [[NSMutableDictionary alloc] init]; 
        for (NSDictionary *sectionDict in layout) {
            NSArray *sectionArray = [sectionDict objectForKey:@"rows"];
            for (NSDictionary *rowDict in sectionArray) {
                NSString *controllerClass = [rowDict objectForKey:@"controller"];
                objc_getClass([controllerClass UTF8String]); 
                
            }
        }
    }
    return self;
}
#pragma mark -
#pragma mark Superclass Overrides
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_orderedRelationships removeAllObjects];
    for (NSDictionary *sectionDict in layout) {
        NSArray *sectionArray = [sectionDict objectForKey:@"rows"];
        for (NSDictionary *rowDict in sectionArray) {
            NSString *controllerClass = [rowDict objectForKey:@"controller"];
            if ([controllerClass isEqualToString:@"GenericManagedObjectToManyRelationshipSelector"]) {
                NSString *keypath = [rowDict objectForKey:@"keypath"];
                NSString *relationship = [[keypath componentsSeparatedByString:@"."] objectAtIndex:0];
                NSArray *array = [NSArray arrayWithSet:[self.managedObject valueForKey:relationship]];
                [_orderedRelationships setValue:array forKey:keypath]; 
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [managedObject release];
    [layout release];
    [_orderedRelationships release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [layout count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDict = [layout objectAtIndex:section];
    NSArray *sections = [sectionDict objectForKey:@"rows"];
    if ([sections count] > 1)
        return [sections count];
    
    NSDictionary *rowDict = [sections objectAtIndex:0];
    NSString *controllerClass = [rowDict objectForKey:@"controller"];
    if ([controllerClass isEqual:@"GenericManagedObjectToManyRelationshipSelector"]) {
        NSString *rowKey = [rowDict objectForKey:@"keypath"];
        NSString *relationship = [[rowKey componentsSeparatedByString:@"."] objectAtIndex:0];
        NSSet *objects = [self.managedObject valueForKey:relationship];
        return [objects count] + 1;
    }
    return [sections count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ManagedObjectDetailEditorCell = @"ManagedObjectDetailEditorCell";

    
    
    NSUInteger section = [indexPath section];
    NSDictionary *sectionDict = [layout objectAtIndex:section];
    NSUInteger row = [indexPath row];
    BOOL isToManySection = NO;
    NSArray *sectionArray = [sectionDict objectForKey:@"rows"];
    
    
    if ([sectionArray count] == 1) {
        NSDictionary *rowDict = [sectionArray objectAtIndex:0];
        NSString *controllerClass = [rowDict objectForKey:@"controller"];
        if ([controllerClass isEqual:@"GenericManagedObjectToManyRelationshipSelector"]) 
            isToManySection = YES;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ManagedObjectDetailEditorCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue2 reuseIdentifier:ManagedObjectDetailEditorCell] autorelease];
        
    }
    
    if (!isToManySection) {
        NSDictionary *rowDict = [sectionArray objectAtIndex:row];
        cell.textLabel.text = [rowDict objectForKey:@"label"];
        
        NSString *formatterMethod = [rowDict objectForKey:@"formatMethod"];
        id rowValue = [managedObject valueForKeyPath:[rowDict objectForKey:@"keypath"]];
        NSString *displayValue = nil;
        if (formatterMethod != nil) 
            displayValue = [rowValue performSelector:NSSelectorFromString(formatterMethod)];
        
        if (displayValue == nil)
            displayValue = [rowValue description];
        cell.detailTextLabel.text = displayValue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        NSDictionary *rowDict = [sectionArray objectAtIndex:0];
        NSSet *objects = [managedObject valueForKeyPath:[rowDict objectForKey:@"keypath"]];
        if (row >= [objects count]) {
            cell.detailTextLabel.text = NSLocalizedString(@"Select…", @"Select…");
            cell.textLabel.text = @" ";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            NSString *keypath = [rowDict objectForKey:@"keypath"];
            NSString *rowKey = [[keypath componentsSeparatedByString:@"."] objectAtIndex:1];
            NSArray *relationshipRows = [_orderedRelationships objectForKey:keypath];
            NSManagedObject *theObject = [relationshipRows objectAtIndex:row];
            cell.textLabel.text = @" ";
            cell.detailTextLabel.text = [theObject valueForKey:rowKey];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSDictionary *sectionDict = [layout objectAtIndex:section];
    NSDictionary *rowDict = nil;
    NSArray *sectionArray = [sectionDict objectForKey:@"rows"];
    NSString *controllerClassName = nil;
    if ([sectionArray count] == 1) {
        rowDict = [sectionArray objectAtIndex:0];
        NSString *controllerClass = [rowDict objectForKey:@"controller"];
        if ([controllerClass isEqual:@"GenericManagedObjectToManyRelationshipSelector"]) {
            rowDict = [sectionArray objectAtIndex:0];
            NSSet *objects = [managedObject valueForKeyPath:[rowDict objectForKey:@"keypath"]];
            if (row == objects.count) {
                controllerClassName = controllerClass;
            }
            else {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            } 
        }
    }
    NSArray *sections = [sectionDict objectForKey:@"rows"];
    if (rowDict == nil)
        rowDict = [sections objectAtIndex:row];
    if (controllerClassName == nil)
        controllerClassName = [rowDict objectForKey:@"controller"];
    
    Class controllerClass = objc_getClass([controllerClassName UTF8String]);
    
    AbstractGenericManagedObjectEditor *controller = (AbstractGenericManagedObjectEditor *)[[controllerClass alloc] initWithStyle:UITableViewStyleGrouped];
    
    controller.keypath = [rowDict objectForKey:@"keypath"];
    controller.labelString = [rowDict objectForKey:@"label"];
    controller.managedObject = managedObject;
    
    NSDictionary *controllerArgs = [rowDict objectForKey:@"arguments"];
    if (controllerArgs != nil) {
        for (NSString *oneKey in controllerArgs) {
            id oneArg = [controllerArgs objectForKey:oneKey];
            [controller setValue:oneArg forKey:oneKey];
        }
    }
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *sectionDict = [layout objectAtIndex:section];
    return [sectionDict objectForKey:@"sectionName"];
}

@end

