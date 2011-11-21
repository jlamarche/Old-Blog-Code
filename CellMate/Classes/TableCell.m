//
//  TableCell.m
//  Simple Table
//
//  Created by jeff on 8/13/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import "TableCell.h"


@implementation TableCell
@synthesize mainLabel;
@synthesize secondaryLabel;
@synthesize bigImageView;
@synthesize spinner;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [mainLabel release];
    [secondaryLabel release];
    [bigImageView release];
    [spinner release];
    [super dealloc];
}


@end
