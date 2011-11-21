// -----------------------------------------------------------------------------------
// NKDBarcodeTestScaffoldController.h
// -----------------------------------------------------------------------------------
//  Copyright (c) 2002 Naked Software. All rights reserved.
// -----------------------------------------------------------------------------------
// THIS	SOURCE CODE IS PROVIDED AS-IS WITH NO WARRANTY OF ANY KIND
// -----------------------------------------------------------------------------------
// You may use and redistribute this source code without limitation
// -----------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>
#import "NKDBarcodeFramework.h"
#define preferences [NSUserDefaults standardUserDefaults]

/*!
@header NKDBarcodeTestScaffoldController.h
*/

/*!
@class NKDBarcodeTestScaffoldController
@abstract Window controller for a test scaffold used to test the NKDBarcode framework. It allows adjustments to the barcode content, bar height, bar width, font size, and caption display. The barcode image can be dragged to any other view that accepts PDF data, or the data can be printed to any attached printer or copied to the default pasteboard.
 */
@interface NKDBarcodeTestScaffoldController : NSObject
{
    IBOutlet id barcodeImage;
    IBOutlet id barcodeTypePopup;
    IBOutlet id captionCheckbox;
    IBOutlet id dataText;
    IBOutlet id ExportButton;
    IBOutlet id HeightStepper;
    IBOutlet id HeightText;
    IBOutlet id widthStepper;
    IBOutlet id widthText;
    IBOutlet id copyButton;
    IBOutlet id printButton;
    IBOutlet id fontSizeText;
    IBOutlet id fontSizeStepper;

	IBOutlet id barHeightLabel;
	IBOutlet id barWidthLabel;
	

    // Export sheet
    IBOutlet NSWindow 	*panel;
    IBOutlet id			saveDPIText;
    IBOutlet id			fileFormatPopup;

	
	IBOutlet NSWindow	*prefPanel;
	IBOutlet NSMatrix  	*matrix;

    NKDBarcode *testBarcode;
}
- (IBAction)exportButtonActionPerformed:(id)sender;
- (IBAction)goButtonActionPerformed:(id)sender;
- (IBAction)heightChanged:(id)sender;
- (IBAction)printBarcode:(id)sender;
- (IBAction)widthChanged:(id)sender;
- (IBAction)fontSizeChanged:(id)sender;
- (NKDBarcode *)testBarcode;
- (void)setTestBarcode:(NKDBarcode *)inBarcode;
- (IBAction)captionChanged:(id)sender;
- (IBAction)copyButtonActionPerformed:(id)sender;
- (IBAction)barcodeTypeChanged:(id)sender;

- (IBAction)exportOkay:(id)sender;
- (IBAction)prefsOkay:(id)sender;
- (IBAction)exportCancel:(id)sender;
- (IBAction)doPreferences:(id)sender;
- (IBAction)exportFileTypeChanged:(id)sender;
- (void)exportSheetDidEnd: (NSWindow *)sheet
               returnCode:(int)returnCode
              contextInfo:(void *)dummy;
- (void)savePanelDidEnd:(NSWindow *)sheet
             returnCode:(int)returnCode
            contextInfo:(void  *)contextInfo;
- (IBAction)buttonCellClick:(id)sender;
@end
