#import "ManagedObjectEditor.h"
#import "NSArray-NestedArrays.h"
#import "HeroValueDisplay.h"
#import "ManagedObjectAttributeEditor.h" 
#import "NSManagedObject-IsNew.h"
#import "NSArray-Set.h"
#import "SuperDBAppDelegate.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ManagedObjectEditor()
- (BOOL)isToManyRelationshipSection:(NSInteger)section;
@end

@implementation ManagedObjectEditor
@synthesize managedObject;
@synthesize showSaveCancelButtons;
- (BOOL)isToManyRelationshipSection:(NSInteger)section
{
    NSArray *controllersForSection = [rowControllers objectAtIndex:section];
    
    if ([controllersForSection count] == 0)
        return NO;
    
    NSString *controllerForRow0 = [controllersForSection objectAtIndex:0];
    NSArray *sectionKeys = [rowKeys objectAtIndex:section];
    
    return [sectionKeys count] == 1 && [controllerForRow0 isEqualToString:kToManyRelationship];
}
- (IBAction)save {
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancel {
    if ([self.managedObject isNew])
        [self.managedObject.managedObjectContext deleteObject:self.managedObject];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {	
            
    unsigned int outCount;
    objc_property_t *propList = class_copyPropertyList([self.managedObject class], &outCount);
    
    for (int i=0; i < outCount; i++)
	{
        objc_property_t oneProp = propList[i];
		NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
		NSString *attrs = [NSString stringWithUTF8String: property_getAttributes(oneProp)];

        
        if ([attrs rangeOfString:@"NSSet"].location != NSNotFound) {
            NSMutableSet *objects = [self.managedObject valueForKey:propName];
            NSMutableArray *toDelete = [NSMutableArray array];
            for (NSManagedObject *oneObject in objects) {
                if ([oneObject isDeleted])
                    [toDelete addObject:oneObject];
            }
            for (NSManagedObject *oneObject in toDelete)
            {
                [objects removeObject:oneObject];
                NSError *error;
                if (![self.managedObject.managedObjectContext save:&error])
                    NSLog(@"Error saving: %@", [error localizedDescription]);
            }
            
        }
    }   
    free(propList);
    [self.tableView reloadData];
    if (showSaveCancelButtons) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] 
                                         initWithTitle:NSLocalizedString(@"Cancel", 
                                                                         @"Cancel - for button to cancel changes")
                                         style:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        [cancelButton release];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithTitle:NSLocalizedString(@"Save", 
                                                                       @"Save - for button to save changes")
                                       style:UIBarButtonItemStyleDone
                                       target:self 
                                       action:@selector(save)];
        self.navigationItem.rightBarButtonItem = saveButton;
        [saveButton release];
        
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [super viewWillAppear:animated];
}
- (void)dealloc {
    [managedObject release];
    [sectionNames release];
    [rowLabels release];
    [rowKeys release];
    [rowControllers release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionNames count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id theTitle = [sectionNames objectAtIndex:section];
    if ([theTitle isKindOfClass:[NSNull class]])
        return nil;
	
    return theTitle;
}
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    
    if ([self isToManyRelationshipSection:section])
    {
        NSArray *sectionKeys = [rowKeys objectAtIndex:section];
        NSString *row0Key = [sectionKeys objectAtIndex:0];
        return [[managedObject valueForKey:row0Key] count] + 1;
    }
    return [rowLabels countOfNestedArray:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *defaultIdentifier = @"Managed Object Cell Identifier";
    static NSString *relationshipIdentifier = 
    @"Managed Object Relationship Cell Identifier";
    
    id rowController = [rowControllers nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    if (rowController == nil) {
        NSUInteger newPath[] = {[indexPath section], 0};
        NSIndexPath *row0IndexPath = [NSIndexPath indexPathWithIndexes:newPath 
                                                                length:2];
        rowController = [rowControllers nestedObjectAtIndexPath:row0IndexPath];
        rowKey = [rowKeys nestedObjectAtIndexPath:row0IndexPath];
        rowLabel = [rowLabels nestedObjectAtIndexPath:row0IndexPath];
    }
    
    NSString *cellIdentifier = nil;
    UITableViewCellStyle cellStyle;
    if ([rowController isEqual:kToManyRelationship]) { 
        cellIdentifier = relationshipIdentifier;
        cellStyle = UITableViewCellStyleDefault;
    }
    else {
        cellIdentifier = defaultIdentifier;
        cellStyle = UITableViewCellStyleValue2;
    }
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:cellStyle 
                                       reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if ([rowController isEqual:kToManyRelationship]) {
        NSSet *rowSet = [managedObject valueForKey:rowKey];
        if ([rowSet count] == 0 || [indexPath row] >= [rowSet count]) {
            cell.textLabel.text = NSLocalizedString(@"Add New…", @"Add New…");
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            NSArray *rowArray = [NSArray arrayByOrderingSet:rowSet byKey:rowLabel 
                                                  ascending:YES];
            NSUInteger row = [indexPath row];
            NSManagedObject *relatedObject = [rowArray objectAtIndex:row];
            NSString *rowValue = [[relatedObject valueForKey:rowLabel] 
                                  heroValueDisplay];
            cell.textLabel.text = rowValue;
            cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if ([rowController isEqual:@"ManagedObjectFetchedPropertyDisplayer"]) {
        cell.detailTextLabel.text = rowLabel;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"";     
    } else {
        id <HeroValueDisplay, NSObject> rowValue = [managedObject 
                                                    valueForKey:rowKey];
        cell.detailTextLabel.text = [rowValue heroValueDisplay];
        cell.textLabel.text = rowLabel;
        
        cell.editingAccessoryType = (rowController == [NSNull null]) ? 
        UITableViewCellAccessoryNone : 
        UITableViewCellAccessoryDisclosureIndicator;
        
        if ([rowValue isKindOfClass:[UIColor class]])
            cell.detailTextLabel.textColor = (UIColor *)rowValue;
        else
            cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([self isToManyRelationshipSection:[indexPath section]]) {
        
        
        NSUInteger newPath[] = {[indexPath section], 0};
        NSIndexPath *row0IndexPath = [NSIndexPath indexPathWithIndexes:newPath length:2];
        
        NSString *rowKey = [rowKeys nestedObjectAtIndexPath:row0IndexPath];
        NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:row0IndexPath];
        NSSet *rowSet = [managedObject valueForKey:rowKey];
        NSDictionary *args = [rowArguments nestedObjectAtIndexPath:row0IndexPath];
        NSString *selectorString = [args objectForKey:kSelectorKey];
       
        NSEntityDescription *ed = [managedObject entity];
        NSRelationshipDescription *rd = [[ed relationshipsByName] 
                                         valueForKey:rowKey];
        NSEntityDescription *dest = [rd destinationEntity];
        NSString *entityName = [dest name];
        
        ManagedObjectEditor *controller = [ManagedObjectEditor 
                                           performSelector:NSSelectorFromString(selectorString)];
        
        
        NSMutableSet *relationshipSet = [self.managedObject mutableSetValueForKey:rowKey];
        if ([rowSet count] == 0 || [indexPath row] >= [rowSet count]) {
            
            
            NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self.managedObject managedObjectContext]];
            controller.managedObject = object;
            [relationshipSet addObject:object];
            controller.title = [NSString stringWithFormat:@"New %@", entityName];
        }
        else {
            
            NSArray *relationshipArray = [NSArray arrayByOrderingSet:relationshipSet byKey:rowLabel ascending:YES];
            NSManagedObject *selectedObject = [relationshipArray objectAtIndex:[indexPath row]];
            controller.managedObject = selectedObject;
            controller.title = entityName;
        }
        controller.showSaveCancelButtons = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }
    else {
        NSString *controllerClassName = [rowControllers 
                                         nestedObjectAtIndexPath:indexPath];
        NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
        NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
        Class controllerClass = NSClassFromString(controllerClassName);
        ManagedObjectAttributeEditor *controller = 
        [controllerClass alloc];
        controller = [controller initWithStyle:UITableViewStyleGrouped];
        controller.keypath = rowKey;
        controller.managedObject = managedObject;
        controller.labelString = rowLabel;
        controller.title = rowLabel;
        
        NSDictionary *args = [rowArguments nestedObjectAtIndexPath:indexPath];
        if ([args isKindOfClass:[NSDictionary class]]) {
            if (args != nil) {
                for (NSString *oneKey in args) {
                    id oneArg = [args objectForKey:oneKey];
                    [controller setValue:oneArg forKey:oneKey];
                }
            }
        }    
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}
- (NSIndexPath *)tableView:(UITableView *)tableView 
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id controllerClassName = [rowControllers nestedObjectAtIndexPath:indexPath];
    return (controllerClassName == (id)[NSNull null]) ? nil : indexPath;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isToManyRelationshipSection:[indexPath section]]) {
        NSUInteger newPath[] = {[indexPath section], 0};
        NSIndexPath *row0IndexPath = [NSIndexPath indexPathWithIndexes:
                                      newPath length:2];
        
        NSString *rowKey = [rowKeys nestedObjectAtIndexPath:row0IndexPath];
        NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:row0IndexPath];
        NSMutableSet *rowSet = [managedObject mutableSetValueForKey:rowKey];
        NSArray *rowArray = [NSArray arrayByOrderingSet:rowSet byKey:rowLabel 
                                              ascending:YES];
        
        if ([indexPath row] >= [rowArray count])
            return UITableViewCellEditingStyleInsert;
        
        return UITableViewCellEditingStyleDelete; 
    }
    
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView 
shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self isToManyRelationshipSection:[indexPath section]];
}
- (void)tableView:(UITableView *)tableView 
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSUInteger newPath[] = {[indexPath section], 0};
        NSIndexPath *row0IndexPath = [NSIndexPath indexPathWithIndexes:newPath length:2];
        
        NSString *rowKey = [rowKeys nestedObjectAtIndexPath:row0IndexPath];
        NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:row0IndexPath];
        
        NSMutableSet *rowSet = [self.managedObject mutableSetValueForKey:rowKey];
        
        NSArray *rowArray = [NSArray arrayByOrderingSet:rowSet byKey:rowLabel ascending:YES];
        NSManagedObject *objectToRemove = [rowArray objectAtIndex:[indexPath row]];
        [rowSet removeObject:objectToRemove];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[objectToRemove managedObjectContext] deleteObject:objectToRemove];
        NSError *error;
        if (![self.managedObject.managedObjectContext save:&error])
            NSLog(@"Error saving: %@", [error localizedDescription]);
        
    }   
    
}
@end
