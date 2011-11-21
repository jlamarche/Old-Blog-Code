//
//  RequestTypesViewController.h
//  RequestTypes
//
//  Created by jeff on 11/1/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFormURL @"http://iphonedevbook.com/more/10/echo.php"

@interface RequestTypesViewController : UIViewController {
    UIWebView       *webView;
    UITextField     *paramName;
    UITextField     *paramValue;

    
    NSMutableData           *receivedData;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UITextField *paramName;
@property (nonatomic, retain) IBOutlet UITextField *paramValue;

@property (nonatomic, retain) NSMutableData *receivedData;

- (IBAction)doGetRequest;
- (IBAction)doPostRequest;
@end

