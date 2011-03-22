
#import "CompanyLookup.h"
#import <CoreLocation/CoreLocation.h>


@implementation CompanyLookup

@synthesize random;


- (id) init {
    self = [super init];
    if (self != nil){
        random = [Random new];
    }
    return self;
}


-(CLLocation*) locationByName:(NSString*) name {

	CLLocationDegrees latitude = 40.4 + 7*nextRandomFloat()/100;
	CLLocationDegrees longitude = -3.66 - 8*nextRandomFloat()/100;
	CLLocation *location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];

	return location;
}



@end
 