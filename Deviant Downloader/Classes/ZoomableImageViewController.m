//
//  MCZoomableImageViewController.m
//  PAH Guide
//
//  Created by jeff on 4/14/10.
//  Copyright 2010 MartianCraft. All rights reserved.
//

#import "ZoomableImageViewController.h"

@interface ZoomableImageViewController()
- (void)recalculateImageSize;
@end

@implementation ZoomableImageViewController
@synthesize scrollView;
@synthesize imageView;
@synthesize image;
@synthesize onShowAlertString;
@synthesize fillType;
@synthesize maxZoom;

- (id)init
{
    if (self = [super initWithNibName:@"ZoomableImageViewController" bundle:nil])
    {
        self.fillType = ZoomableImageFillTypeAspectFit;
        self.maxZoom = kDefaultMaxZoom;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self recalculateImageSize];
}
- (void)viewDidLoad
{    
    [self recalculateImageSize];
    
    if (onShowAlertString != nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:onShowAlertString 
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
    self.scrollView = nil;
    self.imageView = nil;
    self.image = nil;
}
- (void)dealloc 
{
    [scrollView release];
    [imageView release];
    [image release];
    [onShowAlertString release];
    [super dealloc];
}
#pragma mark -
#pragma mark Scrollview Delegate Methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
    UIImage *theImage = self.image;
    CGSize scrollSize = [theScrollView bounds].size;
    CGSize imageSize = theImage.size;
    CGFloat topInset = (scrollSize.height - imageSize.height * [scrollView zoomScale]) / 2.0;
    if (topInset < 0.0)
        topInset = 0.0;
    [scrollView setContentInset:UIEdgeInsetsMake(topInset, 0.0, -topInset, 0.0)];
}
#pragma mark -
#pragma mark Extension Methods
- (void)recalculateImageSize
{
    if (self.image == nil) return;

    if (imageView != nil)
    {
        [imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    UIImage *theImage = self.image;
    CGImageRef imageRef = theImage.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    CGSize imageSize = CGSizeMake(width, height);
    [scrollView setContentSize:imageSize];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0,imageSize.width, imageSize.height)];
    self.imageView = anImageView;
    [anImageView release];
    
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.image = theImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    
    CGSize scrollSize = scrollView.frame.size;
    CGFloat widthRatio = scrollSize.width / imageSize.width;
    CGFloat heightRatio = scrollSize.height / imageSize.height;
    
    CGFloat initialZoom;;
    
    
    if (fillType == ZoomableImageFillTypeAspectFill)
        initialZoom = (widthRatio > heightRatio) ? widthRatio : heightRatio;
    else
        initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    [scrollView setMaximumZoomScale:maxZoom * initialZoom];
    [scrollView setMinimumZoomScale:initialZoom];
    [scrollView setZoomScale:initialZoom];
    [scrollView setBouncesZoom:YES];
    
    if (fillType == ZoomableImageFillTypeAspectFit)
    {
        imageView.center = scrollView.center; 
    }
    else
    {
        imageView.center = CGPointMake(scrollView.center.x, imageView.center.y - 20.f);

        // For some reason, size the status bar not getting factored into zoom calculation; this adjusts.
        [scrollView setContentSize:CGSizeMake(imageSize.width * initialZoom, scrollView.contentSize.height + 20.f)];
    }
    
}
@end
