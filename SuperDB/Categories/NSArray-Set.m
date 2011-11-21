#import "NSArray-Set.h"


@implementation NSArray(Set)
+(id)arrayWithSet:(NSSet *)theSet {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id oneObject in theSet)
        [array addObject:oneObject];
    return [array autorelease];   
}
@end
