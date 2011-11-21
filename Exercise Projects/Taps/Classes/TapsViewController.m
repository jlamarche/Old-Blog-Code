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
- (void)eraseMe:(UITextField *)textField {
    textField.text = @"";
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    switch (tapCount) {
        case 1:
            singleTapLabel.text = @"Single tap detected";
            [self performSelector:@selector(eraseMe:) withObject:singleTapLabel afterDelay:1.6];
            break;
        case 2:
            doubleTaplabel.text = @"Double tap detected";
            [self performSelector:@selector(eraseMe:) withObject:doubleTaplabel afterDelay:1.6];
            break;
        case 3:
            tripleTapLabel.text = @"Triple tap deteted";
            [self performSelector:@selector(eraseMe:) withObject:tripleTapLabel afterDelay:1.6];
            break;
        case 4:
            quadrupleTapLabel.text = @"Quadruple tap detected";
            [self performSelector:@selector(eraseMe:) withObject:quadrupleTapLabel afterDelay:1.6];
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
