#import <Foundation/Foundation.h>

@protocol HeroValueDisplay
- (NSString *)heroValueDisplay;
@end

@interface NSString (HeroValueDisplay) <HeroValueDisplay>
- (NSString *)heroValueDisplay;
@end

@interface NSDate (HeroValueDisplay) <HeroValueDisplay>
- (NSString *)heroValueDisplay;
@end

@interface NSNumber (HeroValueDisplay) <HeroValueDisplay>
- (NSString *)heroValueDisplay;
@end

@interface NSDecimalNumber (HeroValueDisplay) <HeroValueDisplay>
- (NSString *)heroValueDisplay;
@end
