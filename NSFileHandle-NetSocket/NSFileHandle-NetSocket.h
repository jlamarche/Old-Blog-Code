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


#import <Cocoa/Cocoa.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
@interface NSFileHandle (NetSocket) 
/*!
	This method will return an autoreleased NSFileHandle connected to 
	the remote server and port specified; nil if unable to connect
 */
+(NSFileHandle *)fileHandleToRemoteHost:(NSString *)address onPort:(UInt16)port;
/*!
	This method will send data to the server and then call a specified 
	method to process that data as it comes in. It is functionallity the
	same as calling writeLine:usingEncoding:withObserver:andProcessWith:
	specifying NSUTF8StringEncoding for the encoding.
 */
-(void)writeLine:(NSString *)line  withObserver:(id)target andProcessWith:(SEL)process;
/*!
	This method will send data to the remote server and then call a
	specified method (possibly more than once) to process data that
	is returned from the server. The method you specify in the
	process method should look something like this:
 
	-(void)process:(id)notification
	{
		NSFileHandle *fh = [notification object];
		NSMutableData *data = [fh availableData];
		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		// Process the data however you need to 
		[dataString release];
		if (booleanVariableThatIndicatesIfWeExpectMoreData)
			[fh readInBackgroundAndNotify];
		}
*/
-(void)writeLine:(NSString *)line usingEncoding:(NSStringEncoding)encoding withObserver:(id)observer andProcessWith:(SEL)process;
@end
