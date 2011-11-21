#import "PacketCategories.h"

@implementation NSArray(PacketSend)
-(NSData *)contentsForTransfer {
    NSMutableData *ret = [NSMutableData data];
    for (NSData *oneData in self) {
        
        if (![oneData isKindOfClass:[NSData class]]) 
            [NSException raise:kInvalidObjectException format:@"arrayContentsForTransfer only supports instances of NSData"];
        
        uint64_t dataSize[1];
        dataSize[0] = [oneData length];
        [ret appendBytes:dataSize length:sizeof(uint64_t)];
        [ret appendBytes:[oneData bytes] length:[oneData length]];
    }
    return ret;
}
@end

@implementation NSData(PacketSplit)
- (NSArray *)splitTransferredPackets:(NSData **)leftover {

    NSMutableArray *ret = [NSMutableArray array];
    const unsigned char *beginning = [self bytes];
    const unsigned char *offset = [self bytes];
    NSInteger bytesEnd = (NSInteger)offset + [self length];
    
    while ((NSInteger)offset < bytesEnd) {
        uint64_t dataSize[1];
        NSInteger dataSizeStart = offset - beginning;
        NSInteger dataStart = dataSizeStart + sizeof(uint64_t);

        NSRange headerRange = NSMakeRange(dataSizeStart, sizeof(uint64_t));
        [self getBytes:dataSize range:headerRange];

        
        if (dataStart + dataSize[0] + (NSInteger)offset > bytesEnd) {
            NSInteger lengthOfRemainingData = [self length] - dataSizeStart;
            NSRange dataRange = NSMakeRange(dataSizeStart, lengthOfRemainingData);
            *leftover = [self subdataWithRange:dataRange]; 

            return ret;
        }
        
        NSRange dataRange = NSMakeRange(dataStart, dataSize[0]);
        NSData *parsedData = [self subdataWithRange:dataRange];

        [ret addObject:parsedData];
        offset = offset + dataSize[0] + sizeof(uint64_t);
    }
    return ret;
}
@end