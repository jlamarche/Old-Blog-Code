#import "NSManagedObject-IsNew.h"


@implementation NSManagedObject(IsNew)
-(BOOL)isNew 
{
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}
@end
