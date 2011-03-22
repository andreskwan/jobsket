
#import "PickersData.h"

@implementation PickersData

static NSDictionary *locationDict = nil;
static NSDictionary *categoryDict = nil;
static NSDictionary *experienceDict = nil;
static NSDictionary *salaryDict = nil;


- (id) init {
	self = [super init];
	if ((self != nil) && (!locationDict)) {
		debug(@"Reading Pickers Data");
		[self initDictionaries];
	}
    return self;
}


-(void) initDictionaries {
	if (locationDict && categoryDict && experienceDict && salaryDict){
		debug(@"already initialized");
		return;
	}

	NSString *plistPath = [[BundleLookup getBundle] 
                           pathForResource:[NSString stringWithFormat:@"JobsketSearchParameters_%@",[Themes preferredLanguage]]
                           ofType:@"plist"];
    debug(@"    Path for JobsketSearchParameters_%@... %@", [Themes preferredLanguage], plistPath==nil ? @"NOT FOUND" : @"FOUND");
    
    if (plistPath==nil){
        plistPath = [[BundleLookup getBundle] pathForResource:@"JobsketSearchParameters_en" ofType:@"plist"];
        debug(@"    Path for JobsketSearchParameters_en... %@", plistPath==nil ? @"NOT FOUND" : @"FOUND");
    } 

	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
		warn(@"    Can't find file at path %@",plistPath);
	}
	
	// get dictionary from bundle plist
	NSError *errorDesc = nil;
	NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization 
										  propertyListWithData:plistXML
										  options:0
										  format:&format
										  error:&errorDesc];
	if (!dict) {
		warn(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	
	locationDict = [[dict objectForKey:@"place"] retain]; 
	categoryDict = [[dict objectForKey:@"category"] retain];
	experienceDict = [[dict objectForKey:@"experience"] retain];
	salaryDict = [[dict objectForKey:@"salary"] retain];
}


-(NSDictionary*) salaryDictionary {
	return salaryDict;
}


-(NSDictionary*) locationDictionary {
	return locationDict;
}


-(NSDictionary*) categoryDictionary {
	return categoryDict;
}


-(NSDictionary*) experienceDictionary {
	return experienceDict;
}


@end
