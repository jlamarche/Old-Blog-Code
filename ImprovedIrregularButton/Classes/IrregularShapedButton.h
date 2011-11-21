#import <UIKit/UIKit.h>

@interface IrregularShapedButton : UIButton {
    NSData  *alphaMask;
    CGFloat alphaMaskWidth;
}
@property (nonatomic, retain) NSData *alphaMask;
@property CGFloat alphaMaskWidth;

@end
