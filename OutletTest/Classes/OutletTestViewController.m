//
//  OutletTestViewController.m
//  OutletTest
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "OutletTestViewController.h"

@implementation OutletTestViewController
@synthesize button, offscreenView; 
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Offscreen view: %@", offscreenView);
}
- (IBAction) buttonPressed
{
    NSLog(@"Offscreen view: %@", offscreenView);
}
@end
