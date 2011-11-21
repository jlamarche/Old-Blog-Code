#import <Foundation/Foundation.h>


@interface NSManagedObject(IsNew)
/*!
 @method isNew 
 @abstract   Returns YES if this managed object is new and has not yet been saved in the persistent store.
 */
-(BOOL)isNew;
@end