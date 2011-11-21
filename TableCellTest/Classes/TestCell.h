//
//  TestCell.h
//  TableCellTest
//
//  Created by jeff on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TestCell : UITableViewCell 
{
    UIImageView *cellImageView;
    UILabel     *cellLabel;
}
@property (nonatomic, retain) IBOutlet UIImageView *cellImageView;
@property (nonatomic, retain) IBOutlet UILabel *cellLabel;

+ (NSString *)reuseIdentifier;
@end
