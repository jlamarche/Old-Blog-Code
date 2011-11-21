#import <Foundation/Foundation.h>
#define kInvalidObjectException     @"Invalid Object Exception"

@interface NSArray(PacketSend)
-(NSData *)contentsForTransfer;
@end

@interface NSData(PacketSplit)
- (NSArray *)splitTransferredPackets:(NSData **)leftover;
@end
