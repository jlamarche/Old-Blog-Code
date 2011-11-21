#import "OnlineListener.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>

#pragma mark CFNetwork C Callbacks
static void onlineListenerAcceptCallback (CFSocketRef theSocket, CFSocketCallBackType theType, CFDataRef theAddress, const void *data, void *info) {
    OnlineListener *listener = (OnlineListener *)info;
    id listenerDelegate = listener.delegate;
    if (theType == kCFSocketAcceptCallBack) { 
        CFSocketNativeHandle nativeSocket = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t namelen = sizeof(name);
        NSData *peer = nil;
        if (getpeername(nativeSocket, (struct sockaddr *)name, &namelen) == 0) {
            peer = [NSData dataWithBytes:name length:namelen];
        }
        CFReadStreamRef readStream = NULL;
		CFWriteStreamRef writeStream = NULL;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocket, &readStream, &writeStream);
        if (readStream && writeStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            if (listenerDelegate && [listenerDelegate respondsToSelector:@selector(acceptedConnectionForListener:inputStream:outputStream:)]) { 
                [listenerDelegate acceptedConnectionForListener:listener inputStream:(NSInputStream *)readStream outputStream:(NSOutputStream *)writeStream];
            }
        } else {
            close(nativeSocket);
            if ([listenerDelegate respondsToSelector:@selector(onlineListener:encounteredError:)]) {
                NSError *error = [[NSError alloc] initWithDomain:kOnlineListenerErrorDomain code:kOnlineListenerErrorStreamError userInfo:nil];
                [listenerDelegate onlineListener:listener encounteredError:error];
                [error release];
            }
        }
        if (readStream) CFRelease(readStream);
        if (writeStream) CFRelease(writeStream);
    }
}
#pragma mark -
@implementation OnlineListener
@synthesize delegate;
@synthesize port;
#pragma mark -
#pragma mark Listener Methods
- (BOOL)startListening:(NSError **)error {
    CFSocketContext socketCtxt = {0, self, NULL, NULL, NULL};
    socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&onlineListenerAcceptCallback, &socketCtxt);
	
    if (socket == NULL) {
        if (error) *error = [[NSError alloc] initWithDomain:kOnlineListenerErrorDomain 
                                                       code:kOnlineListenerErrorNoSocketsAvailable 
                                                   userInfo:nil];
        return NO;
    }
	
    int ret = 1;
    setsockopt(CFSocketGetNative(socket), SOL_SOCKET, SO_REUSEADDR, (void *)&ret, sizeof(ret));
	
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = 0;
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
	
    if (kCFSocketSuccess != CFSocketSetAddress(socket, (CFDataRef)address4)) {
        if (error) *error = [[NSError alloc] initWithDomain:kOnlineListenerErrorDomain 
                                                       code:kOnlineListenerErrorCouldntBindToAddress 
                                                   userInfo:nil];
        if (socket) 
            CFRelease(socket);
        socket = NULL;
        return NO;
    }
    
	NSData *addr = [(NSData *)CFSocketCopyAddress(socket) autorelease];
	memcpy(&addr4, [addr bytes], [addr length]);
	self.port = ntohs(addr4.sin_port);
	
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0);
    CFRunLoopAddSource(cfrl, source4, kCFRunLoopCommonModes);
    CFRelease(source4);
	
    return ret;
}
- (void)stopListening {
    if (socket) {
		CFSocketInvalidate(socket);
		CFRelease(socket);
		socket = NULL;
	}
}
- (void)dealloc {
    [self stopListening];
    [super dealloc];
}
@end
