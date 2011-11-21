// -----------------------------------------------------------------------------------
//  NSBarcodeImageView.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Thu May 16 2002.
//  ©2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NKDBarcodeImageView.h"


@implementation NKDBarcodeImageView
- (BOOL)acceptsFirstResponder
{
    return YES;
}
// -----------------------------------------------------------------------------------
- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
// -----------------------------------------------------------------------------------
{
    return NSDragOperationCopy;
}
// -----------------------------------------------------------------------------------
- (void)mouseDown:(NSEvent *)event
// -----------------------------------------------------------------------------------
{
    NSPasteboard	*pb;
    NSImage 		*anImage;
    NSImageView		*offscreen;
	NSData			*data;
	NSArray			*array;
    NSSize		s;
    NSPoint		p;

    anImage = [self image];
    if (anImage)
    {
        s = [anImage size];
        
        p = [self convertPoint:[event locationInWindow] fromView:nil];
        p.x = p.x - s.width/2;
        p.y = p.y - s.height/2;

        pb = [NSPasteboard pasteboardWithName:NSDragPboard];

        offscreen = [[NSImageView alloc] initWithFrame:NSMakeRect(0,0,s.width, s.height)];
        [offscreen setImage:anImage];

		array = [NSArray arrayWithObjects:NSFilenamesPboardType, NSPDFPboardType, nil];
        [pb declareTypes:array owner:nil];
		
		data = [offscreen dataWithPDFInsideRect:[offscreen bounds]];

		if (nil != data)
			if ([data writeToFile:@"/tmp/barcode.pdf" atomically:NO])
				[pb setPropertyList:[NSArray arrayWithObject:@"/tmp/barcode.pdf"] forType:NSFilenamesPboardType];
		
        [pb setData:data forType:NSPDFPboardType];
		
        [self dragImage: anImage
                    at:p
                offset:NSMakeSize(0,0)
                event:event
            pasteboard:pb
                source:self
            slideBack:YES];
        [offscreen release];
    }
}

@end
