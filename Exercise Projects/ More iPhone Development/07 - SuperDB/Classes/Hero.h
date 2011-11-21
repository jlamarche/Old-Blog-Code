#import <CoreData/CoreData.h>

#define kHeroValidationDomain           @"com.Apress.SuperDB.HeroValidationDomain"
#define kHeroValidationBirthdateCode    1000
#define kHeroValidationNameOrSecretIdentityCode 1001

@class Power;

@interface Hero :  NSManagedObject  
{
}

@property (nonatomic, readonly) NSNumber * age;
@property (nonatomic, retain) NSString * secretIdentity;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthdate;
@property (nonatomic, retain) UIColor * favoriteColor;

@property (nonatomic, retain) NSSet* powers;

@property (nonatomic, readonly) NSArray *olderHeroes;
@property (nonatomic, readonly) NSArray *youngerHeroes;
@property (nonatomic, readonly) NSArray *sameSexHeroes;
@property (nonatomic, readonly) NSArray *oppositeSexHeroes;

@end

@interface Hero (PowerAccessors)
- (void)addPowersObject:(Power *)value;
- (void)removePowersObject:(Power *)value;
- (void)addPowers:(NSSet *)value;
- (void)removePowers:(NSSet *)value;
@end

