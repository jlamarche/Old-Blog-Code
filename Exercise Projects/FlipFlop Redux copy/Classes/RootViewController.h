//
//  RootViewController.h
//  FlipFlop
//
//  Created by jeff on 8/11/09.
//  Copyright 2009 Jeff LaMarche. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoveViewController, HateViewController, ModalViewController;
@interface RootViewController : UIViewController {
    LoveViewController *loveController;
    HateViewController *hateController;
    ModalViewController *modalController;
}
@property (nonatomic, retain) IBOutlet LoveViewController *loveController;
@property (nonatomic, retain) IBOutlet HateViewController *hateController;
@property (nonatomic, retain) IBOutlet ModalViewController *modalController;
- (IBAction)flip;
- (IBAction)doModal;
@end
