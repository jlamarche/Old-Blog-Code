#import "SquareRootOperation.h"

@implementation SquareRootOperation
@synthesize max;
@synthesize current;
@synthesize delegate;

- (id)initWithMax:(NSInteger)inMax delegate:(id<SquareRootOperationDelegate>)inDelegate {
    if (self = [super init]) {
        max = inMax;
        current = 0;
        self.delegate = inDelegate;
    }
    return self;
}

- (float)percentComplete {
    return (float)current / (float)max;  
}

- (NSString *)progressString {
    if ([self isCancelled])
        return @"Cancelled...";
    if (![self isExecuting])
        return @"Waiting...";
    return [NSString stringWithFormat:@"Completed %d of %d", self.current, self.max];
}

- (void)main {
    @try {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSTimeInterval  lastUIUpdate = [NSDate timeIntervalSinceReferenceDate];
        while (current < max) {
            if (self.isCancelled)
                self.current = max+1;
            else {
                self.current++;
                double squareRoot = sqrt((double)current);
                NSLog(@"Operation %@ reports the square root of %d is %f",self, current, squareRoot);
                if (self.current % kBatchSize == 0) {
                    if ([NSDate timeIntervalSinceReferenceDate] > lastUIUpdate + kUIUpdateFrequency) {
                        
                        if (self.delegate && [delegate respondsToSelector:@selector(operationProgressChanged:)])
                            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(operationProgressChanged:) withObject:self waitUntilDone:NO];
                        [NSThread sleepForTimeInterval:0.05];
                        lastUIUpdate = [NSDate timeIntervalSinceReferenceDate];
                    }
                }
            }
        }
        [pool drain];
    }
    @catch (NSException * e) {
        // Important that we don't re-throw exception, so we just log
        NSLog(@"Exception: %@", e);
    }
}
@end
