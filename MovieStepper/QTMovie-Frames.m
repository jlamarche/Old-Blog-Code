//
//  QTMovie-FrameCount.m
//  MovieStepper
//
//  Created by jeff on 5/14/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//
//  This code may be used freely in any project, commercial or otherwise
//  without obligation. There is no attribution required, and no need
//  to publish any code. The code is provided with absolutely no
//  warranties of any sort.

#import "QTMovie-Frames.h"


@implementation QTMovie(Frames)
- (long)numberOfFrames
{
    Track theTrack = GetMovieIndTrackType([self quickTimeMovie],
                                    1,
                                    kCharacteristicHasVideoFrameRate,
                                    movieTrackCharacteristic);
    
    Media theMedia = GetTrackMedia(theTrack);
    return GetMediaSampleCount(theMedia);
}
- (void)gotoFrameNumber:(long)frameNum
{
    Track theTrack = GetMovieIndTrackType([self quickTimeMovie],
                                          1,
                                          kCharacteristicHasVideoFrameRate,
                                          movieTrackCharacteristic);
    TimeValue64 decodeTime, decodeDuration;
    Media theMedia = GetTrackMedia(theTrack);
    SampleNumToMediaDecodeTime(theMedia, frameNum, &decodeTime, &decodeDuration);
    TimeScale theTimeScale = GetMediaTimeScale(theMedia);

    QTTime  movieTime;
    movieTime.flags = 0x00;
    movieTime.timeValue = decodeTime;
    movieTime.timeScale = theTimeScale;
    
    [self setCurrentTime:movieTime];
}
- (long)currentFrameNumber
{
    SInt64    frameNum = 0;
    TimeValue64   sampleTime, sampleDuration;
    Track theTrack = GetMovieIndTrackType([self quickTimeMovie],
                                          1,
                                          kCharacteristicHasVideoFrameRate,
                                          movieTrackCharacteristic);
    
    Media theMedia = GetTrackMedia(theTrack);
    QTTime currentTime = [self currentTime];
    MediaDecodeTimeToSampleNum(theMedia, currentTime.timeValue, &frameNum, &sampleTime, &sampleDuration);
    return (long)frameNum;
}
-(int)desiredFPS
{
    
    MediaHandler mpegMediaHandler = nil;
    Track        theTrack = nil;
    Media        myMedia = nil;
    OSErr        err = noErr;
    Boolean      isMpeg = false;
    
    short	fps = 0;
    
    theTrack = GetMovieIndTrackType([self quickTimeMovie],
                                    1,
                                    kCharacteristicHasVideoFrameRate,
                                    movieTrackCharacteristic);
    err = GetMoviesError();
    DealWithQTError();
    
    myMedia = GetTrackMedia(theTrack);
    err = GetMoviesError();
    DealWithQTError();
    
    mpegMediaHandler = GetMediaHandler(myMedia);
    err = GetMoviesError();
    DealWithQTError();
    
    err = MediaHasCharacteristic(mpegMediaHandler,
                                 kCharacteristicIsAnMpegTrack,
                                 &isMpeg);
    if ((err == noErr) && isMpeg)
    {
        MHInfoEncodedFrameRateRecord encodedFrameRate;
        Size encodedFrameRateSize = sizeof(encodedFrameRate);
        
        /* due to a bug in QuickTime, we must task the movie
         first before obtaining our frame rate value */
        MoviesTask([self quickTimeMovie], 0 );
        
        err = MediaGetPublicInfo(mpegMediaHandler,
                                 kMHInfoEncodedFrameRate,
                                 &encodedFrameRate,
                                 &encodedFrameRateSize);
        if (err == noErr)
        {                
            Fixed staticFrameRate = 0;
            
            staticFrameRate = encodedFrameRate.encodedFrameRate;
            fps = FixRound(staticFrameRate);
        }
    }
    else /* were dealing with non-MPEG media, so use the "old" method */
    {
        long sampleCount = 0;
        
        sampleCount = GetMediaSampleCount(myMedia);
        err = GetMoviesError();
        DealWithQTError();
        
        if (sampleCount)
        {
            TimeValue duration;
            TimeValue timeScale;
            Fixed staticFrameRate = 0;
            double frameRate;
            
            /* find the media duration */
            duration = GetMediaDuration(myMedia);
            err = GetMoviesError();
            DealWithQTError();
            
            /* get the media time scale */
            timeScale = GetMediaTimeScale(myMedia);
            err = GetMoviesError();
            DealWithQTError();
            
            /* calculate the frame rate:
             frame rate = (sample count * media time scale) / media duration 
             */
            frameRate = sampleCount*(double)timeScale/(double)duration;
            staticFrameRate = X2Fix(frameRate);
            /* we'll round this value for simplicity - you could
             parse the value to also obtain the fractional
             portion as well. */
            fps = FixRound(staticFrameRate);
        }
    }
    return fps;
}
-(void)addVideoTrackOfHeight:(int)inHeight andWidth:(int)inWidth
{
    Track	theTrack;
    Media	theMedia;
    OSErr	err;
    short	resID = movieInDataForkResID;
    
    theTrack = NewMovieTrack([self quickTimeMovie], FixRatio(inWidth, 1), FixRatio(inHeight, 1), kNoVolume);
    err = GetMoviesError();
    NSLog(@"err: %s", err);
    DealWithQTErrorNoReturnObject();
    
    theMedia = NewTrackMedia(theTrack, VideoMediaType, 600, nil, 0);
    err = GetMoviesError();
    DealWithQTErrorNoReturnObject();
    
    err = InsertMediaIntoTrack(theTrack, 0, 0, 1, 0x00010000);
    DealWithQTErrorNoReturnObject();
    
    err = AddMovieResource([self quickTimeMovie], _resourceID, &resID, nil);
    DealWithQTErrorNoReturnObject();
}
- (NSImage *)frameImageForFrame:(int)frameNumber
{
    QTTime restoreTime = [self currentTime];
    [self gotoFrameNumber:frameNumber];
    NSImage *ret = [self currentFrameImage];
    [self setCurrentTime:restoreTime];
    return ret;
}
@end
