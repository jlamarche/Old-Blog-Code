#import "RequestTypesViewController.h"

@implementation RequestTypesViewController
@synthesize webView;
@synthesize paramName;
@synthesize paramValue;
@synthesize receivedData;

- (IBAction)doGetRequest {
    
    NSMutableString *urlWithParameters = [NSMutableString stringWithString:kFormURL];

    [urlWithParameters appendFormat:@"?%@=%@", paramName.text, paramValue.text];
    
    NSLog(@"%@", urlWithParameters);
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlWithParameters]];
    
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (theConnection) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
    } 
    else {
        [webView loadHTMLString:@"Unable to make connection!" baseURL:[NSURL URLWithString:kFormURL]] ;
    }    
    [paramName resignFirstResponder];
    [paramValue resignFirstResponder];
    [req release];
}
- (IBAction)doPostRequest {	
	NSURL *url = [[NSURL alloc] initWithString:kFormURL];
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] 
                                initWithURL:url];
	[req setHTTPMethod:@"POST"];

	
    NSString *paramDataString = [NSString stringWithFormat:@"%@=%@", paramName.text, paramValue.text];
    
	NSData *paramData = [paramDataString dataUsingEncoding:NSUTF8StringEncoding];
	[req setHTTPBody: paramData];	
    
    NSURLConnection *theConnection=[[NSURLConnection alloc]
                                    initWithRequest:req 
                                    delegate:self];
    if (theConnection) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
    } 
    else {
        [webView loadHTMLString:@"Unable to make connection!" baseURL:[NSURL URLWithString:kFormURL]] ;
    }  

	[url release];
	[req release];
    [paramName resignFirstResponder];
    [paramValue resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.webView = nil;
    self.paramName = nil;
    self.paramValue = nil;
}

- (void)dealloc {
    [webView release];
    [paramName release];
    [paramValue release];
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Response Code: %d\n", [(NSHTTPURLResponse *)response statusCode]);
    NSLog(@"Content-Type: %@\n", [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Type"]);
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    [connection release];
    self.receivedData = nil; 
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                    message:[NSString stringWithFormat:NSLocalizedString(@"Connection failed! Error - %@ (URL: %@)", @"Connection failed! Error - %@ (URL: %@)"), [error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]] 
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    webView.hidden = NO;
    NSString *payloadAsString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    [webView loadHTMLString:payloadAsString baseURL:[NSURL URLWithString:kFormURL]];
    [payloadAsString release];
    
    [connection release];
    self.receivedData = nil;
}
@end
