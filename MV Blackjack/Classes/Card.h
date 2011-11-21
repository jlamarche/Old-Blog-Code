//
//  Card.h
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import <UIKit/UIKit.h>

typedef enum cardSuits {
	kSuitDiamonds,
	kSuitClubs,
	kSuitHearts,
	kSuitSpades
} CardSuit;

typedef enum cardValues {
	kAce,
	kTwo,
	kThree,
	kFour,
	kFive,
	kSix,
	kSeven,
	kEight,
	kNine,
	kTen,
	kJack,
	kQueen,
	kKing
} CardValue;

#define kPossibleCardValues			[NSArray arrayWithObjects:@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", nil]
#define kCardNames                  [NSArray arrayWithObjects:@"Ace", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Jack", @"Queen", @"King", nil]
#define kSuitNames					[NSArray arrayWithObjects:@"Diamonds", @"Clubs", @"Hearts", @"Spades", nil]

@interface Card : NSObject {
	CardSuit	suit;
	CardValue	value;
	NSArray		*possibleCardValues;
	NSArray		*suitNames;
	NSArray		*cardNames;
	
	BOOL		frontShowing;
}
@property CardSuit suit;
@property CardValue value;
@property (nonatomic, retain) NSArray *possibleCardValues;
@property (nonatomic, retain) NSArray *suitNames;
@property (nonatomic, retain) NSArray *cardNames;
@property BOOL frontShowing;
- (id)initWithSuit:(CardSuit)theSuit andValue:(NSUInteger)theValue;
- (NSString *)cardValueAsString;
- (NSString *)cardFullName;
- (NSString *)imageName;
@end
