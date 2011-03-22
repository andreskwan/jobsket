
#import "JsonMoBuilder.h"

@implementation JsonMoBuilder

@synthesize jobDao, companyDao, searchDao, geocoding;


- (id) init {
    self = [super init];
    if (self != nil){
        jobDao = [[JobDao alloc] init];
		companyDao = [[CompanyDao alloc] init];
		searchDao = [[SearchDao alloc] init];
		geocoding = [[Geocoding alloc] init];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////


/** Parse a JSON document. */
-(NSSet*) parseCompanies:(NSString*)json {
	
	debug(@"PARSING COMPANIES from %d bytes of JSON", [json length]);
	NSDictionary *dic = [JsonParser parseJson:json];
	
	NSMutableSet *companies = nil;
	if (dic==nil){
		warn(@"Parsing failed.");
		
	} else if ([dic valueForKey:@"companies"]==nil) {
		warn(@"Parsing succeded but root key was not 'companies'.");
		
	} else {
		NSArray* array = [dic valueForKey:@"companies"];		
		companies = [[NSMutableSet alloc] initWithCapacity:[array count]];
		for(NSUInteger i=0; i<[array count]; i++) {
			NSDictionary *companyDic = [array objectAtIndex:i];
			[companies addObject:[self parseCompany:companyDic]];
		}
	}	
	
	return [companies autorelease];
}


-(CompanyMo*) parseCompany:(NSDictionary*)companyDic {
	
	// do we have this job in Core Data?
	CompanyMo *companyMo = [companyDao findByName:[companyDic objectForKey:@"name"]];
	
	if (companyMo==nil) {
		companyMo = [companyDao company];
		
		id obj = [companyDic objectForKey:@"postcode"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.postcode = obj;
		
		obj = [companyDic objectForKey:@"address"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.address = obj;
		
		obj = [companyDic objectForKey:@"logo"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.logo = obj;
		
		obj = [companyDic objectForKey:@"name"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.name = obj;
		
		obj = [companyDic objectForKey:@"region"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.region = obj;
		
		obj = [companyDic objectForKey:@"city"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.city = obj;
		
		obj = [companyDic objectForKey:@"key"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.key = obj;
		
		obj = [companyDic objectForKey:@"country"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.country = obj;
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		
		obj = [companyDic objectForKey:@"latitude"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.latitude = [formatter numberFromString:obj];
		
		obj = [companyDic objectForKey:@"longitude"];
		if (obj!=nil && [obj class]!=[NSNull class]) companyMo.longitude = [formatter numberFromString:obj];
		
        [formatter release]; 
        
		if ([companyMo.latitude floatValue]==0.0){
			CLLocation *location = [geocoding geocodeAddress:[companyMo fullAddress]];
			if (location){
				companyMo.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
				companyMo.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
			}
		}
	
		if ([companyMo isValid]){
			[companyDao save];
			debug(@"    Saving company with name %@", [companyMo name]);	
		} else {
			warn(    @"Company is invalid and won't be saved. Name: %@", [companyMo name]);
		}
		
	} 
	//else { debug(    @"Company already on Core Data.\n"); }
	
	//debug(@"\n");
	
	return companyMo;
}


////////////////////////////////////////////////////////////////////////////////////////////////////


/** Parse a JSON document. */
-(NSSet*) parseJobs:(NSString*)json {
	
	debug(@"parsing jobs from json = %@", json);
	NSDictionary *dic = [JsonParser parseJson:json];
	
	NSMutableSet *jobs = nil;
	if (dic==nil){
		warn(@"JSON parsing failed.");
		
	} else if ([dic valueForKey:@"jobs"]) {
		
		NSArray* array = [dic valueForKey:@"jobs"];
		jobs = [[NSMutableSet alloc] initWithCapacity:[array count]];
		for(NSUInteger i=0; i<[array count]; i++) {
			NSDictionary *jobDic = [array objectAtIndex:i];
			[jobs addObject:[self parseCompany:jobDic]];
		}
		
	} else {
        warn(@"JSON parsing succeded but don't know how to handle root key %@ ");
	}
	
    [jobs autorelease];
    
	return jobs;
}



-(JobMo*) parseJob:(NSString*)json {
	
	JobMo *jobMo = nil;
	
	//debug(@"parsing job from json = %@", json);
	NSDictionary *dic = [JsonParser parseJson:json];
	
	if (dic==nil){
		warn(@"JSON parsing failed.");
		
	} else if ([dic valueForKey:@"job"]) {
		NSArray* array = [dic valueForKey:@"job"];
		jobMo = [self parseJobFromArray:array];
		
	} else {
        warn(@"JSON parsing succeded but don't know how to handle root key %@ ");
	}
	
	return jobMo;
}



/** 
 * Parse a JSON document containing one job.
 * @param array NSArray parsed by JSONKit for the key "job" of the JSON document.
 */
-(JobMo*) parseJobFromArray:(NSArray*)array {
	
	// Each element of the array is a dictionary with only one key. 
	// We are going to gather everything on just one dictionary.
	NSMutableDictionary *jobDic = [[NSMutableDictionary alloc] initWithCapacity:[array count]];
	for(NSUInteger i=0; i<[array count]; i++) {
		NSDictionary *dic = [array objectAtIndex:i];
		NSString *key = [[dic allKeys] objectAtIndex:0];
		id value = [dic objectForKey:key];
		if (value!=nil) {
		    [jobDic setObject:value forKey:key];
		}
		//debug(@"key=%@, \t\tclass=%@, \t\tobject=%@", key, [value class], key);
	}
	
	// do we have this job in Core Data?
	JobMo *jobMo = [jobDao findByUrl:[jobDic objectForKey:@"url"]];
	
	// if job doesn't exist, create it
	if (jobMo==nil) {
		jobMo = [jobDao job];
	}
	
	if ([jobMo needsFilling]){

		id obj = [jobDic objectForKey:@"category"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.category = obj;
		
		obj = [jobDic objectForKey:@"city"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.city = obj;
		
		NSString *companyName = [jobDic objectForKey:@"companyName"];
		if (obj!=nil && [obj class]!=[NSNull class]) {
			jobMo.company = [self lookUpCompany:companyName];
		}
		
		obj = [NSDate dateFromRFC3339String:[jobDic objectForKey:@"date"]]; // 2010-12-22T17:20:40Z
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.date = obj;
		
		obj = [jobDic objectForKey:@"experience"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.experience = obj;
		
		obj = [jobDic objectForKey:@"identifier"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.identifier = obj;
		
		obj = [jobDic objectForKey:@"maxSalary"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.maxSalary = obj;
		
		obj = [jobDic objectForKey:@"minSalary"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.minSalary = obj;
		
		obj = [jobDic objectForKey:@"place"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.place = obj;
		
		obj = [jobDic objectForKey:@"reference"]; // string?
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.reference = obj;
		
		obj = [jobDic objectForKey:@"status"]; 
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.status = obj;
		
		obj = [jobDic objectForKey:@"title"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.title = obj;
		
		obj = [jobDic objectForKey:@"url"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.url = obj;
		
		obj = [jobDic objectForKey:@"visits"];
		if (obj!=nil && [obj class]!=[NSNull class]) jobMo.visits = obj;
		
		jobMo.favorite = [NSNumber numberWithInt:0];
		
		jobMo.lastRefresh = [NSDate date];
		
		NSString *text=nil;
		obj = [jobDic objectForKey:@"content"];
		if (obj!=nil && [obj class]!=[NSNull class]) text = obj;
		if (text){
			// stupid shit to split the content field
			
			// breakdown the string
			NSScanner *scanner = [NSScanner scannerWithString:text];
			NSString *description = nil;
			NSString *requirements = nil;
			NSString *experience = nil;
			NSString *other = nil;
			[scanner scanUpToString:@"<p class=\"jobsection\">Requerimientos:</p>" intoString:&description];
			[scanner scanUpToString:@"<p class=\"jobsection\">Experiencia:</p>" intoString:&requirements];
			[scanner scanUpToString:@"<p class=\"jobsection\">Otros:</p>" intoString:&experience];
			other = [text substringFromIndex:[scanner scanLocation]];
			
			// case where there are no html tags
			// eg: ANALISTA FUNCIONAL SENIOR JAVA
			if ([text rangeOfString:@"jobsection"].location==NSNotFound){
				debug(@"no html tags in the content field of job %@", jobMo.title);
				description = text;
				debug(@"description >> %@", description);
			}
			
			// strip tags
			description = [[description stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
			requirements = [[requirements stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
			experience = [[experience stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
			other = [[other stringByReplacingOccurrencesOfRegex:@"\\<.*?>" withString:@""] gtm_stringByUnescapingFromHTML];
			
			// strip headers
			requirements = [requirements stringByReplacingOccurrencesOfString:@"Requerimientos:" withString:@""];
			experience = [experience stringByReplacingOccurrencesOfString:@"Experiencia:" withString:@""];
			other = [other stringByReplacingOccurrencesOfString:@"Otros:" withString:@""];
			
			// reduce consecutive spaces to one
			description = [description stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
			requirements = [requirements stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
			experience = [experience stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
			other = [other stringByReplacingOccurrencesOfRegex:@"(\\s+)" withString:@" "];
			
			// ensure we don't return nil cause later we screw up if we use these on arrays
			jobMo.content = description==nil ? @"" : description;
			jobMo.experience = experience==nil ? @"" : experience;
			jobMo.requirements = requirements==nil ? @"" : requirements;
			jobMo.other = other==nil ? @"" : other;
			
		}
	}
	
    [jobDao save];
	debug(@"Saving job: %@", [jobMo title]);
	[jobDic release];
    
	return jobMo;
}



////////////////////////////////////////////////////////////////////////////////////////////////////



/** Parse a JSON document. */
-(SearchMo*) parseSearch:(NSString*)json fromQuery:(Query*)query {

	debug(@"json: %@", json);
	
	SearchMo *searchMo = nil;
	NSString *url = [query urlForJsonSearch];
	
	debug(@"PARSING SEARCH from %d bytes of json", [json length]);
	NSDictionary *dic = [JsonParser parseJson:json];	
	
	// bail out if parsing failed
	{
		if (dic==nil){
			warn(@"Parsing failed.");
			return nil;
		} else if ([dic valueForKey:@"results"]==nil) {
			warn(@"Parsing succeded but root key was not 'results'.");
			return nil;
		}
    }
	
	// create object
	debug(@"CREATING searchMo");
	searchMo = [searchDao search];
	searchMo.date = [NSDate date];
	
	// transfer data from the query object to the searchMo
	searchMo.url = url;
	if (query.location) searchMo.location = query.location; 
	if (query.maxSalary) searchMo.maxSalary = query.maxSalary;
	if (query.minSalary) searchMo.minSalary = query.minSalary;
	if (query.category) searchMo.category = query.category;
	if (query.keywords) searchMo.keywords = query.keywords;
	if (query.experience) searchMo.experience = query.experience;
	
    debug(@"query.category=%@, searchMo.category=%@", query.category, searchMo.category);
    
	// create child jobs
	NSMutableSet *jobSet = [[NSMutableSet alloc] init];
	
	NSArray *array = [[dic objectForKey:@"results"] objectForKey:@"jobs"];
	debug(@"    There are %d jobs", [array count]);
	
	for(NSUInteger i=0; i<[array count]; i++) {
		NSDictionary *jobDic = [array objectAtIndex:i];

		// do we have this job in Core Data?
		JobMo *jobMo = [jobDao findByIdentifier:(NSNumber*)[jobDic objectForKey:@"id"]];
		BOOL found = jobMo!=nil;
		
		if (found){
			debug(@"    Found job: %@", [jobMo title]);
			
		} else {
			//debug(@"    Creating job.");
			jobMo = [jobDao job];
			
			// can't call "parseJob:" for this because it has a different format
			// why it has a different format? there isn't a good reason
			//for (NSString *key in jobDic){
			id obj = [jobDic objectForKey:@"title"];
			if (obj!=nil && [obj class]!=[NSNull class]) jobMo.title = obj;
			
			obj = [jobDic objectForKey:@"id"];
			if (obj!=nil && [obj class]!=[NSNull class]) jobMo.identifier = obj; // NSNumber
			
			obj = [jobDic objectForKey:@"region"];
			if (obj!=nil && [obj class]!=[NSNull class]) jobMo.region = obj;
			
			obj = [jobDic objectForKey:@"category"];
			if (obj!=nil && [obj class]!=[NSNull class]) jobMo.category = obj;
			
			obj = [jobDic objectForKey:@"city"];
			if (obj!=nil && [obj class]!=[NSNull class]) jobMo.city = obj;

			jobMo.url = [NSString stringWithFormat:@"http://ats.jobsket.com/api/job/%@", jobMo.identifier];
			
			//debug(@"job so far is %@", [jobMo describe]);
			
			NSString *companyName = [jobDic objectForKey:@"companyName"];
			if (obj!=nil && [obj class]!=[NSNull class]) {
                CompanyMo *company = [self lookUpCompany:companyName];
				jobMo.company = company; // TODO: EXC_BAD_ACCESS, multithread access to the context
			}
				
			[jobSet addObject:jobMo];
			//debug(@"job created: %@", [jobMo title]);
		}
	}
	
	searchMo.jobs = jobSet;
	[searchDao save];
	debug(@"Saving search: %@", [searchMo url]);
	
	return searchMo;
}



////////////////////////////////////////////////////////////////////////////////////////////////////


-(CompanyMo*) lookUpCompany:(NSString*)companyName {
	CompanyMo *companyMo = [companyDao findByName:companyName];
    
	if (companyMo==nil) {
		NSArray *allCompanies = [companyDao objectsOfEntityName:@"CompanyMo"];
		companyName = [companyName lowercaseString];
		for (CompanyMo *company in allCompanies) {
			float f = [[company.name lowercaseString] compareWithString: companyName];
			if (f<2){
				companyMo = company;
				debug(@"SCORE %f for %@, %@", f, [company.name lowercaseString] , companyName);
				break;
			}
		}
	}
    
	if (companyMo==nil) {
        warn(@"no luck for %@", companyName);
    }
	
	return companyMo;
}

/*
if (companyMo==nil){
	// if not found, we probably never downloaded the file with all companies
	debug(@"    Looking for company with name %@", companyName);
	NSString *jsonCompanies = [[HttpDownload new] pageAsStringFromUrl:@"http://ats.jobsket.com/api/companies"];
	[self parseCompanies:jsonCompanies]; // this parses and saves to core data
	// try again
	companyMo = [companyDao findByName:companyName];
	if (companyMo==nil){
		warn(@"Couldn't find a company named %@", companyName);
	}
}
*/
	

@end
