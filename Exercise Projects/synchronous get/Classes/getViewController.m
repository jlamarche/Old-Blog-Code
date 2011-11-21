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
	NSString *urlString = @"http://www.apple.com";

	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] 
                                initWithURL:url];
	[req setHTTPMethod:@"GET"];
    
	NSHTTPURLResponse* response = nil;  
	NSError* error = [[NSError alloc] init];  
	NSData *responseData = [NSURLConnection sendSynchronousRequest:req   
                                returningResponse:&response   
                                            error:&error];  
	NSString *result = [[NSString alloc] initWithData:responseData 
                                        encoding:NSUTF8StringEncoding];
	NSMutableString *output = [NSMutableString stringWithCapacity:100];
    [output appendFormat:@"Response Code: %d\n", [response statusCode]];
    [output appendFormat:@"Content-Type: %@\n", 
     [[response allHeaderFields] objectForKey:@"Content-Type"]];
	if ([response statusCode] >= 200 && [response statusCode] < 300)
		[output appendFormat:@"Result: %@", result];
    
    textView.text = output;
	[urlString release];
	[url release];
	[result release];
	[req release];
}
- (void)viewDidUnload {
	self.textView = nil;
}


- (void)dealloc {
    [textView release];
    [super dealloc];
}

@end
