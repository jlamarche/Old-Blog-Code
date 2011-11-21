// -----------------------------------------------------------------------------------
// NSImage-Resolution.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Sun May 12 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <AppKit/AppKit.h>

/*!
@header NSImage-Resolution.h

This category adds two instance methods to NSImage that operate on the resolution of an NSImage with at least one NSBitmapImageRep
*/

/*!
@category NSImage(Normalize)
@discussion This category adds two instance methods that operate on the resolution of an NSImage with at least one NSBitmapImageRep
 */
@interface NSImage (normalize)

/*!
@method normalizeSize
@abstract Normalize the resolution to 72 dpi in lossless fashion so that the image displays at full size onscreen.
@result NSImage with the exact same data as the instance it is called on <i>except</i> that the resolution pixelHeight will be the same as the height and the pixelWidth will be the same as the width.
 */
- (NSImage *) normalizeSize;

/*!
 @method setDPI:
 @abstract Allows you to adjust (in a lossless fashion) the resolution of the images NSBitmapImageRep (if it has one) to a given
            number of points per inch.
 @param dpi Integer value representing the desired horizontal and vertical pixels per inch.
 @result Self with the data unaltered except for the height and width (pixelHeight and pixelWidth remain unchanged) of the first NSBitmapRep the image contains.
 */
- (NSImage *) setDPI:(int)dpi;
@end

