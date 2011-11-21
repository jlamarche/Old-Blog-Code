#import <Foundation/Foundation.h>
#define kOnlineListenerErrorDomain           @"Online Session Listener Session Domain"
#define kOnlineListenerErrorNoSocketsAvailable    1000
#define kOnlineListenerErrorCouldntBindToAddress  1001
#define kOnlineListenerErrorStreamError           1002

@class OnlineListener;
@protocol OnlineListenerDelegate
- (void) acceptedConnectionForListener:(OnlineListener *)theListener 
                           inputStream:(NSInputStream *)theInputStream 
                          outputStream:(NSOutputStream *)theOutputStream;
@optional
- (void) onlineListener:(OnlineListener *)theListener
       encounteredError:(NSError *)error;
@end

@interface OnlineListener : NSObject {
    id delegate;
    uint16_t port;
	CFSocketRef socket;
}
@property (nonatomic, assign) id<OnlineListenerDelegate> delegate;
@property uint16_t  port;

- (BOOL)startListening:(NSError **)error;
- (void)stopListening;
@end