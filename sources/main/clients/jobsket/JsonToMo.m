
#import "JsonToMo.h"

@implementation JsonToMo

@synthesize searchDao, companyDao, jobDao,  manager;


- (id) init {
    self = [super init];
	if (self != nil){
		self.manager = [CoreDataPersistentManager sharedInstance];
		self.searchDao = [[SearchDao alloc] initWithManager:manager];
		self.companyDao = [[CompanyDao alloc] initWithManager:manager];
		self.jobDao = [[JobDao alloc] initWithManager:manager];
	}
	return self;
}


-(SearchMo*) safeSearchFromJson:(NSString*)jsonString {
    @try {
		return [self searchFromJson:jsonString];
	}
	@catch (NSException * e) {
		warn(@"%@ %@", [e name], [e reason]);
		return nil;
	}
}


-(SearchMo*) searchFromJson:(NSString*)jsonString {
	
    NSDictionary *rootDict = [JsonParser parseJson:jsonString];
	NSArray *rootDictKeys = [rootDict allKeys];
	
	if ([rootDictKeys count]!=1){
		warn(@"there should be exactly one root element, there are %d", [rootDictKeys count]);
		return nil;
	}
	
	// get the dictionary containing the fields of the SearchMo 
	NSString *searchKey = [rootDictKeys lastObject];
	NSDictionary *searchFieldsDict = [rootDict objectForKey:searchKey];

	// create a SearchMo object
	SearchMo *searchMo = [searchDao search];
	//searchMo.lastUpdated = [NSDate date];
	
	// prepare to gathering jobs
	NSMutableSet *jobsSet = [NSMutableSet setWithCapacity:0];
	
	// iterate over every search field
	for (NSString *searchFieldKey in searchFieldsDict) {
		
		//debug(@"key = %@, value = %@",searchFieldKey, [searchFieldsDict objectForKey:searchFieldKey]);
		
		if ([searchFieldKey isEqualToString:@"jobs"]) {	
			
			// at this point, searchFieldKey = 'jobs'
		    //debug(@"jobs? search.%@=...", searchFieldKey);
			NSDictionary *jobsDict = [searchFieldsDict objectForKey:searchFieldKey];
			for (id jobKey in jobsDict) {
				
				// get the fields dictionary for the current job
				NSDictionary *jobDict = [jobsDict objectForKey:jobKey];
				
				JobMo *jobMo = [jobDao job];
				
				// iterate over the fields of the current job
				for (id jobFieldKey in jobDict) {
					
					if ([(NSString*)jobFieldKey isEqualToString:@"date"]) {
						NSDateFormatter *formatter = [NSDateFormatter new];
						[formatter setDateFormat:@"dd/MM/yyy"];
						NSDate *date = [formatter dateFromString:[jobDict objectForKey:jobFieldKey]];
						jobMo.date = date;
						[formatter release];
                        
					} else if ([(NSString*)jobFieldKey isEqualToString:@"CompanyMo"]) {
						// process job's company
						//debug(@"company? job.%@=...", jobFieldKey);
						CompanyMo *companyMo = [companyDao company];
						
						NSDictionary *companyDict = [jobDict objectForKey:jobFieldKey];
                        for (id companyFieldKey in companyDict) {
							//debug(@"company.%@=%@", companyFieldKey, [companyDict objectForKey:companyFieldKey]);
							[companyMo setValue:[companyDict objectForKey:companyFieldKey] forKey:companyFieldKey];
						}
						
						jobMo.company = companyMo;
						
					} else {
						// process single job field
						//debug(@"job.%@=%@", jobFieldKey, [jobDict objectForKey:jobFieldKey]);
						[jobMo setValue:[jobDict objectForKey:jobFieldKey] forKey:jobFieldKey];
					}
					
				}
				
				[jobsSet addObject:jobMo];
			}
			searchMo.jobs = jobsSet;
			
		} else if ([searchFieldKey isEqualToString:@"date"]) {
			NSDateFormatter *formatter = [NSDateFormatter new];
			[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
			NSDate *date = [formatter dateFromString:[searchFieldsDict objectForKey:searchFieldKey]];
			[searchMo setValue:date forKey:searchFieldKey];
			[formatter release];
            
		} else {
			// process any other search field
			//debug(@"search.%@=%@", searchFieldKey, [searchFieldsDict objectForKey:searchFieldKey]);
			[searchMo setValue:[searchFieldsDict objectForKey:searchFieldKey] forKey:searchFieldKey];
		}
		
	}
	
	if ([searchMo isValid]) {
		[searchDao save];
	    debug(@"    JSON to MO: %d JSON characters resulted in %d Mo objects", [jsonString length], [[searchMo jobs] count] );
	} else {
		searchMo = nil;
		warn(@"Resulting object is invalid and won't be saved. I'll return nil instead.");
	}
	
	return searchMo;
}

 
-(JobMo*) fillin:(JobMo*)jobMo with:(NSString*)jsonString {
    NSDictionary *dict = [JsonParser parseJson:jsonString];
	
	/* unused variables:
	 
	NSString *city = [dict objectForKey:@"city"];
	NSString *reference = [dict objectForKey:@"reference"];
	NSString *place = [dict objectForKey:@"place"];
	*/
	 
	NSString *description = [dict objectForKey:@"description"];
	NSString *other = [dict objectForKey:@"other"];
	NSString *category = [dict objectForKey:@"category"];
	NSString *experience = [dict objectForKey:@"experience"];
	NSString *requirements = [dict objectForKey:@"requirements"];
	
	jobMo.category = category;
	jobMo.content = description;
	jobMo.requirements = requirements;
	jobMo.experience = experience;
	jobMo.other = other;
	
	return jobMo;
}


@end
