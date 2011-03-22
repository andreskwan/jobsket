
#import "Geocoding.h"


@implementation Geocoding

@synthesize cityLocations;


- (id) init {
    self = [super init];
    if (self != nil){
		
		NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:1];
	
		debug(@"loading citiestownsvillages-ie.plist");
		BundleFile *bundleFile = [[BundleFile alloc] initWithFilename:@"citiestownsvillages-ie" andExtension:@"plist"];
		NSDictionary *dic = [bundleFile dictionaryFromPlist];
		[mDic addEntriesFromDictionary:dic];
		[bundleFile release];
        
		debug(@"loading citiestownsvillages-es.plist");
		bundleFile = [[BundleFile alloc] initWithFilename:@"citiestownsvillages-es" andExtension:@"plist"];
		dic = [bundleFile dictionaryFromPlist];

		[mDic addEntriesFromDictionary:dic];
		[bundleFile release];
        
		self.cityLocations = [NSDictionary dictionaryWithDictionary:dic];
    }
    return self;
}


-(CLLocation*) geocodeCity:(NSString*) city {
	NSString *location = [cityLocations objectForKey:city];
	
	if (location==nil) {
		debug(@"no location for city %@", city);
		return nil;
	}
	
	NSArray *split = [location componentsSeparatedByString:@","];
	if ([split count]!=2) {
		debug(@"split failed for city, coords string was %@", location);
		return nil;
	}
	
	double lat = [(NSString*)[split objectAtIndex:0] doubleValue];
	double lon = [(NSString*)[split objectAtIndex:1] doubleValue];
	CLLocation *coords = [[[CLLocation alloc] initWithLatitude:lat longitude:lon] autorelease];
	
	return coords;
}


-(CLLocation*) geocodeAddress:(NSString*) address {
	
	// don't make requests faster than 0.5 seconds
	// Google may block/ban your requests if you abuse the service
    double pause = 0.5;
	static NSDate *lastPetition = nil;
	if (lastPetition==nil) lastPetition = [NSDate date];
	NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:lastPetition];
	lastPetition = [NSDate date];
	if (elapsed>0.0 && elapsed<pause){
		debug(@"Sleeping for %f seconds", pause-elapsed);
		[NSThread sleepForTimeInterval:pause-elapsed];
	}
	
	// url encode
	NSString *encodedAddress = (NSString *) CFURLCreateStringByAddingPercentEscapes(
								NULL, (CFStringRef) address,
								NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]",
								kCFStringEncodingUTF8 );
	
	// set this to true if you want this method to return a fake location somewhere in madrid
	if (FALSE) return [self fakeLocateAddress:encodedAddress];
	
	NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", encodedAddress];
	debug(@"    url is %@", url);
	[encodedAddress release];
    
	// send two geocode requests
	NSDictionary *dic;
	for (int i=0; i<2; i++) { // two tries
	
		HttpDownload *http = [HttpDownload new];
		NSString *page = [http pageAsStringFromUrl:url];
        [http release];
		dic = [JsonParser parseJson:page];
		NSString *status = (NSString*)[dic objectForKey:@"status"];
		BOOL success = [status isEqualToString:@"OK"];
		if (success) break;
		
		// Query failed
		// See http://code.google.com/apis/maps/documentation/geocoding/#StatusCodes
		if ([status isEqualToString:@"OVER_QUERY_LIMIT"]){
			debug(@"try #%d", i);
			[NSThread sleepForTimeInterval:1];
		} else if ([status isEqualToString:@"ZERO_RESULTS"]){
			debug(@"    Address unknown: %@", address);
			break;
		} else {
			// REQUEST_DENIED: no sensor parameter. Shouldn't happen.
			// INVALID_REQUEST: no address parameter or empty address. Doesn't matter.
		}

	}
	
	// if we fail after two tries, just leave
	BOOL success = [(NSString*)[dic objectForKey:@"status"] isEqualToString:@"OK"];
	if (!success) return nil;
	
	// extract the data
	NSDictionary *locationDic = [[[[dic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
	NSNumber *latitude = [locationDic objectForKey:@"lat"];
	NSNumber *longitude = [locationDic objectForKey:@"lng"]; 	
	debug(@"    Google returned latitude=%f, longitude=%f for %@", [latitude floatValue], [longitude floatValue], address);
	
	// return as location
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
	
    return [location autorelease];
}


-(CLLocation*) fakeLocateAddress:(NSString*) address {
	//Random *random = [Random new];
	CLLocationDegrees latitude = 40.4 + 7*nextRandomFloat()/100;
	CLLocationDegrees longitude = -3.66 - 8*nextRandomFloat()/100;
	CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	return [location autorelease];
}


@end


/* GEOCODING WITH GOOGLE ///////////////////////////////////////////////////////////////////////////
	
	Address: C. Saavedra Meneses Nº107 2ºI, Betanzos, España
	 
	URL: http://maps.googleapis.com/maps/api/geocode/json?address=
		 C.+Saavedra+Meneses+N%C2%BA107+2%C2%BAI,+Betanzos,+Espa%C3%B1a&sensor=true
	
	JSON returned should be:
	{
		status: "OK";
	    results: [
	        {
	            types: [ ... ];
    	        formatted_address: "Betanzos, Spain",
	            address_components: [ ... ],
	            geometry: {
	                location: {
	                    lat: 43.2810597,
	                    lng: -8.2113155
    	            },
	                location_type: "APPROXIMATE",
	                viewport: { ... },
	                bounds: { ... }
    	        },
	    	    partial_match: true
			}
        ] 
	}
	 
*/

