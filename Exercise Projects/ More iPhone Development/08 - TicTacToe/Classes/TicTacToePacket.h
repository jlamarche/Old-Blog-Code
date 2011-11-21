#import <Foundation/Foundation.h>
#import "TicTacToeViewController.h"

#define dieRoll() (arc4random() % 10000)
#define kDiceNotRolled  INT_MAX

typedef enum PacketTypes {
    kPacketTypeDieRoll,         // used to determine who goes first
    kPacketTypeAck,             // used to acknowledge die roll packet receipt
    kPacketTypeMove,            // used to send information about a player's move
    kPacketTypeReset,           // used to inform the peer that we're starting over
} PacketType;

@interface TicTacToePacket : NSObject {
    PacketType  type;
    NSUInteger  dieRoll;
    BoardSpace  space;
}
@property PacketType type;
@property NSUInteger dieRoll;
@property BoardSpace space;
- (id)initWithType:(PacketType)inType dieRoll:(NSUInteger)inDieRoll space:(BoardSpace)inSpace;
- (id)initDieRollPacket;
- (id)initDieRollPacketWithRoll:(NSUInteger)inDieRoll;
- (id)initMovePacketWithSpace:(BoardSpace)inSpace;
- (id)initAckPacketWithDieRoll:(NSUInteger)inDieRoll;
- (id)initResetPacket;
@end