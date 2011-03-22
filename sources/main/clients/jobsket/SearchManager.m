
#import "SearchManager.h"


@implementation SearchManager

@synthesize searchDao, manager, jsonMoBuilder;


- (id) init {
    self = [super init];
    if (self != nil){
		self.manager = [CoreDataPersistentManager sharedInstance];
		self.searchDao = [[SearchDao alloc] initWithManager:manager];
		self.jsonMoBuilder = [[JsonMoBuilder alloc] init];
	}
	return self;
}


-(SearchMo*) runJsonQuery:(Query*)query {
	NSString *url = [query urlForJsonSearch];

	SearchMo *searchMo = [searchDao findByUrl:url];
	
	BOOL found = searchMo!=nil;
	if (found){
		// todo: update if we need it
		debug(@"found. TODO: update if needed.");
	} else {
		debug(@"Querying Jobsket with url %@", url);
        HttpDownload *download = [HttpDownload new];
		NSString *json = [download pageAsStringFromUrl:url];
        [download release];
        if (json==nil) {
            warn(@"download failed, JSON is nil for url %@", url);
            return nil; // BALKING OUT
        } else {
            searchMo = (SearchMo*)[jsonMoBuilder parseSearch:json fromQuery:query];
        }
	}
	
	return searchMo;
}


-(SearchMo*) runQuery:(Query*)query {
	NSString *url = [query urlForHtmlSearch];
	
	// is it cached?
	SearchMo *searchMo = [searchDao findByUrl:url];
	if (searchMo==nil){
		// download page
        HttpDownload *download = [HttpDownload new];
		NSData *htmlData = [download cleanPageAsDataFromUrl:url];
		[download release];
        
		// transform to JSON
		NSMutableString *json = [NSMutableString new];
		{
			[json appendString:@"\n{"];
			[json appendString:@"\n\"SearchMo\": { "];
			NSMutableArray *array = [NSMutableArray new];
			[array addObject:[NSString stringWithFormat:@"\n      \"date\" : \"%@\"", [NSDate date] ]];
			[array addObject:[NSString stringWithString:@"\n  \"favorite\" : 0"]];
			
			NSString *queryJson = [query json];
			if (queryJson!=nil && [queryJson length]>0) [array addObject:[NSString stringWithFormat:@"\n  %@", queryJson]];
			
			NSString *queryUrl = [query urlForHtmlSearch];
			if (queryUrl) [array addObject:[NSString stringWithFormat:@"\n       \"url\" : \"%@\"", queryUrl ]];
			
            HtmlToJson *htmlToJson = [HtmlToJson new];
			NSString *jsonJobs = [htmlToJson jsonJobsFromData:htmlData];
            [htmlToJson release];
			if (jsonJobs) {
				NSMutableString *jobs = [[NSMutableString new] autorelease];
				[jobs appendString:@"\n      \"jobs\" : "];
				[jobs appendFormat:@"\n%@", jsonJobs ]; // [query json]
				[array addObject:jobs];
			}
			
			if ([array count]>0) [json appendFormat:@"%@", [array componentsJoinedByString:@","]];
            [array release];
			[json appendString:@"\n}} "];
        }
		
		debug(@"%@", json);
		
		// JSON to Mo
        JsonToMo *jsonToMo = [JsonToMo new];
		searchMo = [jsonToMo searchFromJson:json];
        [jsonToMo release];
        [json release];
	}
	return searchMo;
}


@end
