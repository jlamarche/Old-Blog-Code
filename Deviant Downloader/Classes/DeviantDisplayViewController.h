//
//  DeviantDisplayViewController.h
//  Deviant Downloader
//
//  Created by jeff on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviantDownload.h"

#define START_TOKEN @"<a super_img=\""
#define STOP_TOKEN  @"\" super"

@class DeviantDisplayCell;

@interface DeviantDisplayViewController : UITableViewController <DeviantDownloadDelegate>
{
    NSString            *deviantName;
    DeviantDisplayCell  *loadCell;
    NSMutableArray      *downloads;
@private
    NSMutableData       *receivedData;
    NSUInteger          current;
}
@property (nonatomic, copy) NSString *deviantName;
@property (nonatomic, retain) IBOutlet DeviantDisplayCell *loadCell;
@property (nonatomic, retain) NSMutableArray *downloads;

@end
