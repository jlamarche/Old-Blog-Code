#import "TicTacToeViewController.h"
#import "TicTacToePacket.h"
#import "OnlinePeerBrowser.h"

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
        
        
        OnlinePeerBrowser *controller = [[OnlinePeerBrowser alloc] 
                                         initWithNibName:@"OnlinePeerBrowser" bundle:nil];
        [self presentModalViewController:controller animated:YES];
        [controller release];   
    }
}
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
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
@end
