#import "OnlineSession.h"
#import "PacketCategories.h"


@interface OnlineSession()
- (void)sendQueuedData;
@end

#pragma mark -
@implementation OnlineSession
@synthesize delegate;

#pragma mark -
- (id)initWithInputStream:(NSInputStream *)theInStream outputStream:(NSOutputStream *)theOutStream {
    if (self = [super init]) {

        inStream = [theInStream retain];
        outStream = [theOutStream retain];
        
        [inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        inStream.delegate = self;
        outStream.delegate = self;
        
        if ([inStream streamStatus] == NSStreamStatusNotOpen)
            [inStream open];
        
        if ([outStream streamStatus] == NSStreamStatusNotOpen)
            [outStream open];
        
        packetQueue = [[NSMutableArray alloc] init];
        
        
    } 
    return self;
}
- (BOOL)sendData:(NSData *)data error:(NSError **)error {
    
    if (data == nil || [data length] == 0)
        return NO;
    
    [packetQueue addObject:data];
    
    if ([outStream hasSpaceAvailable])
        [self sendQueuedData];
    
    return YES;
}
- (BOOL)isReadyForUse {
    return readReady && writeReady;
}
- (void)dealloc {
    [inStream close];
    [inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    inStream.delegate = nil;
    [inStream release];
    
    [outStream close];
    [outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode]; 
    outStream.delegate = nil;
    [outStream release];
    
    [packetQueue release];
    [writeLeftover release];
    [writeLeftover release];
    
    [super dealloc];
}
- (void) stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
		case NSStreamEventOpenCompleted:
            if (stream == inStream)
                readReady = YES;
            else
                writeReady = YES;
            if ([self isReadyForUse] && [delegate respondsToSelector:@selector(onlineSessionReadyForUse:)])
                [delegate onlineSessionReadyForUse:self];
            
            break;
        case NSStreamEventHasBytesAvailable:
            if (stream == inStream) {
                
                if ([inStream hasBytesAvailable]) {
                    
                    NSMutableData *data = [NSMutableData data];
                    
                    if (readLeftover != nil) {
                        [data appendData:readLeftover];
                        [readLeftover release];
                        readLeftover = nil;
                    }
                    
                    NSInteger       bytesRead;
                    static uint8_t  buffer[kBufferSize];
                    
                    bytesRead = [inStream read:buffer maxLength:kBufferSize];
                    if (bytesRead == -1 && [delegate respondsToSelector:@selector(onlineSession:encounteredReadError:)]) {
                        NSError *error = [[NSError alloc] initWithDomain:kOnlineSessionErrorDomain code:kDataReadErrorCode userInfo:nil];
                        [delegate onlineSession:self encounteredReadError:error];
                        [error release];
                        return;
                    } 
                    else if (bytesRead > 0) {
                        [data appendBytes:buffer length:bytesRead];
                        
                        NSArray *dataPackets = [data splitTransferredPackets:&readLeftover];
                        
                        if (readLeftover)
                            [readLeftover retain];
                        
                        for (NSData *onePacketData in dataPackets)
                            [delegate onlineSession:self receivedData:onePacketData];
                    }
                }
			}
            break;
        case NSStreamEventErrorOccurred: {
            NSError *theError = [stream streamError];
            if (stream == inStream)
                if (delegate && [delegate respondsToSelector:@selector(onlineSession:encounteredReadError:)])
                    [delegate onlineSession:self encounteredReadError:theError];
                else{
                    if (delegate && [delegate respondsToSelector:@selector(onlineSession:encounteredWriteError:)])
                        [delegate onlineSession:self encounteredWriteError:theError];   
                }
            
            break;
        }
        case NSStreamEventHasSpaceAvailable:
            if (stream == outStream) {
                [self sendQueuedData];
            }
            break;
        case NSStreamEventEndEncountered:
            if (delegate && [delegate respondsToSelector:@selector(onlineSessionDisconnected:)])
                [delegate onlineSessionDisconnected:self];
            readReady = NO;
            writeReady = NO;
            break;
        default:
            break;
    }
}
- (void)sendQueuedData {
    
    if (writeLeftover == nil && [packetQueue count] == 0)
        return; // Nothing to send!
    
    NSMutableData *dataToSend = [NSMutableData data];
    
    if (writeLeftover != nil) {
        [dataToSend appendData:writeLeftover];
        [writeLeftover release];
        writeLeftover = nil;
    }
    
    [dataToSend appendData:[packetQueue contentsForTransfer]];
    [packetQueue removeAllObjects];
    
    NSUInteger sendLength = [dataToSend length];
    NSUInteger written = [outStream write:[dataToSend bytes] maxLength:sendLength];
    
    if (written == -1) {
        if (delegate && [delegate respondsToSelector:@selector(onlineSession:encounteredWriteError:)]) 
            [delegate onlineSession:self encounteredWriteError:[outStream streamError]];
    } 
    if (written != sendLength) {
        NSRange leftoverRange = NSMakeRange(written, [dataToSend length] - written);
        writeLeftover = [[dataToSend subdataWithRange:leftoverRange] retain];
        
    }
}
@end
