#import "CustomAlertViewController.h"
#import <QuartzCore/QuartzCore.h>
@implementation CustomAlertViewController
@synthesize alertView, label;
- (IBAction)doLongSomething
{
    [self.view addSubview:alertView];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.center = self.view.superview.center;
    
    CALayer *viewLayer = self.alertView.layer;
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.duration = 0.35555555;
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.6],
                        [NSNumber numberWithFloat:1.1],
                        [NSNumber numberWithFloat:.9],
                        [NSNumber numberWithFloat:1],
                        nil];
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0],
                          [NSNumber numberWithFloat:0.6],
                          [NSNumber numberWithFloat:0.8],
                          [NSNumber numberWithFloat:1.0], 
                          nil];    
    
    [viewLayer addAnimation:animation forKey:@"transform.scale"];
    
    [self performSelector:@selector(updateText:) withObject:@"Getting there…" afterDelay:1.0];
    [self performSelector:@selector(updateText:) withObject:@"Really…" afterDelay:2.0];
    [self performSelector:@selector(updateText:) withObject:@"Just about there…" afterDelay:3.0];
    [self performSelector:@selector(updateText:) withObject:@"Done" afterDelay:4.5];
    [self performSelector:@selector(finalUpdate) withObject:nil afterDelay:5.0];
}
- (void)updateText:(NSString *)newText
{
    self.label.text = newText;
}
- (void)finalUpdate
{
    [UIView beginAnimations:@"" context:nil];
    self.alertView.alpha = 0.0;
    [UIView commitAnimations];
    [UIView setAnimationDuration:0.35];
    [self performSelector:@selector(removeAlert) withObject:nil afterDelay:0.5];
}
#pragma mark -
- (void)viewDidUnload {
	self.alertView = nil;
    self.label = nil;
}
- (void)dealloc {
    [alertView release], alertView = nil;
    [label release], label = nil;
    [super dealloc];
}

- (void)removeAlert
{
    [self.alertView removeFromSuperview];
    self.alertView.alpha = 1.0;
}
@end
