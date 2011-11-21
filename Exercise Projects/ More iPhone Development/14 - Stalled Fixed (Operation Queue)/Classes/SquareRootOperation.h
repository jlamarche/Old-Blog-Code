#import <Foundation/Foundation.h>

#define kBatchSize          100 
#define kUIUpdateFrequency  0.5

@class SquareRootOperation;
@protocol SquareRootOperationDelegate
- (void)operationProgressChanged:(SquareRootOperation *)op;
@end

@interface SquareRootOperation : NSOperation {
    NSInteger   max;
    NSInteger   current;
    id          delegate;
}
@property NSInteger max;
@property NSInteger current;
@property (assign) id<SquareRootOperationDelegate> delegate;

- (id)initWithMax:(NSInteger)inMax delegate:(id<SquareRootOperationDelegate>)inDelegate;
- (float)percentComplete;
- (NSString *)progressString;
@end
