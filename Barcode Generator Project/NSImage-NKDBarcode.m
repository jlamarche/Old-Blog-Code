// -----------------------------------------------------------------------------------
//  NSImage-NKDBarcode.m
// -----------------------------------------------------------------------------------
//  Created by Jeff LaMarche on Wed May 01 2002.
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------
#import "NSImage-NKDBarcode.h"

@implementation NSImage(NKDBarcode)
+(NSImage *)imageFromBarcode:(NKDBarcode *)barcode
{
    NKDBarcodeOffscreenView 	*view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:barcode];
    NSRect			rect = [view bounds];
    NSData 			*data = [view dataWithPDFInsideRect:rect];
     
    NSImage			*image = [[NSImage alloc] initWithData:data];     
    [view release];
    return [image autorelease];
}
@end
