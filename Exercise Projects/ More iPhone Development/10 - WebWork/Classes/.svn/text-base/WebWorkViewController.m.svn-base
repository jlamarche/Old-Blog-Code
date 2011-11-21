#import "WebWorkViewController.h"

@implementation WebWorkViewController
@synthesize spinner;
@synthesize imageView;
@synthesize textView;
@synthesize receivedData;
- (void)clear {
    imageView.hidden = YES;
    textView.hidden = YES;
    imageView.image = nil;
    textView.text = nil;
}
#pragma mark -
- (IBAction)getImageUsingNSData {
    textView.hidden = YES;
    imageView.hidden = NO;
    
    NSURL *url = [NSURL URLWithString:kImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    imageView.image = [UIImage imageWithData:imageData];
    [self performSelector:@selector(clear) withObject:nil afterDelay:5.0];
}
- (IBAction)getImageSynchronously {
    textView.hidden = YES;
    imageView.hidden = NO;
    NSURL *url = [[NSURL alloc] initWithString:kImageURL];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
	NSHTTPURLResponse* response = nil;  
	NSError* error = nil; 
	NSData *responseData = [NSURLConnection sendSynchronousRequest:req   
                                                 returningResponse:&response   
                                                             error:&error]; 
    
    if (response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:@"Unable to contact server."
                                                       delegate:nil 
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    NSInteger statusCode = [response statusCode];
    NSString *contentType = [[response allHeaderFields] objectForKey:@"Content-Type"];
    
	if (statusCode >= 200 && statusCode < 300 && [contentType hasPrefix:@"image"]) {
        imageView.image = [UIImage imageWithData:responseData];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:[NSString stringWithFormat:@"Encountered %d error while loading", statusCode]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
	[url release];
	[req release];
    [self performSelector:@selector(clear) withObject:nil afterDelay:5.0];
}
- (IBAction)getImageAsynchronously {
    [spinner startAnimating];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kImageURL]];
    NSURLConnection *con =[[NSURLConnection alloc] initWithRequest:req 
                                                          delegate:self];
    if (con) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
        requestType = kRequestTypeImage;
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
#pragma mark -
- (IBAction)getTextUsingNSString {
    textView.hidden = NO;
    imageView.hidden = YES;
    NSURL *url = [NSURL URLWithString:kTextURL];
    textView.text = [NSString stringWithContentsOfURL:url 
                                             encoding:NSUTF8StringEncoding error:nil];
    [self performSelector:@selector(clear) withObject:nil afterDelay:5.0];
}
- (IBAction)getTextSynchronously {
    textView.hidden = NO;
    imageView.hidden = YES;
    NSURL *url = [[NSURL alloc] initWithString:kTextURL];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
	NSHTTPURLResponse* response = nil;  
	NSError* error = nil; 
	NSData *responseData = [NSURLConnection sendSynchronousRequest:req   
                                                 returningResponse:&response   
                                                             error:&error];  
    if (response == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:@"Unable to contact server."
                                                       delegate:nil 
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSInteger statusCode = [response statusCode];
    NSString *contentType = [[response allHeaderFields] objectForKey:@"Content-Type"];
    
	if (statusCode >= 200 && statusCode < 300 && [contentType hasPrefix:@"text"]) {
        NSString *payloadAsString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        textView.text = payloadAsString;
        [payloadAsString release];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" 
                                                        message:[NSString stringWithFormat:@"Encountered %d error while loading", statusCode]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Bummer"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
	[url release];
	[req release];
    requestType = kRequestTypeImage;
    [self performSelector:@selector(clear) withObject:nil afterDelay:5.0];
}
- (IBAction)getTextAsynchronously {
    [spinner startAnimating];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kTextURL]];
    NSURLConnection *con =[[NSURLConnection alloc] initWithRequest:req 
                                                          delegate:self];
    if (con) {
        NSMutableData *data = [[NSMutableData alloc] init];
        self.receivedData=data;
        [data release];
        requestType = kRequestTypeText;
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
#pragma mark -
- (void)viewDidUnload {
    self.spinner = nil;
    self.imageView = nil;
    self.textView = nil;
}
- (void)dealloc {
    [spinner release];
    [imageView release];
    [textView release];
    [receivedData release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSURLConnection Callbacks
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Can check response code here
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
    [spinner stopAnimating];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (requestType == kRequestTypeImage) {
        imageView.hidden = NO;
        textView.hidden = YES;
        imageView.image = [UIImage imageWithData:receivedData];
    }
    else {
        imageView.hidden = YES;
        textView.hidden = NO;
        NSString *payloadAsString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        textView.text = payloadAsString;
        [payloadAsString release];
    }
    
    [connection release];
    self.receivedData = nil;
    [spinner stopAnimating];
    [self performSelector:@selector(clear) withObject:nil afterDelay:5.0];
}
@end
