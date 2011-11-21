//
//  QTMovie-FrameCount.h
//  MovieStepper
//
//  Created by jeff on 5/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//
//  These are methods designed to be used on movies that contain only 
//  sequential frame data, e.g. straight movies. These methods make
//  the assumption that the framerate is constant and that each frame
//  is displayed for the same length of time. Do not use these methods
//  on movies that have tracks other than a single video track and 
//  some number of audio tracks.
//  
//  This code may be used freely in any project, commercial or otherwise
//  without obligation. There is no attribution required, and no need
//  to publish any code. The code is provided with absolutely no
//  warranties of any sort.

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

#define     kCharacteristicHasVideoFrameRate    FOUR_CHAR_CODE('vfrr')
#define     kCharacteristicIsAnMpegTrack        FOUR_CHAR_CODE('mpeg')

#define	    DealWithQTError(); if (err){NSLog(@"Quicktime error. Error Code: %d", err);return -1;}
#define	    DealWithQTErrorBool(); if (err){NSLog(@"Quicktime error. Error Code: %d", err);return NO;}
#define	    DealWithQTErrorNoReturnObject(); if (err){NSLog(@"Quicktime error. Error Code: %d", err);return;}

@interface QTMovie(Frames)
- (long)numberOfFrames;
- (void)gotoFrameNumber:(long)frameNum;
- (long)currentFrameNumber;
- (int)desiredFPS;
- (NSImage *)frameImageForFrame:(int)frameNumber;
@end
