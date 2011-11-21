//
//  NSFileHandle-NetSocket.h
//
//	Adds convenience methods for working with sockets to 
//  access remote servers
//
//  Feedback to: jeff_lamarche@mac.com
// 
//	This code may be used and distributed freely with no 
//  restrictions whatsoever. Thanks to the Cocoa-Dev
//	mailing list for helping me get this working!

#import "NSFileHandle-NetSocket.h"

@implementation NSFileHandle (NetSocket)
+(NSFileHandle *)fileHandleToRemoteHost:(NSString *)address onPort:(UInt16)port;
{
	struct sockaddr_in addr;
	bzero( &addr, sizeof(struct sockaddr_in));
	addr.sin_addr.s_addr = inet_addr ([address UTF8String]);
	if (INADDR_NONE == addr.sin_addr.s_addr)
	{
		struct hostent*    theHostInfo;
		
		theHostInfo = gethostbyname ([address UTF8String]);
		if (NULL != theHostInfo)
		{
			addr.sin_family = theHostInfo->h_addrtype;
			memcpy (&addr.sin_addr.s_addr,
					theHostInfo->h_addr,
					theHostInfo->h_length);
		}
	}
    addr.sin_family = AF_INET;
	addr.sin_port = htons( port );
	
    // Create a socket
    int fd = socket( AF_INET, SOCK_STREAM, 0 );
	
	
	if ( connect( fd, (struct sockaddr *)&addr,  sizeof(addr)) < 0 ) 
	{
		NSLog(@"Error connecting to socket");
		return nil;
	}
	
	return [[[NSFileHandle alloc] initWithFileDescriptor:fd] autorelease];	
}
-(void)writeLine:(NSString *)line  withObserver:(id)target andProcessWith:(SEL)process 
{
	return [self writeLine:line usingEncoding:NSUTF8StringEncoding withObserver:target andProcessWith:process];
}
-(void)writeLine:(NSString *)line usingEncoding:(NSStringEncoding)encoding withObserver:(id)observer andProcessWith:(SEL)process 
{
	[self writeData:[line dataUsingEncoding: encoding]];
	[self readInBackgroundAndNotify];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:observer selector:process name:NSFileHandleReadCompletionNotification object:self];
	
}
@end
