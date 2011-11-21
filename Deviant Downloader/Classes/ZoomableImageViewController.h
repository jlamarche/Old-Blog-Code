//
//  MCZoomableImageViewController.h
//  PAH Guide
//
//  Created by jeff on 4/14/10.
//  Copyright 2010 MartianCraft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultMaxZoom     3.f

typedef enum ZoomableImageViewFillType
{
    ZoomableImageFillTypeAspectFit,
    ZoomableImageFillTypeAspectFill
} ZoomableImageFillType;

@interface ZoomableImageViewController : UIViewController 
{
    UIScrollView                *scrollView;
    UIImageView                 *imageView;
    UIImage                     *image;
    
    NSString                    *onShowAlertString;
    ZoomableImageFillType     fillType;
    
    CGFloat                     maxZoom;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImage *image;
@property (nonatomic, retain) NSString *onShowAlertString;
@property ZoomableImageFillType fillType;
@property CGFloat maxZoom;
@end
