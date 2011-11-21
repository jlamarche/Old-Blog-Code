#import "TicTacToePacket.h"


@implementation TicTacToePacket
@synthesize type;
@synthesize dieRoll;
@synthesize space;
#pragma mark -
- (id)initWithType:(PacketType)inType dieRoll:(NSUInteger)inDieRoll space:(BoardSpace)inSpace {
    if (self = [super init]) {
        type = inType;
        dieRoll = inDieRoll;
        space = inSpace;
    } 
    return self;
}
- (id)initDieRollPacket {
    int roll = dieRoll();
    return [self initWithType:kPacketTypeDieRoll dieRoll:roll space:0];
}
- (id)initDieRollPacketWithRoll:(NSUInteger)inDieRoll {
    return [self initWithType:kPacketTypeDieRoll dieRoll:inDieRoll space:0];
}
- (id)initMovePacketWithSpace:(BoardSpace)inSpace{
    return [self initWithType:kPacketTypeMove dieRoll:0 space:inSpace];
}
- (id)initAckPacketWithDieRoll:(NSUInteger)inDieRoll {
    return [self initWithType:kPacketTypeAck dieRoll:inDieRoll space:0];
}
- (id)initResetPacket {
    return [self initWithType:kPacketTypeReset dieRoll:0 space:0];
}
#pragma mark -
- (NSString *)description {
    NSString *typeString = nil;
    switch (type) {
        case kPacketTypeDieRoll:
            typeString = @"Die Roll";
            break;
        case kPacketTypeMove:
            typeString = @"Move";
            break;
        case kPacketTypeAck:
            typeString = @"Ack";
            break;
        case kPacketTypeReset:
            typeString = @"Reset";
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@ (dieRoll: %d / space: %d)", typeString, dieRoll, space];
}

#pragma mark -
#pragma mark NSCoder (Archiving)
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:[self type] forKey:@"type"];
    [coder encodeInteger:[self dieRoll] forKey:@"dieRoll"];
    [coder encodeInt:[self space] forKey:@"space"];
}

- (id)initWithCoder:(NSCoder *)coder  {
    if (self = [super init]) {
        [self setType:[coder decodeIntForKey:@"type"]];
        [self setDieRoll:[coder decodeIntegerForKey:@"dieRoll"]];
        [self setSpace:[coder decodeIntForKey:@"space"]];
    }
    return self;
}
@end