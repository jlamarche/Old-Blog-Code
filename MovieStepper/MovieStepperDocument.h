//
//  MyDocument.h
//  MovieStepper
//
//  Created by jeff on 5/14/09.
//  Copyright Jeff LaMarche 2009 . All rights reserved.
//
//  This code may be used freely in any project, commercial or otherwise
//  without obligation. There is no attribution required, and no need
//  to publish any code. The code is provided with absolutely no
//  warranties of any sort.

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>


#define kWindowWidthPadding     34
#define kWindowHeightPadding    105

@class NKDMovieFilmstripView;

@interface MovieStepperDocument : NSDocument
{
    QTMovie *movie;
    
    NSButton    *leftButton, *rightButton, *importMovieButton, *beginningButton, *endButton;
    NSImageView *imageView;
    NSSlider    *slider;
    NKDMovieFilmstripView   *stripView;
}
@property (assign) QTMovie *movie;
@property IBOutlet NSButton *leftButton;
@property IBOutlet NSButton *rightButton;
@property IBOutlet NSButton *importMovieButton;
@property IBOutlet NSButton *beginningButton;
@property IBOutlet NSButton *endButton;
@property IBOutlet NSImageView *imageView;
@property IBOutlet NSSlider *slider;
@property IBOutlet NKDMovieFilmstripView *stripView;
- (IBAction)stepLeft:(id)sender;
- (IBAction)stepRight:(id)sender;
- (IBAction)importMovie:(id)sender;
- (IBAction)goToEndofMovie:(id)sender;
- (IBAction)goToBeginningOfMovie:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;
- (void)importPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
@end
