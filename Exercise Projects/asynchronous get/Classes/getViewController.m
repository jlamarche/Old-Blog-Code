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
@synthesize receivedData;


- (IBAction)fetch 
{
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];

    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) 
    {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
    } 
    else 
    {
        textView.text = @"Unable to make connection!";
    }    
}
- (void)viewDidUnload {
	self.textView = nil;
}


- (void)dealloc {
    [textView release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
    // We have to reset here in case of a redirect, will be called for each redirect, need to make sure we don't capture cruft from redirect payload
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [connection release];
    self.receivedData = nil; 
        
    textView.text = [NSString stringWithFormat:@"Connection failed! Error - %@ %@",
          [error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableString *output = [NSMutableString string];
    [output appendFormat:@"Connection Succeeded. Received %d bytes of data\n\n",[receivedData length]];
    NSString *payloadAsString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [output appendString:payloadAsString];
    [payloadAsString release];
    textView.text = output;
    [connection release];
    self.receivedData = nil;
}
@end
