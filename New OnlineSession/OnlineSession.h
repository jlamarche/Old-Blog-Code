#import <Foundation/Foundation.h>
#define kOnlineSessionErrorDomain   @"Online Session Domain"
#define kFailedToSendDataErrorCode  1000
#define kDataReadErrorCode          1001

#define kBufferSize                 1024

@class OnlineSession;
@protocol OnlineSessionDelegate
- (void)onlineSession:(OnlineSession *)session receivedData:(NSData *)data;
@optional
- (void)onlineSessionReadyForUse:(OnlineSession *)session;
- (void)onlineSession:(OnlineSession *)session encounteredReadError:(NSError *)error;
- (void)onlineSession:(OnlineSession *)session encounteredWriteError:(NSError *)error;
- (void)onlineSessionDisconnected:(OnlineSession *)session;
@end


@interface OnlineSession : NSObject <NSStreamDelegate> {
    
    id                          delegate;
    
    NSInputStream               *inStream;
    NSOutputStream              *outStream;
    
    BOOL                        writeReady;
    BOOL                        readReady;
    
    NSMutableArray              *packetQueue;

    NSData                      *readLeftover;
    NSData                      *writeLeftover;
    
    @private
    BOOL                        firstPacket;
    uint64_t                    currentTargetLength;
    uint64_t                    totalBytesRead;
    
}
@property (nonatomic, assign) id<OnlineSessionDelegate> delegate;

- (id)initWithInputStream:(NSInputStream *)theInStream outputStream:(NSOutputStream *)theOutStream;
- (BOOL)sendData:(NSData *)data error:(NSError **)error;
- (BOOL)isReadyForUse;
@end


