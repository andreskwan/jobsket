
#import "JobMo.h"
#import "CompanyMo.h"
#import "SearchMo.h"

@implementation JobMo 

@dynamic company, date, location, content, searches, title, url, favorite;
@dynamic identifier, lastRefresh, category, requirements, experience, other, region;
@dynamic city, maxSalary, minSalary, place, reference, status, visits;



-(BOOL) isValid {
    BOOL valid = self.title && self.url && [self.company isValid];
	//debug(@"JobMo.isValid=%@", valid ? @"Yes" : @"No");
	return valid;
}


-(NSArray*) keys {
	// excluding @"search" to avoid cyles
	return [NSArray arrayWithObjects:@"url", @"identifier", @"date",@"location",@"name",@"company", 
			                         @"category", @"content", @"requirements", @"experience", @"other", 
			                         @"city", @"maxSalary", @"minSalary", @"place", @"reference", @"status", @"visits", nil];
}


-(void) addSearch:(SearchMo*)searchMo {
	if (self.searches==nil){
		self.searches = [NSSet setWithObject:searchMo];
	} else {
		// create a mutable set just to add the object
		NSMutableSet *mSet = [NSMutableSet setWithSet:self.searches];
		[mSet addObject:searchMo];
		// save it back as a non mutable set
		self.searches = [NSSet setWithSet:mSet];
	}
}



-(NSString*) shortDescribe {
	return self.title;
}



-(NSString*) describe {
	JsonEscape *je = [JsonEscape new];
	NSMutableString *jsonJob = [NSMutableString new];
	[jsonJob appendString:@"\n\"JobMo\" :\n{"];
	NSMutableArray *arrayFields = [NSMutableArray new];

	[arrayFields addObject:[NSString stringWithFormat:@"\n        \"category\" : %@", [self describeString:self.category] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n            \"city\" : %@", [self describeString:self.city] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n     \"companyName\" : %@", [self describeString:self.company.name] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n         \"content\" : %@", [self describeString:[je escape:self.content]] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n            \"date\" : %@", [self describeDate:self.date] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n      \"experience\" : %@", [self describeString:self.experience] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n      \"identifier\" : %@", [self describeNumber:self.identifier] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n        \"favorite\" : %@", [self describeNumber:self.favorite] ]]; // not from jobsket
	[arrayFields addObject:[NSString stringWithFormat:@"\n     \"lastRefresh\" : %@", [self describeDate:self.lastRefresh] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n        \"location\" : %@", [self describeString:[je escape:self.location]] ]]; // from html
	[arrayFields addObject:[NSString stringWithFormat:@"\n       \"minSalary\" : %@", [self describeNumber:self.maxSalary] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n       \"minSalary\" : %@", [self describeNumber:self.minSalary] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n           \"other\" : %@", [self describeString:self.other] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n           \"place\" : %@", [self describeString:self.place] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n       \"reference\" : %@", [self describeString:self.reference] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n          \"region\" : %@", [self describeString:self.region] ]];	
	[arrayFields addObject:[NSString stringWithFormat:@"\n    \"requirements\" : %@", [self describeString:self.requirements] ]]; // from html
	[arrayFields addObject:[NSString stringWithFormat:@"\n          \"status\" : %@", [self describeString:self.status] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n           \"title\" : %@", [self describeString:[je escape:self.title]] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n             \"url\" : %@", [self describeString:[je escape:self.url]] ]];
	[arrayFields addObject:[NSString stringWithFormat:@"\n          \"visits\" : %@", [self describeNumber:self.visits] ]];
	
	[jsonJob appendFormat:@"%@", [arrayFields componentsJoinedByString:@","]];
	[jsonJob appendString:@"\n}"];
	
    [je release];
    [arrayFields release];
    
	return [jsonJob autorelease];
}


-(NSString*) describeString:(NSString*)string {
	return (string==nil || [string class]==[NSNull class]) ? @"null" : [NSString stringWithFormat:@"\"%@\"",string];
}
-(NSString*) describeNumber:(NSNumber*)number {
	return (number==nil || [number class]==[NSNull class]) ? @"null" : [NSString stringWithFormat:@"%@",number];
}
-(NSString*) describeDate:(NSDate*)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"]; // jobsket format
	NSString *formattedDate = [dateFormatter stringFromDate:self.date];
	NSString *result = (date==nil || [date class]==[NSNull class]) ? @"null" : [NSString stringWithFormat:@"\"%@\"",formattedDate];
    [dateFormatter release];
    return result;
}							


-(BOOL) needsFilling {
	return self.lastRefresh == nil;
    //return !self.category && !self.content && !self.requirements && !self.experience && !self.other;
}


@end
