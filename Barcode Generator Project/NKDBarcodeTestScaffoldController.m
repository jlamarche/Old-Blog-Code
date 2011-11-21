// -----------------------------------------------------------------------------------
// NKDBarcodeTestScaffoldController.m
// -----------------------------------------------------------------------------------
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------

#import "NKDBarcodeTestScaffoldController.h"

@implementation NKDBarcodeTestScaffoldController
// -----------------------------------------------------------------------------------
- (void)_setLabels
// -----------------------------------------------------------------------------------
{
	int row = [preferences integerForKey:@"useInches"];
	if (row == 0)
	{
		[barHeightLabel setStringValue: NSLocalizedString(@"Bar Height in Inches:", nil)];
	}
	else
	{
		[barHeightLabel setStringValue: NSLocalizedString(@"Bar Height in Centimeters:", nil)];
	}
}
// -----------------------------------------------------------------------------------
- (void)awakeFromNib
// -----------------------------------------------------------------------------------
{
	[self _setLabels];
	[barcodeImage setImageFrameStyle:NSImageFrameGrayBezel];

	if (0.0 != [preferences floatForKey:@"height"])
	{
		[HeightText setFloatValue:[preferences floatForKey:@"height"]];
		[HeightStepper setFloatValue:[preferences floatForKey:@"height"]];
	}
	if (0.0 != [preferences floatForKey:@"fontSize"])
	{
		[fontSizeText setFloatValue:[preferences floatForKey:@"fontSize"]];
		[fontSizeStepper setFloatValue:[preferences floatForKey:@"fontSize"]];
	}
	if (0 != [preferences integerForKey:@"useCaption"])
		[captionCheckbox setIntValue:[preferences integerForKey:@"useCaption"]];

	if (0.0 != [preferences floatForKey:@"width"])
	{
		[widthText setFloatValue:[preferences floatForKey:@"width"]];
		[widthStepper setFloatValue:[preferences floatForKey:@"width"]];
	}
	
	if (nil != [preferences objectForKey:@"data"])
		[dataText setStringValue:[preferences objectForKey:@"data"]];

	if (nil != [preferences objectForKey:@"symbology"])
	{
		[barcodeTypePopup selectItemWithTitle:[preferences objectForKey:@"symbology"]];
		[self barcodeTypeChanged:self];
	}
}
// -----------------------------------------------------------------------------------
- (IBAction)exportButtonActionPerformed:(id)sender
// -----------------------------------------------------------------------------------
{

      [NSApp beginSheet:panel
       modalForWindow:[widthText window]
        modalDelegate:self
       didEndSelector:@selector(exportSheetDidEnd:returnCode:contextInfo:)
          contextInfo:nil];
}
// -----------------------------------------------------------------------------------
- (IBAction)barcodeTypeChanged:(id)sender
// -----------------------------------------------------------------------------------
{
    NSMenuItem 	*selected = [barcodeTypePopup selectedItem];

    // Set all fields to enabled
    [HeightStepper setEnabled:YES];
    [HeightText setEnabled:YES];
    [widthStepper setEnabled:YES];
    [widthText setEnabled:YES];
    [captionCheckbox setEnabled:YES];
	[fontSizeText setEnabled:YES];
	[fontSizeStepper setEnabled:YES];

    // Then disable if appropriate to the selected value
    if ( ([[selected title] isEqualToString:NSLocalizedString(@"PostNet", nil)]) ||
		 ([[selected title] isEqualToString:NSLocalizedString(@"Royal Mail Barcode (RM4SCC / CBC)", nil)]) ||
		 ([[selected title] isEqualToString:NSLocalizedString(@"Planet Barcode", nil)]) )
    {
        [HeightStepper setEnabled:NO];
        [HeightText setEnabled:NO];
        [widthStepper setEnabled:NO];
        [widthText setEnabled:NO];
        [captionCheckbox setEnabled:NO];
		[fontSizeText setEnabled:NO];
		[fontSizeStepper setEnabled:NO];
    }

    if ( ([dataText stringValue] != nil) && (![[dataText stringValue] isEqual:@""]))
        [self goButtonActionPerformed:self];
}
// -----------------------------------------------------------------------------------
- (IBAction)goButtonActionPerformed:(id)sender
// -----------------------------------------------------------------------------------
{
    NKDBarcode 	*barcode = nil;
    NSImage		*theImage;
    NSMenuItem 	*selected = [barcodeTypePopup selectedItem];
	float		theBarHeight = 0.0;

    if ([[selected title] isEqualToString:NSLocalizedString(@"Code 3 of 9", nil)])
        barcode = [NKDCode39Barcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Extended Code 3 of 9", nil)])
        barcode = [NKDExtendedCode39Barcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Interleaved 2 of 5", nil)])
        barcode = [NKDInterleavedTwoOfFiveBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"UPC-A", nil)])
        barcode = [NKDUPCABarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"PostNet", nil)])
        barcode = [NKDPostnetBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Modified Plessey", nil)])
        barcode = [NKDModifiedPlesseyBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Modified Plessey (Hex)", nil)])
        barcode = [NKDModifiedPlesseyHexBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Industrial 2 of 5", nil)])
        barcode = [NKDIndustrialTwoOfFiveBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"EAN-13", nil)])
        barcode = [NKDEAN13Barcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Code 128", nil)])
        barcode = [NKDCode128Barcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"Codabar", nil)])
        barcode = [NKDCodabarBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"UPC-E", nil)])
        barcode = [NKDUPCEBarcode alloc];
    else if ([[selected title] isEqualToString:NSLocalizedString(@"EAN-8", nil)])
        barcode = [NKDEAN8Barcode alloc];
	else if ([[selected title] isEqualToString:NSLocalizedString(@"Royal Mail Barcode (RM4SCC / CBC)", nil)])
		barcode = [NKDRoyalMailBarcode alloc];
	else if ([[selected title] isEqualToString:NSLocalizedString(@"Planet Barcode", nil)])
		barcode = [NKDPlanetBarcode alloc];
	else if ([[selected title] isEqualToString:NSLocalizedString(@"Japan Post Barcode", nil)])
		barcode = [JapanPostBarcode alloc];
    

    barcode = [barcode initWithContent: [dataText stringValue]
                        printsCaption: [captionCheckbox intValue]];

    if ([barcode isContentValid])
    {
        [copyButton setEnabled:YES];
        [ExportButton setEnabled:YES];
        
        [testBarcode autorelease];
        testBarcode = [barcode copy];

        if ([widthText isEnabled] == YES)
            [testBarcode setBarWidth:(float)([widthText floatValue]/1000)*kScreenResolution];

        if ([fontSizeStepper isEnabled] == YES)
            [testBarcode setFontSize:[fontSizeText floatValue]];
        
        if ([HeightText isEnabled] == YES)
		{
			if ([preferences integerForKey:@"useInches"] !=0)
				theBarHeight = ([HeightText floatValue] * 0.393701) * kScreenResolution;
			else
				theBarHeight = [HeightText floatValue] * kScreenResolution;
			
			
            if ([testBarcode printsCaption])
                [testBarcode setHeight:theBarHeight + ([testBarcode captionHeight] * kScreenResolution)];
            else
                [testBarcode setHeight:theBarHeight];
		}

        [testBarcode calculateWidth];
    
          theImage = [NSImage imageFromBarcode:testBarcode];
        [barcodeImage setImage:theImage];
    }
    else
    {
        [copyButton setEnabled:NO];
        [ExportButton setEnabled:NO];
        
        NSBeginAlertSheet(NSLocalizedString(@"Oops...",nil),
                          NSLocalizedString(@"OK",nil),
                          @"",
                          @"",
                          [NSApp mainWindow],
                          nil,nil, nil, nil,
                          NSLocalizedString(@"I'm sorry, the selected barcode type can't encode the specified data", nil));
        
        [barcodeImage setImage:nil];
        [testBarcode release];
        testBarcode = nil;
    }

}
// -----------------------------------------------------------------------------------
- (NKDBarcode *)testBarcode
// -----------------------------------------------------------------------------------
{
     return testBarcode;
}
// -----------------------------------------------------------------------------------
- (IBAction)heightChanged:(id)sender
// -----------------------------------------------------------------------------------
{
	float 	theBarHeight = 0.0;
	
    if ([sender isMemberOfClass:[NSStepper class]])
        [HeightText setFloatValue: [HeightStepper floatValue]];
    else
        [HeightStepper setFloatValue: [HeightText floatValue]];
    if (testBarcode)
    {
		if ([preferences integerForKey:@"useInches"] !=0)
			theBarHeight = ([HeightText floatValue] * 0.393701) * kScreenResolution;
		else
			theBarHeight = [HeightText floatValue] * kScreenResolution;


        if ([testBarcode printsCaption])
			[testBarcode setHeight:theBarHeight + ([testBarcode captionHeight] * kScreenResolution)];
		else
			[testBarcode setHeight:theBarHeight];
        
        [barcodeImage setImage:[NSImage imageFromBarcode:testBarcode]];
    }
}
// -----------------------------------------------------------------------------------
- (IBAction)widthChanged:(id)sender
// -----------------------------------------------------------------------------------
{
    if ([sender isMemberOfClass:[NSStepper class]])
        [widthText setFloatValue: [widthStepper floatValue]];
    else
        [widthStepper setFloatValue: [widthText floatValue]];

    if (testBarcode)
    {
        [testBarcode setBarWidth:([widthStepper floatValue]/1000)*kScreenResolution];
        [testBarcode calculateWidth];
        [barcodeImage setImage:[NSImage imageFromBarcode:testBarcode]];
    }
   
}
// -----------------------------------------------------------------------------------
- (IBAction)printBarcode:(id)sender
// -----------------------------------------------------------------------------------
{
    NSPrintInfo 		*printInfo = [NSPrintInfo sharedPrintInfo];
    NSPrintOperation 		*printOp;
    NKDBarcodeOffscreenView 	*view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:[self testBarcode]];

    printOp = [NSPrintOperation printOperationWithView:view
                                             printInfo:printInfo];
    [printOp setShowPanels:YES];
    [printOp runOperation];
    
}
// -----------------------------------------------------------------------------------
- (void)setTestBarcode:(NKDBarcode *)inBarcode
// -----------------------------------------------------------------------------------
{
    [testBarcode autorelease];
    testBarcode = [inBarcode retain];
}
// -----------------------------------------------------------------------------------
- (IBAction)captionChanged:(id)sender
// -----------------------------------------------------------------------------------
{
    if (testBarcode)
    {
        [testBarcode setPrintsCaption:[captionCheckbox intValue]];
        if ([testBarcode printsCaption])
            [testBarcode setHeight:([HeightStepper floatValue]*kScreenResolution) + [testBarcode captionHeight]*kScreenResolution];
        else
            [testBarcode setHeight:[HeightStepper floatValue]*kScreenResolution];
        
        [barcodeImage setImage:[NSImage imageFromBarcode:testBarcode]];
    }
    
}
// -----------------------------------------------------------------------------------
- (IBAction)copyButtonActionPerformed:(id)sender
// -----------------------------------------------------------------------------------
{
    NSPasteboard 				*pb = [NSPasteboard generalPasteboard];
    NKDBarcodeOffscreenView 	*view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:[self testBarcode]];
    NSData 						*data = [view dataWithPDFInsideRect:[view bounds]];

	// Some programs and some foundation classes rasterize PDF data from the pasteboard. This is a 
	// workaround suggested by Andrew Stone - we write the data to a file in /tmp and then put the
	// filename on the pasteboard as the first item. This causes NSText objects and some other classes 
	// to embed the PDF data without rasterizing it.
	
    [pb declareTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSPDFPboardType, nil] owner:nil];

	if ([data writeToFile:@"/tmp/barcode.pdf" atomically:NO])
		[pb setPropertyList:[NSArray arrayWithObject:@"/tmp/barcode.pdf"] forType:NSFilenamesPboardType];
    [pb setData:data forType:NSPDFPboardType];

}
// -----------------------------------------------------------------------------------
- (IBAction)fontSizeChanged:(id)sender
// -----------------------------------------------------------------------------------
{
	float theBarHeight = 0.0;
	
    if ([sender isMemberOfClass:[NSStepper class]])
        [fontSizeText setFloatValue: [fontSizeStepper floatValue]];
    else
        [fontSizeStepper setFloatValue: [fontSizeText floatValue]];

       
    if (testBarcode)
    {
        [testBarcode setFontSize:[fontSizeStepper floatValue]];
        // We have to reset the height to deal with the font size change
		
        if ([testBarcode printsCaption])
		{
			if ([preferences integerForKey:@"useInches"] !=0)
				theBarHeight = ([HeightText floatValue] * 0.393701) * kScreenResolution;
			else
				theBarHeight = [HeightText floatValue] * kScreenResolution;

            if ([testBarcode printsCaption])
				[testBarcode setHeight:theBarHeight + ([testBarcode captionHeight] * kScreenResolution)];
			else
				[testBarcode setHeight:theBarHeight];
		}
        [barcodeImage setImage:[NSImage imageFromBarcode:testBarcode]];
    }
}
// -----------------------------------------------------------------------------------
- (IBAction)exportOkay:(id)sender
// -----------------------------------------------------------------------------------
{
    [panel orderOut:sender];
    [NSApp endSheet:panel returnCode:1];
}
// -----------------------------------------------------------------------------------
- (IBAction)prefsOkay:(id)sender
// -----------------------------------------------------------------------------------
{
    [prefPanel orderOut:sender];
    [NSApp endSheet:prefPanel returnCode:1];
}
// -----------------------------------------------------------------------------------
- (IBAction)exportCancel:(id)sender
// -----------------------------------------------------------------------------------
{
    [panel orderOut:sender];
    [NSApp endSheet:panel returnCode:0];
}
// -----------------------------------------------------------------------------------
- (void)exportSheetDidEnd: (NSWindow *)sheet
               returnCode:(int)returnCode
              contextInfo:(void *)dummy
// -----------------------------------------------------------------------------------
{
    NSSavePanel 		*sp;
    NSString			*savePath = @"~/Pictures/";
    NSString			*actualPath;
    NSMenuItem 			*selected = [fileFormatPopup selectedItem];
  
    if (returnCode == 1)
    {

        actualPath = [NSMutableString stringWithString:[savePath stringByExpandingTildeInPath]];
        sp = [NSSavePanel savePanel];
        [sp setRequiredFileType:[[selected title] lowercaseString]];
        [sp setAccessoryView:nil];
        [sp beginSheetForDirectory:actualPath
                              file:@""
                    modalForWindow:[NSApp mainWindow]
                     modalDelegate:self
                    didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:)
                       contextInfo:nil];
    }
    
}
// -----------------------------------------------------------------------------------
- (void)preferencesSheetDidEnd:(NSWindow *)sheet
					returnCode:(int)returnCode
				   contextInfo:(void  *)contextInfo

// -----------------------------------------------------------------------------------
{
	float	theBarHeight = 0.0;
	
	[self _setLabels];
	if (testBarcode)
	{
		if ([preferences integerForKey:@"useInches"] !=0)
			theBarHeight = ([HeightText floatValue] * 0.393701) * kScreenResolution;
		else
			theBarHeight = [HeightText floatValue] * kScreenResolution;

		if ([testBarcode printsCaption])
			[testBarcode setHeight:theBarHeight + ([testBarcode captionHeight] * kScreenResolution)];
		else
			[testBarcode setHeight:theBarHeight];
	}
	[barcodeImage setImage:[NSImage imageFromBarcode:testBarcode]];
}
// -----------------------------------------------------------------------------------
- (void)savePanelDidEnd:(NSWindow *)sheet
             returnCode:(int)returnCode
            contextInfo:(void  *)contextInfo
// -----------------------------------------------------------------------------------
{
    NSData 		*export = nil;
    NSImage 		*original = [NSImage imageFromBarcode:testBarcode];
    NSMenuItem 		*selected = [fileFormatPopup selectedItem];
    NSSavePanel 	*sp = (NSSavePanel *)sheet;
    NSSize 		origSize;
    NSImage		*sized;
    
    if (returnCode == NSOKButton)
    {
        if ([[selected title] isEqualToString:@"TIFF"])
        {
            [original setScalesWhenResized:YES];
            origSize = [original size];
            [original setSize:NSMakeSize([original size].width * ([saveDPIText floatValue] / kScreenResolution),[original size].height * ([saveDPIText floatValue] / kScreenResolution))];
    
            sized = [[[[NSImage alloc] initWithData:[original TIFFRepresentation]] autorelease] setDPI:[saveDPIText floatValue]];
            [sized setSize:origSize];

            export = [sized TIFFRepresentation];
    
        }
        else if ([[selected title] isEqualToString:@"EPS"])
        {
            NKDBarcodeOffscreenView 	*view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:testBarcode];
            export = [view dataWithEPSInsideRect:[view bounds]];
        }
        else if ([[selected title] isEqualToString:@"PDF"])
        {
            NKDBarcodeOffscreenView 	*view = [[NKDBarcodeOffscreenView alloc] initWithBarcode:testBarcode];
            export = [view dataWithPDFInsideRect:[view bounds]];
        }
    
        [export writeToFile:[sp filename]  atomically:YES];
    }

}
// -----------------------------------------------------------------------------------
- (IBAction)exportFileTypeChanged:(id)sender
// -----------------------------------------------------------------------------------
{
    NSMenuItem 	*selected = [fileFormatPopup selectedItem];

    if ([[selected title] isEqualToString:@"TIFF"])
    {
        [saveDPIText setEnabled:YES];
    }
    else
    {
        [saveDPIText setEnabled:NO];
    }
}
// -----------------------------------------------------------------------------------
- (IBAction)doPreferences:(id)sender
// -----------------------------------------------------------------------------------
{
	int row = [preferences integerForKey:@"useInches"];
	
	[NSApp beginSheet:prefPanel
	   modalForWindow:[widthText window]
		modalDelegate:self
	   didEndSelector:@selector(preferencesSheetDidEnd:returnCode:contextInfo:)
	   contextInfo:nil];
	
	[matrix selectCellAtRow:row column:0];
}
// -----------------------------------------------------------------------------------
- (IBAction)buttonCellClick:(id)sender
// -----------------------------------------------------------------------------------
{
	int row = [matrix selectedRow];
	[preferences setInteger:row forKey:@"useInches"];
}
// -----------------------------------------------------------------------------------
- (void)applicationWillTerminate:(NSNotification *)aNotification
// -----------------------------------------------------------------------------------
{
	[preferences setFloat:[HeightText floatValue] forKey:@"height"];
	[preferences setFloat:[fontSizeText floatValue] forKey:@"fontSize"];
	[preferences setInteger:[captionCheckbox intValue] forKey:@"useCaption"];
	[preferences setFloat:[widthText floatValue] forKey:@"width"];
	[preferences setObject:[dataText stringValue] forKey:@"data"];
	[preferences setObject:[[barcodeTypePopup selectedItem] title] forKey:@"symbology"];
}
@end
