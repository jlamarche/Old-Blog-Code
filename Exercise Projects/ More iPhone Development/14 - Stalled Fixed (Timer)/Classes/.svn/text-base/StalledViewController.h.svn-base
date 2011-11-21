#import <UIKit/UIKit.h>

#define     kTimerInterval  (1.0/60.0)
#define     kBatchSize      10

@interface StalledViewController : UIViewController {
    UITextField     *numOperationsInput;
    UIProgressView  *progressBar;
    UILabel         *progressLabel;
    UIButton        *goStopButton;
    BOOL            processRunning;
}
@property (nonatomic, retain) IBOutlet UITextField *numOperationsInput;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UIButton *goStopButton;
- (IBAction)go;
- (void)processChunk:(NSTimer *)timer;
@end

