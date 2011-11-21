#import <CoreData/CoreData.h>

#define kHeroValidationDomain           @"com.Apress.SuperDB.HeroValidationDomain"
#define kHeroValidationBirthdateCode    1000
#define kHeroValidationNameOrSecretIdentityCode 1001

@interface Hero :  NSManagedObject  
{
}

@property (nonatomic, readonly) NSNumber * age;
@property (nonatomic, retain) NSString * secretIdentity;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * birthdate;
@property (nonatomic, retain) UIColor * favoriteColor;

@end



