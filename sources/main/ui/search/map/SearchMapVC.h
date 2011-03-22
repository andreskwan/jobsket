
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SearchMo.h"
#import "JobMo.h"
#import "CompanyMo.h"
#import "CompanyLookup.h"
#import "JobDao.h"
#import "CoreDataPersistentManager.h"
#import "SimpleAnnotation.h"
#import "Themes.h"
#import "Geocoding.h"


@interface SearchMapVC : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate> {
    MKMapView *mapView;
	CLLocationManager *locationManager;
	//SearchMo *searchMo;
	NSSet *jobs;
	Geocoding *geocoding;
}

@property(nonatomic, retain) Geocoding *geocoding;
//@property(nonatomic, retain) SearchMo *searchMo;
@property(nonatomic, retain) NSSet *jobs;
@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;


/** Add pins to the map. */
-(void) addPins;


/** 
 * Center the map on the given location. 
 * @param location Coords of the center of the map.
 * @param meters   Set to 500000 to zoom on a 500x500 km area.
 */
- (void)centerMap:(CLLocation *)location area:(int)meters;


/** 
 * Center the map on an area covering all annotations on the map. 
 */
- (void)centerMapOnAnnotations;


/** Push the ar kit view controller; */
//-(void) pushARKitVC;


@end
