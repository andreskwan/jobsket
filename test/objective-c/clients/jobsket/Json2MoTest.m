
//#import <SenTestingKit/SenTestingKit.h>
#import <GHUnitIOS/GHUnitIOS.h>
#import "JsonMoBuilder.h"
#import "BundleFile.h"
#import "Query.h"
#import "CompanyDao.h"
#import "JobDao.h"
#import "SearchDao.h"


//@interface Json2MoTest : SenTestCase {	
@interface Json2MoTest : GHTestCase {	
}
@end


@implementation Json2MoTest


- (void) setUp {
	[super setUp];
	debug(@"RUNNING SETUP");
	[[CompanyDao new] removeAllByClassName:NSStringFromClass([CompanyMo class])];
	[[JobDao new] removeAllByClassName:NSStringFromClass([JobMo class])];
	[[SearchDao new] removeAllByClassName:NSStringFromClass([SearchMo class])];
	debug(@"SETUP DONE \n\n");
}


-(void) testSearchRuby {
	JsonMoBuilder *json2Mo = [[JsonMoBuilder alloc] init];
	NSString *json = [[[BundleFile alloc] initWithFilename:@"search-ruby" andExtension:@"json"] string];
	
    Query *query = [Query new];
	query.keywords = @"ruby";
	
	SearchMo *searchMo = (SearchMo*)[json2Mo parseSearch:json fromQuery:query];
	debug(@"Resulting searchMo: %@", [searchMo describe]);
	
	//STAssertTrue(searchMo!=nil, @"Shouldn't be nil");
}

/*

-(void) testSearch {
	JsonMoBuilder *json2Mo = [[JsonMoBuilder alloc] init];
	NSString *json = [[[File alloc] initWithFilename:@"search-madrid" andExtension:@"json"] string];

	Query *query = [Query new];
	query.location = @"Madrid";

	SearchMo *searchMo = (SearchMo*)[json2Mo parse:json fromQuery:query];
	debug(@"Got this back searchMo: %@", [searchMo describe]);

	STAssertTrue(@""!=nil, @"Shouldn't be nil");
}
 

-(void) testCompanies {	
	NSString *json = [[[File alloc] initWithFilename:@"companies" andExtension:@"json"] string];
	JsonMoBuilder *jsonMoBuilder = [[JsonMoBuilder alloc] init];
	NSSet *set = (NSSet*)[jsonMoBuilder parseCompanies:json];
    debug(@"%d companies", [set count]);
}


-(void) testJobs {
	NSString *jobJson = [[[File alloc] initWithFilename:@"job310" andExtension:@"json"] string];
	JobMo *jobMo = (JobMo*)[json2Mo parse:jobJson];
	debug(@"JSON= %@", jobJson);	
	debug(@"resulting JobMo = %@", [jobMo describe]);
}
*/


@end
