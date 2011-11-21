#import <Foundation/Foundation.h>
#import "ManagedObjectAttributeEditor.h"

@interface ManagedObjectFetchedPropertyDisplayer : ManagedObjectAttributeEditor {
    NSString    *displayKey;
    NSString    *controllerFactoryMethod;
}
@property (nonatomic, retain) NSString *displayKey;
@end
