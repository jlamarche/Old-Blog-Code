//
//  OutletTestViewController.h
//  OutletTest
//
//  Created by jeff on 8/24/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutletTestViewController : UIViewController 
{

}
@property (nonatomic, assign) IBOutlet UIButton *button;
@property (nonatomic, assign) IBOutlet UIView *offscreenView;
- (IBAction)buttonPressed;
@end

