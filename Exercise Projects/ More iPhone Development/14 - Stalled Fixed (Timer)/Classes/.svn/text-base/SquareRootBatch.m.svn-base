#import "SquareRootBatch.h"

@implementation SquareRootBatch
@synthesize max;
@synthesize current;
- (id)initWithMaxNumber:(NSInteger)inMax {
    if (self = [super init]) {
        current = 0;
        max = inMax;
    }
    return self;
}

- (BOOL)hasNext {
    return current <= max;
}

- (double)next {
    if (current > max)
        [NSException raise:kExceededMaxException format:@"Requested a calculation from completed batch."]; 
    
    return sqrt((double)++current);
}

- (float)percentCompleted {
    return (float)current / (float)max;
}
- (NSString *)percentCompletedText {
    return [NSString stringWithFormat:@"Square Root of %d is %.3f", current, sqrt((double)current)];
}
@end
