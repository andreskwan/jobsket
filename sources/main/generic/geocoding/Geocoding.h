
#import <CoreLocation/CoreLocation.h>
#import "HttpDownload.h"
#import "Random.h"
#import "ASIHTTPRequest.h"
#import "JsonParser.h"
#import "BundleFile.h"


// See http://code.google.com/apis/maps/documentation/geocoding/
@interface Geocoding : NSObject {
	NSDictionary *cityLocations;
}

@property (nonatomic, retain) NSDictionary *cityLocations;

/** Return a location for the address using the Google API. */
-(CLLocation*) geocodeAddress:(NSString*) address;

/** Return a fake location somewhere in Madrid */
-(CLLocation*) fakeLocateAddress:(NSString*) address;

/** Return a location for this city. */
-(CLLocation*) geocodeCity:(NSString*) city;

@end
