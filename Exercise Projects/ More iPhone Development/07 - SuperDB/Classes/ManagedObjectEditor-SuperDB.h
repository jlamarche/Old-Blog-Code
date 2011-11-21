#import "ManagedObjectEditor.h"

@interface ManagedObjectEditor (HeroEditor)
+ (id)controllerForHero;
- (id)initHeroEditor;
@end

@interface ManagedObjectEditor (PowerEditor)
+ (id)controllerForPower;
- (id)initPowerEditor;
@end