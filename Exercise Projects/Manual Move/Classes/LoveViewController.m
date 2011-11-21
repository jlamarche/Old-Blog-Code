//
//  LoveViewController.m
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "LoveViewController.h"


@implementation LoveViewController
@synthesize label;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
                                         duration:(NSTimeInterval)duration 
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        label.frame = CGRectMake(106.0, 123.0, label.frame.size.width, label.frame.size.height);
    else 
        label.frame = CGRectMake(180.0, 50.0, label.frame.size.width, label.frame.size.height);

}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
