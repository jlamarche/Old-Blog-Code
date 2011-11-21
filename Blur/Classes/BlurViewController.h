//
//  BlurViewController.h
//  Blur
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurViewController : UIViewController {

}
@property (nonatomic, assign) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) IBOutlet UIButton *blurButton;
- (IBAction)blur;
- (IBAction)reset;
@end

