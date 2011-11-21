#import "StalledViewController.h"
#import "SquareRootBatch.h"

@implementation StalledViewController
@synthesize numOperationsInput;
@synthesize progressBar;
@synthesize progressLabel;
@synthesize goStopButton;
- (IBAction)go {
    
    if (!processRunning) {
        NSInteger opCount = [numOperationsInput.text intValue];
        SquareRootBatch *batch = [[SquareRootBatch alloc] initWithMaxNumber:opCount];
        
        [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                         target:self
                                       selector:@selector(processChunk:)
                                       userInfo:batch
                                        repeats:YES];
        [batch release];
        [goStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        processRunning = YES;
    } else {
        processRunning = NO;
        [goStopButton setTitle:@"Go" forState:UIControlStateNormal];
    }

}

- (void)processChunk:(NSTimer *)timer {
    
    if (!processRunning) {  // Cancelled
        [timer invalidate];
        progressLabel.text = @"Calculations Cancelled";
        return;
    }
        
    SquareRootBatch *batch = (SquareRootBatch *)[timer userInfo];
    NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate] + (kTimerInterval / 2.0);
    
    BOOL    isDone = NO;
    while ([NSDate timeIntervalSinceReferenceDate] < endTime && (!isDone)) {
        for (int i = 0; i < kBatchSize; i++) {
            if (![batch hasNext]) {
                isDone = YES;
                i = kBatchSize;
            }
            else {
                NSInteger current = batch.current;
                double nextSquareRoot = [batch next];
                NSLog(@"Calculated square root of %d as %0.3f", current, nextSquareRoot);
            }
        }
    }
    progressLabel.text = [batch percentCompletedText];
    progressBar.progress = [batch percentCompleted];
    
    if (isDone) {
        [timer invalidate];
        processRunning = NO;
        progressLabel.text = @"Calculations Finished";
        [goStopButton setTitle:@"Go" forState:UIControlStateNormal];
    }
    
}

- (void)viewDidUnload {
	self.numOperationsInput = nil;
    self.progressBar = nil;
    self.progressLabel = nil;
    self.goStopButton = nil;
}


- (void)dealloc {
    [numOperationsInput release];
    [progressBar release];
    [progressLabel release];
    [goStopButton release];
    [super dealloc];
}

@end
