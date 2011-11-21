#import "WebGetViewController.h"
static NSString *gImageURL = @"http://iphonedevbook.com/more/10/cover.png";

@implementation WebGetViewController
@synthesize imageView;
@synthesize receivedData;
- (IBAction)fetch {
    //  This is the "old school" way of using a pre-compiler definition
    //NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kImageURL]];
    
    // This is the newer way that uses a global static variable, which gives more type safety
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:gImageURL]];
    
    
    NSURLConnection *con =[[NSURLConnection alloc] initWithRequest:req 
                                                          delegate:self];
    if (con) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
    } 
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                        message:NSLocalizedString(@"Error connecting to remote server", @"Error connecting to remote server")
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }   
    [req release];
    
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.imageView = nil;
}


- (void)dealloc {
    [imageView release];
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    [connection release];
    self.receivedData = nil; 
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"Connection failed! Error - %@ (URL: %@)", [error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]] 
                                                   delegate:self
                                          cancelButtonTitle:@"Bummer"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {


        imageView.image = [UIImage imageWithData:receivedData];
    
    [connection release];
    self.receivedData = nil;
}
@end
