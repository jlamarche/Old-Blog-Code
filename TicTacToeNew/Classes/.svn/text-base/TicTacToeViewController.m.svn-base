#import "TicTacToeViewController.h"
#import "TicTacToePacket.h"
#import "OnlinePeerBrowser.h"
#import <QuartzCore/QuartzCore.h>

@interface TicTacToeViewController()
- (void)showErrorAlertWithTitle:(NSString *)title message:(NSString *)message;
@end

@implementation TicTacToeViewController
#pragma mark -
#pragma mark Synthesized Properties
@synthesize newGameButton;
@synthesize feedbackLabel;
@synthesize session;
@synthesize peerID;
@synthesize state;
@synthesize xPieceImage;
@synthesize oPieceImage;

@synthesize netService;
@synthesize onlineSession;
@synthesize onlineSessionListener;

@synthesize peerBrowserView;
@synthesize peerBrowserTopLabel;
@synthesize peerBrowserBottomLabel;
@synthesize peerBrowserActivityIndicator;
@synthesize peerBrowserDeviceIcon;
@synthesize peerBrowserCancelButton;
@synthesize discoveredServices;
@synthesize netServiceBrowser;
@synthesize peerBrowserTable;
@synthesize peerBrowserChooseLabel;

#pragma mark -
#pragma mark Private Methods
- (void)showErrorAlertWithTitle:(NSString *)alertTitle message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:message delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer") 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
#pragma mark -
#pragma mark Game-Specific Methods
- (IBAction)newGameButtonPressed {
    
    dieRollReceived = NO;
    dieRollAcknowledged = NO;
    
    
    newGameButton.hidden = YES;
    GKPeerPickerController*		picker;
	
    
	picker = [[GKPeerPickerController alloc] init]; 
	picker.delegate = self;    
    
    picker.connectionTypesMask = GKPeerPickerConnectionTypeOnline | GKPeerPickerConnectionTypeNearby;
	[picker show];
}
- (IBAction)gameSpacePressed:(id)sender {
    UIButton *buttonPressed = (UIButton *)sender;
    if (state == kGameStateMyTurn && [buttonPressed imageForState:UIControlStateNormal] == nil){
        [buttonPressed setImage:(piece == kPlayerPieceO) ? oPieceImage : xPieceImage forState:UIControlStateNormal];
        feedbackLabel.text = NSLocalizedString(@"Opponent's Turn", @"Opponent's Turn");
        state = kGameStateOpponentTurn;
        
        
        TicTacToePacket *packet = [[TicTacToePacket alloc] initMovePacketWithSpace:buttonPressed.tag];
        [self sendPacket:packet];
        [packet release];
        
        [self checkForGameEnd];
    }
    
}
- (IBAction)cancelPeerSearch {
    [self.peerBrowserView removeFromSuperview];
    newGameButton.hidden = NO;
    [discoveredServices removeAllObjects];
}
- (void)startNewGame {
    [self resetBoard];
    [self sendDieRoll];
}
- (void)resetBoard {    
    for (int i = kUpperLeft; i <= kLowerRight; i++) {
        UIButton *oneButton = (UIButton *)[self.view viewWithTag:i];
        [oneButton setImage:nil forState:UIControlStateNormal];
    }
    
    feedbackLabel.text = @"";
    
    TicTacToePacket *resetPacket = [[TicTacToePacket alloc] initResetPacket];
    [self sendPacket:resetPacket];
    [resetPacket release];
    
    piece = kPlayerPieceUndecided;
    
}
- (void)resetDieState {
    
    dieRollReceived = NO;
    dieRollAcknowledged = NO;
    myDieRoll = kDiceNotRolled;
    opponentDieRoll = kDiceNotRolled;
}
- (void)startGame {
    if (myDieRoll == opponentDieRoll) {
        myDieRoll = kDiceNotRolled;
        opponentDieRoll = kDiceNotRolled;
        [self sendDieRoll];
        piece = kPlayerPieceUndecided;
    }
    else if (myDieRoll < opponentDieRoll) {
        state = kGameStateOpponentTurn;
        piece = kPlayerPieceX;
        feedbackLabel.text = NSLocalizedString(@"Opponent's Turn", @"Opponent's Turn");
        
    }
    else {
        state = kGameStateMyTurn;
        piece = kPlayerPieceO;
        feedbackLabel.text = NSLocalizedString(@"Your Turn", @"Your Turn");
        
    }
    [self resetDieState];
}
- (void)checkForGameEnd {
    NSInteger moves = 0;
    
    UIImage     *currentButtonImages[9];
    UIImage     *winningImage = nil;
    
    for (int i = kUpperLeft; i <= kLowerRight; i++) {
        UIButton *oneButton = (UIButton *)[self.view viewWithTag:i];
        if ([oneButton imageForState:UIControlStateNormal])
            moves++;
        currentButtonImages[i - kUpperLeft] = [oneButton imageForState:UIControlStateNormal];
    }
    
    // Top Row
    if (currentButtonImages[0] == currentButtonImages[1] && currentButtonImages[0] == currentButtonImages[2] && currentButtonImages[0] != nil)
        winningImage = currentButtonImages[0];
    // Middle Row
    else if (currentButtonImages[3] == currentButtonImages[4] && currentButtonImages[3] == currentButtonImages[5] && currentButtonImages[3] != nil)
        winningImage = currentButtonImages[3];
    // Bottom Row
    else if (currentButtonImages[6] == currentButtonImages[7] && currentButtonImages[6] == currentButtonImages[8] && currentButtonImages[6] != nil)
        winningImage = currentButtonImages[6];
    // Left Column
    else if (currentButtonImages[0] == currentButtonImages[3] && currentButtonImages[0] == currentButtonImages[6] && currentButtonImages[0] != nil)
        winningImage = currentButtonImages[0];
    // Middle Column
    else if (currentButtonImages[1] == currentButtonImages[4] && currentButtonImages[1] == currentButtonImages[7] && currentButtonImages[1] != nil)
        winningImage = currentButtonImages[1];
    // Right Column
    else if (currentButtonImages[2] == currentButtonImages[5] && currentButtonImages[2] == currentButtonImages[8] && currentButtonImages[2] != nil)
        winningImage = currentButtonImages[2];
    // Diagonal starting top left
    else if (currentButtonImages[0] == currentButtonImages[4] && currentButtonImages[0] == currentButtonImages[8] && currentButtonImages[0] != nil)
        winningImage = currentButtonImages[0];
    else if (currentButtonImages[2] == currentButtonImages[4] && currentButtonImages[2] == currentButtonImages[6] && currentButtonImages[2] != nil)
        winningImage = currentButtonImages[2];
    
    
    if (winningImage == xPieceImage) {
        if (piece == kPlayerPieceX) {
            feedbackLabel.text = NSLocalizedString(@"You Won!", @"You Won!");
            state = kGameStateDone;
        }
        else {
            feedbackLabel.text = NSLocalizedString(@"Opponent Won!", @"Opponent Won!");
            state = kGameStateDone;
        }
    }
    else if (winningImage == oPieceImage) {
        if (piece == kPlayerPieceO){
            feedbackLabel.text = NSLocalizedString(@"You Won!", @"You Won!");
            state = kGameStateDone;
        }
        else {
            feedbackLabel.text = NSLocalizedString(@"Opponent Won!", @"Opponent Won!");
            state = kGameStateDone;
        }
        
    }
    else {
        if (moves >= 9) {
            feedbackLabel.text = NSLocalizedString(@"Cat Wins!", @"Cat Wins!");
            state = kGameStateDone;
        }
    }
    
    if (state == kGameStateDone)
        [self performSelector:@selector(startNewGame) withObject:nil afterDelay:3.0];
}
- (void)handleReceivedData:(NSData *)data {
    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] 
                                     initForReadingWithData:data];
    TicTacToePacket *packet = [unarchiver decodeObjectForKey:kTicTacToeArchiveKey];
    
    switch (packet.type) {
        case kPacketTypeDieRoll:
            opponentDieRoll = packet.dieRoll;
            TicTacToePacket *ack = [[TicTacToePacket alloc] 
                                    initAckPacketWithDieRoll:opponentDieRoll];
            [self sendPacket:ack];
            [ack release];
            dieRollReceived = YES;
            break;
        case kPacketTypeAck:
            if (packet.dieRoll != myDieRoll) {
                NSLog(@"Ack packet doesn't match opponentDieRoll (mine: %d, send: %d", packet.dieRoll, myDieRoll);
            }
            dieRollAcknowledged = YES;
            break;
        case kPacketTypeMove:{
            UIButton *theButton = (UIButton *)[self.view viewWithTag:packet.space];
            [theButton setImage:(piece == kPlayerPieceO) ? xPieceImage : oPieceImage 
                       forState:UIControlStateNormal];
            state = kGameStateMyTurn;
            feedbackLabel.text = NSLocalizedString(@"Your Turn", @"Your Turn");
            [self checkForGameEnd];
        }
            break;
        case kPacketTypeReset:
            if (state == kGameStateDone)
                [self resetDieState];
        default:
            break;
    }
    
    if (dieRollReceived == YES && dieRollAcknowledged == YES)
        [self startGame];
}
- (void)browserCancelled {
    [self dismissModalViewControllerAnimated:YES];
    newGameButton.hidden = NO;
    feedbackLabel.text = @"";
}
- (void) sendPacket:(TicTacToePacket *)packet {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] 
                                 initForWritingWithMutableData:data];
    [archiver encodeObject:packet forKey:kTicTacToeArchiveKey];
    [archiver finishEncoding];
    
    NSError *error = nil;
    
    if (session) {
        if (![session sendDataToAllPeers:data withDataMode:GKSendDataReliable 
                                   error:&error]) {
            // You will do real error handling
            NSLog(@"Error sending data: %@", [error localizedDescription]);
        } 
    }else {
        if (![onlineSession sendData:data error:&error]) {
            // Ditto
            NSLog(@"Error sending data: %@", [error localizedDescription]);
        }
    }
    [archiver release];
    [data release];
}

#pragma mark -
#pragma mark Superclass Overrides
- (void)viewDidLoad {
    [super viewDidLoad];
    myDieRoll = kDiceNotRolled;
    self.oPieceImage = [UIImage imageNamed:@"O.png"];
    self.xPieceImage = [UIImage imageNamed:@"X.png"];
    
}
- (void)viewDidUnload {
    [super viewDidUnload];
    self.newGameButton = nil;
    self.xPieceImage = nil;
    self.oPieceImage = nil;
    self.peerBrowserView = nil;
    self.peerBrowserTopLabel = nil;
    self.peerBrowserBottomLabel = nil;
    self.peerBrowserActivityIndicator = nil;
    self.peerBrowserDeviceIcon = nil;
    self.peerBrowserCancelButton = nil;
    self.peerBrowserTable = nil;
    self.peerBrowserChooseLabel = nil;
}
- (void)dealloc {
    [newGameButton release];
    
    [xPieceImage release];
    [oPieceImage release];
    
    session.available = NO;
    [session disconnectFromAllPeers];
    [session setDataReceiveHandler: nil withContext: nil];
    session.delegate = nil;
    [session release];
    
    [peerBrowserView release];
    [peerBrowserTopLabel release];
    [peerBrowserBottomLabel release];
    [peerBrowserActivityIndicator release];
    [peerBrowserDeviceIcon release];
    [peerBrowserCancelButton release];
    [discoveredServices release];
    [peerBrowserTable release];
    [peerBrowserChooseLabel release];
    
    if (netServiceBrowser != nil) {
        [self.netServiceBrowser stop];
        self.netServiceBrowser.delegate = nil;       
    }
    
    [super dealloc];
}
#pragma mark -
#pragma mark GameKit Peer Picker Delegate Methods
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type {
    if (type == GKPeerPickerConnectionTypeOnline) {
        picker.delegate = nil;
        [picker dismiss];
        [picker autorelease];
        
        OnlineListener *theListener = [[OnlineListener alloc] init];
        self.onlineSessionListener = theListener;
        theListener.delegate = self;
        [theListener release];
        
        NSError *error;
        if (![onlineSessionListener startListening:&error]) {
            [self showErrorAlertWithTitle:NSLocalizedString(
                                                            @"Error starting listener", @"Error starting listener") 
                                  message:NSLocalizedString(
                                                            @"Unable to start online play", @"Unable to start")];
        }
        
        NSNetService *theService = [[NSNetService alloc] initWithDomain:@"" 
                                                                   type:kBonjourType name:@"" port:onlineSessionListener.port];
        self.netService = theService;
        [theService release];
        
        [self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] 
                                   forMode:NSRunLoopCommonModes];
        [self.netService setDelegate:self];
        [self.netService publish];
        
        

        
        NSNetServiceBrowser *theBrowser = [[NSNetServiceBrowser alloc] init];
        theBrowser.delegate = self;
        
        [theBrowser searchForServicesOfType:kBonjourType inDomain:@""];
        self.netServiceBrowser = theBrowser;
        [theBrowser release];
        
        self.discoveredServices = [NSMutableArray array];
        
        
        [self resizePeerBrowserViewToOriginalSize];
        [self.view addSubview:peerBrowserView];
        peerBrowserView.backgroundColor = [UIColor clearColor];
        
        
        CALayer *viewLayer = self.peerBrowserView.layer;
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        
        animation.duration = 0.35555555;
        animation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0],
                              [NSNumber numberWithFloat:0.6],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], 
                              nil];    
        animation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0],
                              [NSNumber numberWithFloat:0.2],
                              [NSNumber numberWithFloat:0.266666667],
                              [NSNumber numberWithFloat:0.35555555], 
                              nil];    
        
        [viewLayer addAnimation:animation forKey:@"transform.scale"];
        
    }
}
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker 
{
    picker.delegate = nil;
    [picker dismiss];
    [self resetBoard];
    newGameButton.hidden = NO;
    
}
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    GKSession *theSession = [[GKSession alloc] initWithSessionID:kTicTacToeSessionID displayName:nil sessionMode:GKSessionModePeer]; 
    return [theSession autorelease];
}


- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)thePeerID toSession:(GKSession *)theSession {
    self.peerID = thePeerID; 
	
    
	self.session = theSession;
	self.session.delegate = self; 
	[self.session setDataReceiveHandler:self withContext:NULL];
	
	[picker dismiss];
	picker.delegate = nil;
	[picker release];
    
    [self startNewGame];
	
}
#pragma mark -
#pragma mark GameKit Session Delegate Methods


- (void)session:(GKSession *)theSession didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error Connecting!", @"Error Connecting!") 
                                                    message:NSLocalizedString(@"Unable to establish the connection.",@"Unable to establish the connection.") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    theSession.available;
    [theSession disconnectFromAllPeers];
    theSession.delegate = nil;
    [theSession setDataReceiveHandler:nil withContext:nil];
    self.session = nil;
}
- (void)session:(GKSession *)theSession peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)inState {
    
    if (inState == GKPeerStateDisconnected) {
        state = kGameStateInterrupted;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Peer Disconnected!", @"Peer Disconnected!") 
                                                        message:NSLocalizedString(@"Your opponent has disconnected, or the connection has been lost",@"Your opponent has disconnected, or the connection has been lost") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Bummer", @"Bummer")
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        theSession.available;
        [theSession disconnectFromAllPeers];
        theSession.delegate = nil;
        [theSession setDataReceiveHandler:nil withContext:nil];
        self.session = nil;
        
    }
}
#pragma mark -
#pragma mark GameKit Send & Receive Methods
- (void)sendDieRoll {
    state = kGameStateRollingDice;
    TicTacToePacket *rollPacket;
    if (myDieRoll == kDiceNotRolled) {
        rollPacket = [[TicTacToePacket alloc] initDieRollPacket];
        myDieRoll = rollPacket.dieRoll;
    }
    else 
        rollPacket = [[TicTacToePacket alloc] initDieRollPacketWithRoll:myDieRoll];
    
    
    [self sendPacket:rollPacket];
    [rollPacket release];
    
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)theSession context:(void *)context {
    [self handleReceivedData:data];
}
#pragma mark -
#pragma mark Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self resetBoard];
    newGameButton.hidden = NO;
}
#pragma mark -
#pragma mark Net Service Delegate Methods (Publishing)
- (void)netService:(NSNetService *)theNetService
     didNotPublish:(NSDictionary *)errorDict
{
    NSNumber *errorDomain = [errorDict valueForKey:NSNetServicesErrorDomain];
    NSNumber *errorCode = [errorDict valueForKey:NSNetServicesErrorCode];
    [self showErrorAlertWithTitle:NSLocalizedString(@"Unable to connect", 
                                                    @"Unable to connect") message:[NSString 
                                                                                   stringWithFormat:NSLocalizedString(
                                                                                                                      @"Unable to publish Bonjour service(%@/%@)", 
                                                                                                                      @"Unable to publish Bonjour service(%@/%@)"), errorDomain, errorCode] ];
    
    [theNetService stop];
}
- (void)netServiceDidStop:(NSNetService *)netService
{
    self.netService.delegate = nil;
    self.netService = nil;
}
#pragma mark -
#pragma mark Net Service Delegate Methods (General)
- (void)handleError:(NSNumber *)error withService:(NSNetService *)service
{
    [self showErrorAlertWithTitle:NSLocalizedString(@"A network error occurred.", 
                                                    @"A network error occurred.") message:[NSString stringWithFormat:
                                                                                           NSLocalizedString(
                                                                                                             @"An error occurred with service %@.%@.%@, error code = %@", 
                                                                                                             @"An error occurred with service %@.%@.%@, error code = %@"), 
                                                                                           [service name], [service type], [service domain], error]];
}
#pragma mark -
#pragma mark Net Service Delegate Methods (Resolving)
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    
    NSNumber *errorDomain = [errorDict valueForKey:NSNetServicesErrorDomain];
    NSNumber *errorCode = [errorDict valueForKey:NSNetServicesErrorCode];
    [self showErrorAlertWithTitle:NSLocalizedString(@"Unable to connect", 
                                                    @"Unable to connect") message:[NSString stringWithFormat:
                                                                                   NSLocalizedString(@"Could not start game with remote device (%@/%@)", 
                                                                                                     @"Could not start game with remote device (%@/%@)"), errorDomain, 
                                                                                   errorCode] ];
    [sender stop];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service {
    
    [self.onlineSessionListener stopListening];
    self.onlineSessionListener = nil;
    
    NSInputStream *tempIn = nil;
    NSOutputStream *tempOut = nil;
    if (![service getInputStream:&tempIn outputStream:&tempOut]){
        [self showErrorAlertWithTitle:NSLocalizedString(@"Unable to connect", 
                                                        @"Unable to connect") message:NSLocalizedString(
                                                                                                        @"Could not start game with remote device", 
                                                                                                        @"Could not start game with remote device") ];
        return;
    }
    
    OnlineSession *theSession = [[OnlineSession alloc] 
                                 initWithInputStream:tempIn outputStream:tempOut];
    theSession.delegate = self;
    self.onlineSession = theSession;
    [theSession release];
}
#pragma mark -
#pragma mark Online Session Listener Delegate Methods
- (void) acceptedConnectionForListener:(OnlineListener *)theListener 
                           inputStream:(NSInputStream *)theInputStream 
                          outputStream:(NSOutputStream *)theOutputStream {
    OnlineSession *theSession = [[OnlineSession alloc] 
                                 initWithInputStream:theInputStream outputStream:theOutputStream];
    theSession.delegate = self;
    self.onlineSession = theSession;
    
    [theSession release];
    [peerBrowserView removeFromSuperview];
}
#pragma mark -
#pragma mark Online Session Delegate Methods
- (void)onlineSessionReadyForUse:(OnlineSession *)session {
    if (self.modalViewController)
        [self dismissModalViewControllerAnimated:YES];
    
    [self startNewGame];
}
- (void)onlineSession:(OnlineSession *)session receivedData:(NSData *)data {
    [self handleReceivedData:data];
}
- (void)onlineSession:(OnlineSession *)session encounteredReadError:(NSError *)error {
    [self showErrorAlertWithTitle:NSLocalizedString(@"Error reading", 
                                                    @"Error Reading") message:NSLocalizedString(@"Could not read sent packet", 
                                                                                                @"Could not read sent packet")];
    self.onlineSession = nil;
}
- (void)onlineSession:(OnlineSession *)session 
encounteredWriteError:(NSError *)error {
    [self showErrorAlertWithTitle:NSLocalizedString(@"Error Writing", 
                                                    @"Error Writing") message:NSLocalizedString(@"Could not send packet", 
                                                                                                @"Could not send packet")];
    self.onlineSession = nil;
}
- (void)onlineSessionDisconnected:(OnlineSession *)session {
    [self showErrorAlertWithTitle:NSLocalizedString(@"Peer Disconnected", 
                                                    @"Peer Disconnected") message:NSLocalizedString(
                                                                                                    @"Your opponent disconnected or otherwise could not be reached.", 
                                                                                                    @"Your opponent disconnected or otherwise could not be reached")];
    self.onlineSession = nil;
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
    [self resetBoard];
    [self.peerBrowserView removeFromSuperview];
    newGameButton.hidden = NO;
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    
    if (![netService.name isEqualToString:[aNetService name]]){
        [discoveredServices addObject:aNetService];
    }
    
    // after first one, resize table
    if ([discoveredServices count] == 1 )
        [self performSelector:@selector(resizePeerBrowserViewForTable) withObject:nil afterDelay:0.25];
    
    if(!moreComing) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [discoveredServices sortUsingDescriptors:[NSArray arrayWithObject:sd]];
        [sd release];
        [self.peerBrowserTable reloadData];
    }
    
    
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser
         didRemoveService:(NSNetService *)aNetService
               moreComing:(BOOL)moreComing {
    [discoveredServices removeObject:aNetService];
    
    if(!moreComing)
        [self.peerBrowserTable reloadData];
}
#pragma mark Peer Browser Methods
- (void)resizePeerBrowserViewForTable 
{
    [UIView beginAnimations:@"browser resize" context:nil];
    peerBrowserTopLabel.hidden = YES;
    peerBrowserBottomLabel.hidden = YES;
    peerBrowserActivityIndicator.hidden = YES;
    peerBrowserDeviceIcon.hidden = YES;
    peerBrowserChooseLabel.hidden = NO;
    peerBrowserTable.hidden = NO;
    [self.peerBrowserView setFrame:CGRectMake(peerBrowserView.frame.origin.x, peerBrowserView.frame.origin.y - ((kPeerBrowserSearchViewTableHeight - kPeerBrowserSearchViewStartHeight) / 2.f), kPeerBrowserSearchViewStartWidth, kPeerBrowserSearchViewTableHeight)];
    [UIView commitAnimations];
}
- (void)resizePeerBrowserViewToOriginalSize
{
    peerBrowserTopLabel.hidden = NO;
    peerBrowserDeviceIcon.hidden = NO;
    peerBrowserBottomLabel.hidden = NO;
    peerBrowserActivityIndicator.hidden = NO;
    peerBrowserChooseLabel.hidden = YES;
    peerBrowserTable.separatorColor = [UIColor colorWithWhite:.67 alpha:1.0];
    peerBrowserTable.hidden = YES;
    [self.peerBrowserView setFrame:CGRectMake(0.0, 0.0, kPeerBrowserSearchViewStartWidth, kPeerBrowserSearchViewStartHeight)];
    peerBrowserView.center = self.view.superview.center;
}
#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return [discoveredServices count];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Browser Cell Identifier";
    
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    cell.opaque = NO;
    cell.backgroundColor = [UIColor colorWithWhite:.4 alpha:1.0];
    cell.alpha = .9;
    cell.textLabel.text = [[discoveredServices objectAtIndex:row] name];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNetService *selectedService = [discoveredServices objectAtIndex:[indexPath row]];
    selectedService.delegate = self;
    [selectedService resolveWithTimeout:0.0];
    self.netService = selectedService;
    [self.netServiceBrowser stop];
    [self.peerBrowserView removeFromSuperview];

}
@end
