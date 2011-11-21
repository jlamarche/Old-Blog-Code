#import "StalledViewController.h"

@implementation StalledViewController
@synthesize numOperationsInput;
@synthesize progressBar;
@synthesize progressLabel;
- (IBAction)go {

    NSInteger opCount = [numOperationsInput.text intValue];
    for (NSInteger i = 1; i <= opCount; i++) {
        NSLog(@"Calculating square root of %d", i);
        progressBar.progress = ((float)i / (float)opCount);
        double squareRootOfI = sqrt((double)i);
        progressLabel.text = [NSString stringWithFormat:@"Square Root of %d is %.3f", i, squareRootOfI];
    }
}

- (void)viewDidUnload {
	self.numOperationsInput = nil;
    self.progressBar = nil;
}


- (void)dealloc {
    [numOperationsInput release];
    [progressBar release];
    [super dealloc];
}

@end
