// -----------------------------------------------------------------------------------
//  NSBarcodeImageView.h
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Thu May 16 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import <AppKit/AppKit.h>
/*!
@header NKDBarcodeImageView.h

Subclass of NSView that allows dragging of the resolution independent barcode image to any view that accepts PDF data from the drag pasteboard.
*/

/*!
@class NKDBarcodeImageView
@discussion This simple subclass of NSImageView simply puts the view's PDF data on the drag pasteboard and creates a 1:1 copy of that image for the drag representation.
*/
@interface NKDBarcodeImageView : NSImageView
{

}

@end
