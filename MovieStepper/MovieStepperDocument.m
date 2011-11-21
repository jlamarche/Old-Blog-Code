//
//  MyDocument.m
//  MovieStepper
//
//  Created by jeff on 5/14/09.
//  Copyright Jeff LaMarche 2009 . All rights reserved.
//
//  This code may be used freely in any project, commercial or otherwise
//  without obligation. There is no attribution required, and no need
//  to publish any code. The code is provided with absolutely no
//  warranties of any sort.

#import "MovieStepperDocument.h"
#import "QTMovie-Frames.h"
#import "NKDMovieFilmstripView.h"

@implementation MovieStepperDocument
@synthesize movie;
@synthesize leftButton;
@synthesize rightButton;
@synthesize importMovieButton;
@synthesize beginningButton;
@synthesize endButton;
@synthesize imageView;
@synthesize slider;
@synthesize stripView;
- (IBAction)stepLeft:(id)sender
{
    [movie stepBackward];
    [imageView setImage:[movie currentFrameImage]];
    [slider setIntegerValue:[movie currentFrameNumber]];
    [stripView updateCurrentFrame];
}
- (IBAction)stepRight:(id)sender
{
    
    [movie stepForward];
    [imageView setImage:[movie currentFrameImage]];
    [slider setIntegerValue:[movie currentFrameNumber]];
    [stripView updateCurrentFrame];
}
- (IBAction)importMovie:(id)sender
{
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	
	[oPanel setAllowsMultipleSelection:NO];
	[oPanel beginSheetForDirectory:nil file:nil types:[QTMovie movieFileTypes:QTIncludeCommonTypes] modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(importPanelDidEnd:returnCode:contextInfo:) contextInfo:nil];
}
- (IBAction)goToEndofMovie:(id)sender
{
    [movie gotoEnd];
    [imageView setImage:[movie currentFrameImage]];
    [slider setIntegerValue:[movie currentFrameNumber]];
    [stripView updateCurrentFrame];
}
- (IBAction)goToBeginningOfMovie:(id)sender
{
    [movie gotoBeginning];
    [imageView setImage:[movie currentFrameImage]];
    [slider setIntegerValue:[movie currentFrameNumber]];
    [stripView updateCurrentFrame];
}
- (IBAction)sliderValueChanged:(id)sender
{
    [movie gotoFrameNumber:[slider integerValue]]; 
    [imageView setImage:[movie currentFrameImage]];
    [stripView updateCurrentFrame];
}
#pragma mark -
#pragma mark Callback Methods
- (void)importPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
    if (returnCode == NSOKButton)
    {
        QTMovie *theMovie = [QTMovie movieWithFile:[panel filename] error:nil];
        [theMovie setDelegate:self];
        self.movie = theMovie;
        stripView.movie = theMovie;
        
        long numberOfFrames = [theMovie numberOfFrames];
        
        [slider setMaxValue:numberOfFrames];
        [slider setMinValue:1.0];
        [slider setIntegerValue:1];
        [theMovie gotoBeginning];
        NSImage *currentFrameImage = [theMovie currentFrameImage];
        [imageView setImage:currentFrameImage];
        
        [importMovieButton setHidden:YES];
        [beginningButton setHidden:NO];
        [endButton setHidden:NO];
        [leftButton setHidden:NO];
        [rightButton setHidden:NO];
        [slider setHidden:NO];
        
        
        NSSize imageSize = [currentFrameImage size];
 
        NSRect newFrameRect = NSMakeRect([[self windowForSheet] frame].origin.x, [[self windowForSheet] frame].origin.y, imageSize.width, imageSize.height + kWindowHeightPadding);
        [[self windowForSheet] setFrame:newFrameRect display:YES animate:YES];
        
    }
}

#pragma mark -
- (NSString *)windowNibName
{
    return @"MovieStepperDocument";
}
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.
    
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.
    
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
