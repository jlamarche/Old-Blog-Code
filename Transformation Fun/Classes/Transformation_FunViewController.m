//
//  Transformation_FunViewController.m
//  Transformation Fun
//
//  Created by Jeff LaMarche on 10/28/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import "Transformation_FunViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "CGAffineTransformShear.h"

@implementation Transformation_FunViewController
@synthesize translateView;
@synthesize rotateView;
@synthesize scaleView;
@synthesize translateThenRotate;
@synthesize rotateThenTranslate;

- (void)viewDidLoad {
	translateView.transform = CGAffineTransformTranslate(translateView.transform, 100, 0);
	translateView.transform = CGAffineTransformXShear(translateView.transform, .5);
	
	rotateView.transform = CGAffineTransformRotate(rotateView.transform, degreesToRadians(45));
	
	scaleView.transform = CGAffineTransformScale(scaleView.transform, 3.0, 1.0);
	scaleView.transform = CGAffineTransformYShear(scaleView.transform, .5);
	
	
	translateThenRotate.transform = CGAffineTransformMakeTranslation(25.0, 25.0);
	translateThenRotate.transform = CGAffineTransformRotate(translateThenRotate.transform, degreesToRadians(45)); 
	
	rotateThenTranslate.transform = CGAffineTransformRotate(rotateThenTranslate.transform, degreesToRadians(45)); 
	rotateThenTranslate.transform = CGAffineTransformMakeTranslation(25.0, 25.0);
	

	[super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[translateView release];
	[rotateView release];
	[scaleView release];
	[translateThenRotate release];
	[rotateThenTranslate release];
	[super dealloc];
	
}

@end
