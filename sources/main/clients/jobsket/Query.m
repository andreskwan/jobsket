
#import "Query.h"


@implementation Query

@synthesize keywords, minSalary, maxSalary, category, location, experience;


- (id) init {
    self = [super init];
    if (self != nil){
        keywords=nil;
		minSalary=nil;
		maxSalary=nil;
		category=nil;
		location=nil;
		experience=nil;
    }
    return self;
}


-(NSString *) urlForHtmlSearch {
	NSString *url = [NSString stringWithFormat:@"http://ats.jobsket.com/api/search/jobs?%@", [self htmlParameters]];
	//debug(@"url for HTML query is %@", url);
	return url;
}


-(NSString *) urlForJsonSearch {
	NSString *url = [NSString stringWithFormat:@"http://ats.jobsket.com/api/search/jobs%@", [self jsonParameters]];
	//debug(@"url for JSON query is %@", url);
	return url;
}


-(NSString *) jsonParameters {
	
	NSMutableArray *array = [NSMutableArray new];
	if (minSalary)  [array addObject:[NSString stringWithFormat:@"minSalary=%@",minSalary]];
	if (maxSalary)  [array addObject:[NSString stringWithFormat:@"maxSalary=%@",maxSalary]];
	if (category)   [array addObject:[NSString stringWithFormat:@"category=%@",category]];
	if (location)   [array addObject:[NSString stringWithFormat:@"location=%@",location]];
	if (experience) [array addObject:[NSString stringWithFormat:@"experience=%@",experience]];
	
	NSString *parameters = [array count]==0 ? @"" : [NSString stringWithFormat:@"%@", [array componentsJoinedByString:@"&"]];
	[array release];
    
	NSMutableString *mstring = [NSMutableString stringWithString:parameters];
	NSRange wholeString = NSMakeRange(0, [mstring length]);
	[mstring replaceOccurrencesOfString:@" "
							 withString:@"+"
								options:0
								  range:wholeString];
	parameters = [NSString stringWithString: mstring];
	
	NSMutableString *sUrl = [[NSMutableString alloc] init];
	if (keywords) {
		[sUrl appendFormat:@"/%@?%@",keywords,parameters];
	} else {
		[sUrl appendFormat:@"?%@",parameters];
	}
	
	return [sUrl autorelease];
}



-(NSString *) htmlParameters {

	NSMutableArray *array = [NSMutableArray new];
	if (keywords)   [array addObject:[NSString stringWithFormat:@"keywords=%@",keywords]];
	if (minSalary)  [array addObject:[NSString stringWithFormat:@"minSalary=%@",minSalary]];
	if (maxSalary)  [array addObject:[NSString stringWithFormat:@"maxSalary=%@",maxSalary]];
	if (category)   [array addObject:[NSString stringWithFormat:@"category=%@",category]];
	if (location)   [array addObject:[NSString stringWithFormat:@"location=%@",location]];
	if (experience) [array addObject:[NSString stringWithFormat:@"experience=%@",experience]];
	
	NSString *sUrl = [NSString stringWithFormat:@"%@",
                      [array componentsJoinedByString:@"&"]];
	[array release];
    
	NSMutableString *mstring = [NSMutableString stringWithString:sUrl];
	NSRange wholeString = NSMakeRange(0, [mstring length]);
	[mstring replaceOccurrencesOfString:@" "
							 withString:@"+"
								options:0
								  range:wholeString];
	sUrl = [NSString stringWithString: mstring];
	
	return sUrl;
}


-(BOOL) isValid {
	BOOL valid = TRUE;
	
	if (experience) {
	    NSSet *set = [NSSet setWithObjects: @"Without experience", @"1 or less years in experience", 
	    			  @"1-2 years in experience", @"2-3 years in experience", @"3-5 years in experience", 
		    		  @"5-10 years in experience", @"More than 10 years in experience", nil];
		if (![set containsObject:experience]) valid = FALSE;
	}
	
	if (location) {
		int n = [location intValue];
		if (n>53 || n<0) valid = FALSE; // 0-53
	}
	
	if (category) {
		int n = [category intValue];
		if (n>18 || n<0 || n==1 || n==2) valid = FALSE; // 0, 3-18
	}	
	
	return valid;
}


-(NSString*) json {
	NSMutableArray *array = [NSMutableArray new];
	if (keywords)   [array addObject:[NSString stringWithFormat:@"\n\"keywords\":\"%@\"",keywords]];
	if (minSalary)  [array addObject:[NSString stringWithFormat:@"\n\"minSalary\":\"%@\"",minSalary]];
	if (maxSalary)  [array addObject:[NSString stringWithFormat:@"\n\"maxSalary\":\"%@\"",maxSalary]];
	if (category)   [array addObject:[NSString stringWithFormat:@"\n\"category\":\"%@\"",category]];
	if (location)   [array addObject:[NSString stringWithFormat:@"\n\"location\":\"%@\"",location]];
	if (experience) [array addObject:[NSString stringWithFormat:@"\n\"experience\":\"%@\"",experience]];
	NSString *result = [NSString stringWithFormat:@"%@",[array componentsJoinedByString:@", "]];
    [array release];
    return result;
}
				


@end
