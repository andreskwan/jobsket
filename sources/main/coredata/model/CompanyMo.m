
#import "CompanyMo.h"

@implementation CompanyMo 

@dynamic address, jobs, latitude, longitude, name, url;
@dynamic city, country, key, logo, postcode, region;


-(BOOL) isValid {
	BOOL valid = self.name!=nil; 
	//debug(@"CompanyMo.isValid=%@", valid ? @"Yes" : @"No");
	return valid;
}


-(NSArray*) keys {
	// excluding @"jobs" to avoid cycles
	return [NSArray arrayWithObjects:@"address", @"city", @"country", @"key", @"latitude", 
			@"logo", @"longitude", @"name", @"postcode", @"region", @"url", nil]; 
}


-(NSString*) shortDescribe {
	return self.name;
}


-(NSString*) describe {
	return [NSString stringWithFormat:@"\n\"CompanyMo\" : %@ ", [self describeContents]];
}


-(NSString*) describeContents {
	NSMutableString *json = [NSMutableString new];
	[json appendString:@"\n{"];
	JsonEscape *je = [JsonEscape new];
	NSMutableArray *arrayFields = [NSMutableArray new];
	if (self.address)   [arrayFields addObject:[NSString stringWithFormat:@"\n     \"address\" : \"%@\"", [je escape:self.address]]];
	if (self.city)      [arrayFields addObject:[NSString stringWithFormat:@"\n        \"city\" : \"%@\"", [je escape:self.city]]];
	if (self.country)   [arrayFields addObject:[NSString stringWithFormat:@"\n     \"country\" : \"%@\"", [je escape:self.country]]];
	if (self.key)       [arrayFields addObject:[NSString stringWithFormat:@"\n         \"key\" : \"%@\"", [je escape:self.key]]];
	if (self.latitude)  [arrayFields addObject:[NSString stringWithFormat:@"\n    \"latitude\" : \"%@\"", self.latitude]];
	if (self.logo)      [arrayFields addObject:[NSString stringWithFormat:@"\n        \"logo\" : \"%@\"", [je escape:self.logo]]];
	if (self.longitude) [arrayFields addObject:[NSString stringWithFormat:@"\n   \"longitude\" : \"%@\"", self.longitude]];
	if (self.name)      [arrayFields addObject:[NSString stringWithFormat:@"\n        \"name\" : \"%@\"", [je escape:self.name]]];
	if (self.postcode)  [arrayFields addObject:[NSString stringWithFormat:@"\n    \"postcode\" : \"%@\"", [je escape:self.postcode]]];
	if (self.region)    [arrayFields addObject:[NSString stringWithFormat:@"\n      \"region\" : \"%@\"", [je escape:self.region]]];
	if (self.url)       [arrayFields addObject:[NSString stringWithFormat:@"\n         \"url\" : \"%@\"", self.url]];
	[json appendFormat:@"%@", [arrayFields componentsJoinedByString:@","]];
	[json appendString:@"\n}"];
	[je release];
    [arrayFields release];
    
	return [json autorelease];
}


-(NSString*) fullAddress {

	NSMutableArray *arrayFields = [NSMutableArray new];
	if (self.address) [arrayFields addObject:self.address];
	if (self.postcode) [arrayFields addObject:self.postcode];
	if (self.city) [arrayFields addObject:self.city];
	if (self.country) [arrayFields addObject:self.country];
	NSString *address = [arrayFields componentsJoinedByString:@","];
	debug(@"address: %@", address);
	[arrayFields release];
    
	return address;
}


@end
