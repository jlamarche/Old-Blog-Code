#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapMeViewController : UIViewController 
    <CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate> {
    MKMapView           *mapView;
    UIProgressView      *progressBar;
    UILabel             *progressLabel;
    UIButton            *button;    
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIProgressView *progressBar;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)findMe;
@end
