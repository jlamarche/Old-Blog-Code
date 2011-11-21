#import "IrregularShapedButton.h"
#import "UIImage-Alpha.h"

@implementation IrregularShapedButton
@synthesize alphaMask, alphaMaskWidth;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event; 
{
    
    NSData *rawData = [self alphaMask];  // See about caching this
    if (rawData == nil)
        return self;
    
    NSUInteger index = point.x + (point.y * alphaMaskWidth);
    char *rawDataBytes = (char *)[rawData bytes];
    
    if ( (point.x > self.frame.size.width) || (point.y > self.frame.size.height) )
        return nil;

    return (rawDataBytes[index] == 0) ? nil : self;
    
}
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    self.alphaMask = nil;
    [super setBackgroundImage:image forState:state];
}
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    self.alphaMask = nil;
    [super setImage:image forState:state];
}
- (NSData *)alphaMask
{
    if (alphaMask == nil)
    {
        UIImage *displayedImage = [self imageForState:UIControlStateNormal];
        if (displayedImage == nil) // No image found, try for background image
            displayedImage = [self backgroundImageForState:UIControlStateNormal];
        if (displayedImage == nil) // No image could be found, fall back to 
            return nil;
        
        self.alphaMask = [displayedImage alphaData];
        self.alphaMaskWidth = [displayedImage size].width;
        
    }
    return alphaMask;
}
- (void)dealloc
{
    [alphaMask release];
    [super dealloc];
}
@end
