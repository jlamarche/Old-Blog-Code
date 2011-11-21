//
//  getViewController.m
//  get
//
//  Created by jeff on 8/16/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "getViewController.h"

@implementation getViewController
@synthesize textView;

- (IBAction)fetch 
{
    NSString *urlString = @"http://www.apple.com/";
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSString *result = [[NSString alloc] initWithContentsOfURL:url];
	
	textView.text = result;
	
	[url release];
	[urlString release];
	[result release];
}
- (void)viewDidUnload {
	self.textView = nil;
}


- (void)dealloc {
    [textView release];
    [super dealloc];
}

@end
