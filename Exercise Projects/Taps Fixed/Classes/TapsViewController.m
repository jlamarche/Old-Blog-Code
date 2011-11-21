//
//  TapsViewController.m
//  Taps
//
//  Created by jeff on 8/15/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "TapsViewController.h"

@implementation TapsViewController
@synthesize singleTapLabel;
@synthesize doubleTaplabel;
@synthesize tripleTapLabel;
@synthesize quadrupleTapLabel;
- (void)singleTap {
    singleTapLabel.text = @"Single Tap Detected";
    [self performSelector:@selector(eraseMe:)
               withObject:singleTapLabel afterDelay:1.6];
}
- (void)doubleTap {
    doubleTaplabel.text = @"Double Tap Detected";
    [self performSelector:@selector(eraseMe:)
               withObject:doubleTaplabel afterDelay:1.6];
}
- (void)tripleTap {
    tripleTapLabel.text = @"Triple Tap Detected";
    [self performSelector:@selector(eraseMe:)
               withObject:tripleTapLabel afterDelay:1.6];
}
- (void)quadrupleTap {
    quadrupleTapLabel.text = @"Quadruple Tap Detected";
    [self performSelector:@selector(eraseMe:)
               withObject:quadrupleTapLabel afterDelay:1.6];
}
- (void)eraseMe:(UITextField *)textField {
    textField.text = @"";
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    
    switch (tapCount) {
        case 1:
            [self performSelector:@selector(singleTap) 
                       withObject:nil 
                       afterDelay:.4];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                     selector:@selector(singleTap) 
                                                       object:nil];
            [self performSelector:@selector(doubleTap) 
                       withObject:nil 
                       afterDelay:.4];
            break;
        case 3:
            [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                     selector:@selector(doubleTap) 
                                                       object:nil];
            [self performSelector:@selector(tripleTap) 
                       withObject:nil 
                       afterDelay:.4];
            break;
        case 4:
            [NSObject cancelPreviousPerformRequestsWithTarget:self 
                                                     selector:@selector(tripleTap) 
                                                       object:nil];
            [self quadrupleTap];
            break;
        default:
            break;
    }
}
- (void)viewDidUnload {
    self.singleTapLabel = nil;
    self.doubleTaplabel = nil;
    self.tripleTapLabel = nil;
    self.quadrupleTapLabel = nil;
}

- (void)dealloc {
    [singleTapLabel release];
    [doubleTaplabel release];
    [tripleTapLabel release];
    [quadrupleTapLabel release];
    [super dealloc];
}

@end
