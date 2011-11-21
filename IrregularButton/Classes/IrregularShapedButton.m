#import "IrregularShapedButton.h"
#import "UIImage-Alpha.h"

@implementation IrregularShapedButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint([self bounds], point))
		return nil;
	else 
    {
        UIImage *displayedImage = [self imageForState:[self state]];
        if (displayedImage == nil) // No image found, try for background image
            displayedImage = [self backgroundImageForState:[self state]];
        if (displayedImage == nil) // No image could be found, fall back to 
            return self;
        BOOL isTransparent = [displayedImage isPointTransparent:point];
        if (isTransparent)
            return nil;

	}

    return self;
}
@end
