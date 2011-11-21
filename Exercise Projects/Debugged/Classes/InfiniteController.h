//
//  InfiniteController.h
//  Nav
//
//  Created by jeff on 8/16/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfiniteController : UITableViewController {
    NSUInteger  hierarchyLevel;
    UIImage     *rowImage;
}
@property NSUInteger hierarchyLevel;
@property (readonly) NSString *titleString;
@property (nonatomic, retain) UIImage *rowImage;
@end
