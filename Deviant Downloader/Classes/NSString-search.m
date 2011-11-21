
#import "NSString-search.h"


@implementation NSString(search)
- (NSRange) rangeAfterString:(NSString *)inString1 toStartOfString:(NSString *)inString2
{
    NSRange result;
    NSRange stringStart = NSMakeRange(0,0);
    unsigned int foundLocation = 0;
    NSRange stringEnd = NSMakeRange(NSMaxRange(NSMakeRange(0,[self length])),0); // if no end string, end here
    NSRange endSearchRange;
    if (nil != inString1)
    {
        stringStart = [self rangeOfString:inString1 options:0 range:NSMakeRange(0,[self length])];
        if (NSNotFound == stringStart.location)
        {
            return stringStart;	// not found
        }
        foundLocation = NSMaxRange(stringStart);
    }
    endSearchRange = NSMakeRange( foundLocation, NSMaxRange(NSMakeRange(0,[self length])) - foundLocation );
    if (nil != inString2)
    {
        stringEnd = [self rangeOfString:inString2 options:0 range:endSearchRange];
        if (NSNotFound == stringEnd.location)
        {
            return stringEnd;	// not found
        }
    }
    result = NSMakeRange (stringStart.location + [inString1 length], NSMaxRange(stringEnd) - stringStart.location - [inString2 length] - [inString1 length] );
    return result;
}
@end
