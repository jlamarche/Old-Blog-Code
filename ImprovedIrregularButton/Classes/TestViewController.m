//
//  TestViewController.m
//  Test
//
//  Created by jeff on 3/26/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController


- (IBAction)buttonClick:(id)sender
{
    NSLog(@"Clicked:%@", sender);
}
- (void)dealloc {
    [super dealloc];
}

@end
