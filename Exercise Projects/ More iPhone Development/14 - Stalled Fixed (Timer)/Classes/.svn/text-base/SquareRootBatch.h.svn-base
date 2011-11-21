#import <Foundation/Foundation.h>

#define kExceededMaxException   @"Exceeded Max"

@interface SquareRootBatch : NSObject {
    NSInteger   max;
    NSInteger   current;
}
@property NSInteger max;
@property NSInteger current;
- (id)initWithMaxNumber:(NSInteger)inMax;
- (BOOL)hasNext;
- (double)next;
- (float)percentCompleted;
- (NSString *)percentCompletedText;
@end
