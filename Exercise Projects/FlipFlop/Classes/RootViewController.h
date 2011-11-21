//
//  RootViewController.h
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoveViewController, HateViewController;
@interface RootViewController : UIViewController {
    LoveViewController *loveController;
    HateViewController *hateController;
}
@property (nonatomic, retain) IBOutlet LoveViewController *loveController;
@property (nonatomic, retain) IBOutlet HateViewController *hateController;
- (IBAction)flip;
@end
