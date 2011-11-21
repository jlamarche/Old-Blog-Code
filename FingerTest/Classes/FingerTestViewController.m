//
//  FingerTestViewController.m
//  FingerTest
//
//  Created by jeff on 4/23/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FingerTestViewController.h"

@implementation FingerTestViewController
@synthesize label;

- (void)viewDidUnload 
{
	[super viewDidUnload];
    self.label = nil;
}
- (void)dealloc 
{
    [label release];
    [super dealloc];
}
#pragma mark -
#pragma mark Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    label.text = [NSString stringWithFormat:@"%d", [touches count]];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
     label.text = [NSString stringWithFormat:@"%d", [touches count]]; 
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    label.text = [NSString stringWithFormat:@"%d", [touches count]]; 
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
     label.text = [NSString stringWithFormat:@"%d", [touches count]]; 
}
@end