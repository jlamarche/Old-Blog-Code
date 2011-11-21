#import "MKMapView-CoordsDisplay.h"

@implementation MKMapView(CoordsDisplay)
- (BOOL)coordinatesInRegion:(CLLocationCoordinate2D)coords  {
    
    
    CLLocationDegrees leftDegrees = self.region.center.longitude - (self.region.span.longitudeDelta / 2.0);
    CLLocationDegrees rightDegrees = self.region.center.longitude + (self.region.span.longitudeDelta / 2.0);
    CLLocationDegrees bottomDegrees = self.region.center.latitude - (self.region.span.latitudeDelta / 2.0);
    CLLocationDegrees topDegrees = self.region.center.latitude + (self.region.span.latitudeDelta / 2.0);
    
    if (leftDegrees > rightDegrees) { // Int'l Date Line in View
        leftDegrees = -180.0 - leftDegrees;
        if (coords.longitude > 0)
            coords.longitude = -180.0 - coords.longitude; 
    } 
    
    return leftDegrees <= coords.longitude && coords.longitude <= rightDegrees && bottomDegrees <= coords.latitude && coords.latitude <= topDegrees;
}
@end
