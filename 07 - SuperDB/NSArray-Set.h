#import <Foundation/Foundation.h>

@interface NSArray(Set)
+ (id)arrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;
@end