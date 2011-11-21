//
//  MapMeViewController.m
//  MapMe
//
//  Created by jeff on 11/4/09.
//  Copyright Jeff LaMarche 2009. All rights reserved.
//

#import "MapMeViewController.h"
#import "MapLocation.h"

@implementation MapMeViewController
@synthesize mapView;
@synthesize progressBar;
@synthesize progressLabel;
@synthesize button;
#pragma mark -
- (IBAction)findMe {
    CLLocationManager *lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    lm.desiredAccuracy = kCLLocationAccuracyBest;
    [lm startUpdatingLocation];
    
    progressBar.hidden = NO;
    progressBar.progress = 0.0;
    progressLabel.text = NSLocalizedString(@"Determining Current Location", @"Determining Current Location");
    
    button.hidden = YES;
}
- (void)openCallout:(id<MKAnnotation>)annotation {
    progressBar.progress = 1.0;
    progressLabel.text = NSLocalizedString(@"Showing Annotation",@"Showing Annotation");
    [mapView selectAnnotation:annotation animated:YES];
}
#pragma mark -
- (void)viewDidLoad {
    mapView.mapType = MKMapTypeStandard;
//    mapView.mapType = MKMapTypeSatellite;
//    mapView.mapType = MKMapTypeHybrid;
}
- (void)viewDidUnload {
    self.mapView = nil;
    self.progressBar = nil;
    self.progressLabel = nil;
    self.button = nil;
}
- (void)dealloc {
    [mapView release];
    [progressBar release];
    [progressLabel release];
    [button release];
    [super dealloc];
}
#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    
    if ([newLocation.timestamp timeIntervalSince1970] < [NSDate timeIntervalSinceReferenceDate] - 60)
        return;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000, 2000); 
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    manager.delegate = nil;
    [manager stopUpdatingLocation];
    [manager autorelease];
    
    progressBar.progress = .25;
    progressLabel.text = NSLocalizedString(@"Reverse Geocoding Location", @"Reverse Geocoding Location");
    
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    geocoder.delegate = self;
    [geocoder start];
}
- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    
    NSString *errorType = (error.code == kCLErrorDenied) ? 
    NSLocalizedString(@"Access Denied", @"Access Denied") : 
    NSLocalizedString(@"Unknown Error", @"Unknown Error");
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:NSLocalizedString(@"Error getting Location", @"Error getting Location")
                          message:errorType 
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [manager release];
}
#pragma mark -
#pragma mark Alert View Delegate Methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    progressBar.hidden = YES;
    progressLabel.text = @"";
}
#pragma mark -
#pragma mark Reverse Geocoder Delegate Methods
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:NSLocalizedString(@"Error translating coordinates into location", @"Error translating coordinates into location")
                          message:NSLocalizedString(@"Geocoder did not recognize coordinates", @"Geocoder did not recognize coordinates") 
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    geocoder.delegate = nil;
    [geocoder autorelease];
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    progressBar.progress = 0.5;
    progressLabel.text = NSLocalizedString(@"Location Determined", @"Location Determined");
    
    MapLocation *annotation = [[MapLocation alloc] init];
    annotation.streetAddress = placemark.thoroughfare;
    annotation.city = placemark.locality;
    annotation.state = placemark.administrativeArea;
    annotation.zip = placemark.postalCode;
    annotation.coordinate = geocoder.coordinate;
    
    [mapView addAnnotation:annotation];
    
    
    [annotation release];
    
    geocoder.delegate = nil;
    [geocoder autorelease];
}
#pragma mark -
#pragma mark Map View Delegate Methods
- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
    static NSString *placemarkIdentifier = @"Map Location Identifier";
    if ([annotation isKindOfClass:[MapLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
        if (annotationView == nil)  {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier];
        }            
        else 
            annotationView.annotation = annotation;
        
        annotationView.enabled = YES;
        annotationView.animatesDrop = YES;
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.canShowCallout = YES;
        [self performSelector:@selector(openCallout:) withObject:annotation afterDelay:0.5];
        
        progressBar.progress = 0.75;
        progressLabel.text = NSLocalizedString(@"Creating Annotation",@"Creating Annotation");
        
        return annotationView;
    }
    return nil;
}
- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:NSLocalizedString(@"Error loading map", @"Error loading map")
                          message:[error localizedDescription] 
                          delegate:nil 
                          cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
