
#import <UIKit/UIKit.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import <CoreLocation/CoreLocation.h>
#import "Geocoding.h"
#import "JsonMoBuilder.h"
#import "CompanyMo.h"
#import "DiskFile.h"


@interface GeocodingTest : GHTestCase {
    Geocoding *geocoding;
}
@property(nonatomic,retain) Geocoding *geocoding;
@end


@implementation GeocodingTest

@synthesize geocoding;

- (void) setUp {
	[super setUp];
//	geocoding = [[Geocoding alloc] init];
}


/*
- (void) test1Address {
	NSString *address = @"Calle Marqués de Riscal, 11, 28010 Madrid, España";
	CLLocation *location = [[Geocoding new] geocode:address];
	debug(@"location = %@", location);
	GHAssertTrue(location!=nil, nil);
}
*/


/*
 - (void) testEscape {
 
 NSString *address = @"C. Saavedra Meneses Nº107 2ºI";
 CLLocation *location = [[Geocoding new] locateAddress:address];
 
 CLLocation *location = [[[Geocoding alloc] init] locateAddress:address];
 CLLocationCoordinate2D coordinate = location.coordinate;
 CLLocationDegrees latitude = coordinate.latitude;
 CLLocationDegrees longitude = coordinate.longitude;
 
 debug(@"latitude=%f, longitude=%f", latitude, longitude);
 
 STAssertTrue(TRUE, @"blah");
 }
 */



-(void) test1GeocodeCompanies {
	NSString *url = @"http://ats.jobsket.com/api/companies";
	NSString *jsonIn = [[HttpDownload new] pageAsStringFromUrl:url];
	
	if (jsonIn==nil || [jsonIn length]==0){
		GHAssertTrue(FALSE, @"download failed, json was nil or 0 bytes");
	}
	
	NSSet *companies = [[JsonMoBuilder new] parseCompanies:jsonIn];
	NSMutableString *jsonOut = [[NSMutableString alloc] init];
	[jsonOut appendString:@"{\"companies\":["];
	
	NSArray *array = [companies allObjects];
	CompanyMo *company;
	for (int i=0; i<[array count]; i++) {
		company = (CompanyMo*)[array objectAtIndex:i];
		if (i<[array count]-1) [jsonOut appendFormat:@"%@, ", [company describeContents] ];
		else [jsonOut appendFormat:@"%@", [company describeContents] ];
	}

	[jsonOut appendString:@"]}"];
	debug(@"json is %@", jsonOut);
	
	DiskFile *file = [[DiskFile alloc] initWithFilename:@"1stTimeRun-companies" andExtension:@"json"];
	[file writeAsString:jsonOut];
	
}


/*
 
- (void) test2geocodeCity {
	CLLocation *location = [geocoding geocodeAddress:@"Dublin"];
	GHAssertNotNil(location, nil);
	
	geocoding = [[Geocoding alloc] init];
	NSArray *array = [NSArray arrayWithObjects:@"Dublin", @"Cork", @"Limerick", @"Galway", @"Waterford", @"Dundalk", @"Bray", @"Drogheda", @"Swords", @"Tralee", @"Kilkenny", @"Ennis", @"Sligo", @"Athlone", @"Wexford", @"Naas", @"Clonmel", @"Carlow", @"Newbridge", @"Navan", nil];
	for (NSString *city in array) {
		CLLocation *location = [geocoding geocodeAddress:[NSString stringWithFormat:@"%@,Ireland",city]];
		debug(@"%@: %@", city, location);		
		[NSThread sleepForTimeInterval:1];
	}
	
}


- (void) test2Address {
	geocoding = [[Geocoding alloc] init];
	NSArray *array = [NSArray arrayWithObjects:@"Madrid", @"Barcelona", @"Valencia", @"Sevilla", @"Zaragoza", @"Málaga", @"Murcia", @"Palma de Mallorca", @"Las Palmas de Gran Canaria", @"Bilbao", @"Alicante", @"Cordoba", @"Valladolid", @"Vigo", @"Gijón", @"L'Hospitalet de Llobregat", @"A Coruña", @"Vitoria-Gasteiz", @"Granada", @"Elche", @"Oviedo", @"Santa Cruz de Tenerife", @"Badalona", @"Cartagena", @"Terrassa", @"Jerez de la Frontera", @"Sabadell", @"Móstoles", @"Alcalá de Henares", @"Pamplona", @"Fuenlabrada", @"Almería", @"Leganés", @"Donostia-San Sebastián", @"San Sebastián", @"Santander", @"Castellón de la Plana", @"Burgos", @"Albacete", @"Alcorcón", @"Getafe", @"Salamanca", @"Logroño", @"San Cristóbal de La Laguna", @"Huelva", @"Badajoz", @"Tarragona", nil];
	for (NSString *city in array) {
		CLLocation *location = [geocoding geocodeAddress:[NSString stringWithFormat:@"%@,Spain",city]];
		warn(@"<key>%@</key><string>%f,%f</string>", city, location.coordinate.latitude, location.coordinate.longitude);
		[NSThread sleepForTimeInterval:1];
	}
}

*/
 
@end
