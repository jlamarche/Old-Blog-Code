//
//  TableCell.h
//  Simple Table
//
//  Created by jeff on 8/13/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableCell : UITableViewCell {
    UILabel                 *mainLabel;
    UILabel                 *secondaryLabel;
    UIImageView             *bigImageView;
    UIActivityIndicatorView *spinner;
    
}
@property (nonatomic, retain) IBOutlet UILabel *mainLabel;
@property (nonatomic, retain) IBOutlet UILabel *secondaryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *bigImageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@end
