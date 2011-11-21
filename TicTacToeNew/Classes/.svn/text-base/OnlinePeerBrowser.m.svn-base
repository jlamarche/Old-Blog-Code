#import "OnlinePeerBrowser.h"
#import "TicTacToeViewController.h"

@implementation OnlinePeerBrowser
@synthesize tableView;
@synthesize netServiceBrowser;
@synthesize discoveredServices;

#pragma mark -
#pragma mark Action Methods
- (IBAction)cancel {
    [self.netServiceBrowser stop];
    self.netServiceBrowser.delegate = nil;
    self.netServiceBrowser = nil;
    
    [(TicTacToeViewController *)self.parentViewController browserCancelled];
}
#pragma mark -
#pragma mark Superclass Overrides
- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSNetServiceBrowser *theBrowser = [[NSNetServiceBrowser alloc] init];
    theBrowser.delegate = self;
    
    [theBrowser searchForServicesOfType:kBonjourType inDomain:@""];
    self.netServiceBrowser = theBrowser;
    [theBrowser release];
    
    self.discoveredServices = [NSMutableArray array];
    
}

- (void)viewDidUnload {
    self.tableView = nil;
}
- (void)dealloc {
    [tableView release];
    if (netServiceBrowser != nil) {
        [self.netServiceBrowser stop];
        self.netServiceBrowser.delegate = nil;       
    }
    [netServiceBrowser release];
    [discoveredServices release];
    [super dealloc];
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [discoveredServices count];
}
- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section {
    return NSLocalizedString(@"Available Peers", @"Available Peers");
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Browser Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[discoveredServices objectAtIndex:row] name];
    return cell;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNetService *selectedService = [discoveredServices objectAtIndex:[indexPath row]];
    selectedService.delegate = self.parentViewController;
    [selectedService resolveWithTimeout:0.0];
    
    TicTacToeViewController *parent = (TicTacToeViewController *)self.parentViewController;
    parent.netService = selectedService;
    
    [self.netServiceBrowser stop];
    
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Net Service Browser Delegate Methods
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser {
    self.netServiceBrowser.delegate = nil;
    self.netServiceBrowser = nil; 
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
             didNotSearch:(NSDictionary *)errorDict {
    NSLog(@"Error browsing for service: %@", [errorDict objectForKey:NSNetServicesErrorCode]);
    [self.netServiceBrowser stop];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
           didFindService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing {
    TicTacToeViewController *parent = (TicTacToeViewController *)self.parentViewController;
    if (![[parent.netService name] isEqualToString:[aNetService name]]){
        [discoveredServices addObject:aNetService];

    }
    
    if(!moreComing) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [discoveredServices sortUsingDescriptors:[NSArray arrayWithObject:sd]];
        [sd release];
        [self.tableView reloadData];
    }
        
    
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing {
    [discoveredServices removeObject:aNetService];
    
    if(!moreComing)
        [self.tableView reloadData];
}

@end