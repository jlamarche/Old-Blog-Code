//
//  DeviantDownload.h
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DeviantDownloadErrorDomain      @"Deviant Download Error Domain"
enum 
{
    DeviantDownloadErrorNoConnection = 1000,
};

@class DeviantDownload;
@protocol DeviantDownloadDelegate
@optional
- (void)downloadDidFinishDownloading:(DeviantDownload *)download;
- (void)download:(DeviantDownload *)download didFailWithError:(NSError *)error;
@end


@interface DeviantDownload : NSObject 
{  
    NSString                                *urlString;
    UIImage                                 *image;
    
    id <NSObject, DeviantDownloadDelegate>  delegate;

@private
    NSMutableData                           *receivedData;
    BOOL                                    downloading;
}
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, readonly) NSString *filename;
@property (nonatomic, assign) id <NSObject, DeviantDownloadDelegate> delegate;
@end
