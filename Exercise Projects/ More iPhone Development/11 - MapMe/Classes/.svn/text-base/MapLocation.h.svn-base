#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapLocation : NSObject <MKAnnotation, NSCoding> {
    NSString *streetAddress;
    NSString *city;
    NSString *state;
    NSString *zip;
    
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, copy) NSString *streetAddress;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@end
