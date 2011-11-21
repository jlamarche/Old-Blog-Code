#import "UITabBar-Index.h"

@implementation UITabBar(Index)
- (NSUInteger)selectedIndex {
    return [self.items indexOfObject:self.selectedItem];
}
- (void)setSelectedIndex:(NSUInteger)newIndex {
    self.selectedItem = [self.items objectAtIndex:newIndex];
}
@end
