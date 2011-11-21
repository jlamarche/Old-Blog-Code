//
//  Card.m
//  ©2008 Jeff LaMarche
//
// This code maybe used for any purpose, commercial or otherwise, without limitation.
// You may redistribute in whole or part, as well as create derivative works.
// You are NOT obligated to attribute the author, and you are NOT required to publish
// the source for projects that use this code.
//
// This code is provided with no warranty, express or implied. Use at your own risk.

#import "Card.h"

@implementation Card
@synthesize suit;
@synthesize value;
@synthesize frontShowing;
@synthesize possibleCardValues;
@synthesize suitNames;
@synthesize cardNames;
#pragma mark -
- (id)init
{
	return [self initWithSuit:0 andValue:0];
}
- (id)initWithSuit:(CardSuit)theSuit andValue:(NSUInteger)theValue
{
	if (self = [super init])
	{
		self.suit = theSuit;
		self.value = theValue;
		self.possibleCardValues = kPossibleCardValues;
		self.suitNames = kSuitNames;
		self.cardNames = kCardNames;
		self.frontShowing = YES;
	}
	return self;
}
- (NSString *)cardValueAsString
{
	return [possibleCardValues objectAtIndex:value];
}
- (NSString *)cardFullName
{
	return [NSString stringWithFormat:@"%@ of %@", [cardNames objectAtIndex:value], [suitNames objectAtIndex:suit]];
}
- (NSString *)imageName
{
	if (!frontShowing)
		return @"back";
	return [NSString stringWithFormat:@"%@%@",[[[suitNames objectAtIndex:suit] lowercaseString] substringToIndex:1], [[possibleCardValues objectAtIndex:value] lowercaseString]];
}

#pragma mark -
- (NSString *)description 
{
	return [self cardFullName];
}
- (void)dealloc 
{
	[possibleCardValues release];
	[suitNames release];
	[cardNames release];
    [super dealloc];
}
@end
