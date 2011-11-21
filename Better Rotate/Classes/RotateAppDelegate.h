#import <UIKit/UIKit.h>

@class RotateViewController;

@interface RotateAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RotateViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RotateViewController *viewController;

@end

