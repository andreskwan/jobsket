
#import "SearchMo.h"


@implementation SearchMo 

@dynamic category;
@dynamic date;
//@dynamic lastUpdated;
@dynamic experience;
@dynamic favorite;
@dynamic jobs;
@dynamic keywords;
@dynamic location;
@dynamic maxSalary;
@dynamic minSalary;
@dynamic url;


-(NSString*) cellLabel {
	PickersData *data = [PickersData new];
	
	NSString *label=nil;
	if (self.keywords) {
		label = self.keywords;
	} else if ((self.minSalary && [self.minSalary length]>1) || (self.maxSalary && [self.maxSalary length]>1)) {
		
		if (self.minSalary && self.maxSalary && [self.minSalary length]>1 && [self.maxSalary length]>1){
		    label = [NSString stringWithFormat:@"%@€ to %@€", self.minSalary, self.maxSalary];
		} else if (self.minSalary && [self.minSalary length]>1){
			label = [NSString stringWithFormat:@"Min. salary: %@€", self.minSalary];
		} else if (self.maxSalary && [self.maxSalary length]>1){
			label = [NSString stringWithFormat:@"Max. salary: %@€", self.maxSalary];
		}
	} else if (self.experience) {
		label = self.experience;
        
	} else if (self.location) {
        for (id key in [data locationDictionary]){
            NSString *value = [[data locationDictionary] objectForKey:key];
            if ([self.location isEqualToString:value]){
                label = key;
                break;
            }
        }
        
	} else if (self.category) {
        for (id key in [data categoryDictionary]){
            NSString *value = [[data categoryDictionary] objectForKey:key];
            if ([self.category isEqualToString:value]){
                label = key;
                break;
            }
        }
        
	} else {
		label = localize(@"search.title.noparameters");
	}

    [data release];
	return label;
}


-(BOOL) isValid {
	BOOL valid = self.url && 1;
	for (JobMo *job in self.jobs) {
		valid = valid && [job isValid];
	}
	//debug(@"SearchMo.isValid=%@", valid ? @"Yes" : @"No");
	return valid;
}



-(NSArray*) keys {
	return [NSArray arrayWithObjects:@"url",@"category",@"date", @"experience",@"favorite",@"keywords",@"location",@"maxSalary",@"minSalary",@"jobs",nil];
}


-(NSString *) shortDescribe {
	return [NSString stringWithFormat: @"Search=[url:%@, favorite:%@, date:%@, keywords:%@]", self.url, self.favorite, self.date, self.keywords];
}


-(NSString *) describe {
	JsonEscape *je = [JsonEscape new];
	NSMutableString *json = [NSMutableString new];
	[json appendString:@"\n{"];
	[json appendString:@"\n\"SearchMo\": { "];
	NSMutableArray *array = [NSMutableArray new];
	if (self.category)   [array addObject:[NSString stringWithFormat:@"\n  \"category\" : \"%@\"", [je escape:self.category ]]];
	if (self.date)       [array addObject:[NSString stringWithFormat:@"\n      \"date\" : \"%@\"", self.date ]];
	if (self.experience) [array addObject:[NSString stringWithFormat:@"\n\"experience\" : \"%@\"", [je escape:self.experience ]]];
	if (self.favorite)   [array addObject:[NSString stringWithFormat:@"\n  \"favorite\" : \"%@\"", self.favorite ]];
	if (self.keywords)   [array addObject:[NSString stringWithFormat:@"\n  \"keywords\" : \"%@\"", [je escape:self.keywords ]]];
	if (self.location)   [array addObject:[NSString stringWithFormat:@"\n  \"location\" : \"%@\"", [je escape:self.location ]]];
	if (self.maxSalary)  [array addObject:[NSString stringWithFormat:@"\n \"maxSalary\" : \"%@\"", self.maxSalary ]];
	if (self.minSalary)  [array addObject:[NSString stringWithFormat:@"\n \"minSalary\" : \"%@\"", self.minSalary ]];
	if (self.url)        [array addObject:[NSString stringWithFormat:@"\n       \"url\" : \"%@\"", self.url ]];
	if (self.jobs) {
		NSMutableString *jobs = [NSMutableString new];
		[jobs appendString:@"\n      \"jobs\" : { "];
	    [jobs appendFormat:@"\n%@", [self describeJobs] ];
		[jobs appendString:@"\n}"];
		[array addObject:[NSString stringWithFormat:@"%@",jobs] ];
        [jobs release];
	}
	if ([array count]>0) [json appendFormat:@"%@", [array componentsJoinedByString:@","]];
	[json appendString:@"\n}} "];
	[je release];
    [array release];
    
	return [json autorelease];
}


-(NSString*) describeJobs {
	if ([self.jobs count]==0) return @"";
	JsonEscape *je = [JsonEscape new];
	int i=0;
	NSEnumerator *enumerator = [self.jobs objectEnumerator];
	JobMo *jobMo=nil;
	NSMutableArray *arrayJobs = [NSMutableArray new];
	while ((jobMo = [enumerator nextObject])) {
        NSMutableString *jsonJob = [NSMutableString new];
		[jsonJob appendFormat:@"\n\"JobMo%d\" :\n{",i++];
	    NSMutableArray *arrayFields = [NSMutableArray new];
		if (jobMo.region)   [arrayFields addObject:[NSString stringWithFormat:@"\n  \"region\" : \"%@\"", jobMo.region]];
		if (jobMo.city)     [arrayFields addObject:[NSString stringWithFormat:@"\n    \"city\" : \"%@\"", jobMo.city]];
	    if ([jobMo.company name]) [arrayFields addObject:[NSString stringWithFormat:@"\n \"company\" : \"%@\"", [jobMo.company name]]];
		if (jobMo.date)     [arrayFields addObject:[NSString stringWithFormat:@"\n    \"date\" : \"%@\"", jobMo.date]];
		if (jobMo.location) [arrayFields addObject:[NSString stringWithFormat:@"\n\"location\" : \"%@\"", [je escape:jobMo.location]]];
		if (jobMo.title)    [arrayFields addObject:[NSString stringWithFormat:@"\n    \"name\" : \"%@\"", [je escape:jobMo.title]]];
		if (jobMo.content)  [arrayFields addObject:[NSString stringWithFormat:@"\n \"content\" : \"%@\"", [je escape:jobMo.content]]];
		if (jobMo.url)      [arrayFields addObject:[NSString stringWithFormat:@"\n     \"url\" : \"%@\"", jobMo.url]];
		[jsonJob appendFormat:@"%@", [arrayFields componentsJoinedByString:@","]];
		[jsonJob appendString:@"\n}"];
		[arrayJobs addObject:jsonJob];
        [arrayFields autorelease];
        [jsonJob autorelease];
	}
    [je release];
    
    NSString *string = [arrayJobs componentsJoinedByString:@","];
    [arrayJobs release];
    
	return string;
}


@end


/*
 SEL selector = @selector(longDescribe);
 NSMutableString *string = [[NSMutableString alloc] initWithString:@"\n"];
 NSEnumerator *enumerator = [self.jobs objectEnumerator];
 while (NSObject *item = [enumerator nextObject]) {
 if ([item respondsToSelector:selector] == YES) {
 [string appendString:[item performSelector:selector]];
 } else {
 [string appendFormat:@"%@\n", item];
 }
 }
 */


/*
- (void)setKeywords:(NSString *)value {
    [self willChangeValueForKey:@"keywords"];
    [self setPrimitiveValue:value forKey:@"keywords"];
    [self didChangeValueForKey:@"keywords"];
	
	self.url = [NSString stringWithFormat:@"http://www.jobsket.es/search?keywords=%@", [self keywords]];
} */

