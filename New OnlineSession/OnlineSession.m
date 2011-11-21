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
    if ((self = [super init]))
    {
        
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
        firstPacket = YES;
        
    } 
    return self;
}
- (BOOL)sendData:(NSData *)data error:(NSError **)error 
{
    
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
                
                if ([inStream hasBytesAvailable]) 
                {
                    

                    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cache.dat"];
                    
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
                        [[NSFileManager defaultManager] createFileAtPath:cachePath contents:nil attributes:nil];
                    
                    
                    
                    NSInteger       bytesRead;
                    static uint8_t  buffer[kBufferSize];
                    
                    if (firstPacket)
                    {
                        firstPacket = NO;
                        uint64_t lengthIn;
                        bytesRead = [inStream read:(unsigned char *)&lengthIn maxLength:sizeof(uint64_t)];
                        if (bytesRead != sizeof(uint64_t))
                            NSLog(@"zoiks!");
                        currentTargetLength = lengthIn;
                    }
                    
                    
                    bytesRead = [inStream read:buffer maxLength:kBufferSize];
                    if (bytesRead == -1 && [delegate respondsToSelector:@selector(onlineSession:encounteredReadError:)]) 
                    {
                        NSError *error = [[NSError alloc] initWithDomain:kOnlineSessionErrorDomain code:kDataReadErrorCode userInfo:nil];
                        [delegate onlineSession:self encounteredReadError:error];
                        [error release];
                        return;
                    } 
                    else if (bytesRead > 0) 
                    {
                        NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:cachePath];
                        [handle seekToEndOfFile];
                        [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
                        totalBytesRead += bytesRead;
                       
                        if (totalBytesRead >= currentTargetLength)
                        {
                            NSFileHandle *handle2 = [NSFileHandle fileHandleForReadingAtPath:cachePath];
                            NSData *completeData = [handle2 readDataOfLength:currentTargetLength];
                            [delegate onlineSession:self receivedData:completeData];
                            
                            NSData *remainder = [handle readDataToEndOfFile];
                            if ([remainder length] > 0L)
                            {
                                const uint64_t *header = [remainder bytes];
                                
                                currentTargetLength = *header;
                                NSData *remainderData = [NSData dataWithBytesNoCopy:(void *)header + sizeof(uint64_t) length:[remainder length] - sizeof(uint64_t)];

                                [remainderData writeToFile:cachePath atomically:NO];
                            }
                            else
                            {
                                firstPacket = YES;
                                currentTargetLength = 0L;
                                totalBytesRead = 0L;
                                
                                [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
                                
                            }
                        }
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
