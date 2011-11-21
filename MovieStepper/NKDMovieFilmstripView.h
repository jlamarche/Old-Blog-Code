//
//  NKDMovieFilmstripView.h
//  MovieStepper
//
//  Created by jeff on 5/18/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface NKDMovieFilmstripView : NSView {
    QTMovie         *movie;
    NSMutableArray  *frameCache;
}
@property (assign) QTMovie *movie;
@property (assign) NSMutableArray *frameCache;
- (void)updateCurrentFrame;
@end
