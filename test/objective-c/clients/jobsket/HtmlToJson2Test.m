
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "File.h"
#import "HtmlToJson.h"
#import "NSString+Extension.h"
#import "JobMo.h"
#import "JobDao.h"
#import "CoreDataPersistentManager.h"
#import "JsonToMo.h"


/**
 * Test the HtmlParser.
 * 
 * HtmlParser parses the HTML job search results from Jobsket, 
 * and returns the jobs as JSON.
 */
@interface HtmlToJsonTest : SenTestCase {
}
@end


@implementation HtmlToJsonTest

- (void) setUp {
	[super setUp];
}


-(void) test41JsonJobsFromData {
	
	// we use a static file instead parsing
	NSData *data = [[[File alloc] initWithFilename:@"job-detail" andExtension:@"html"] data];
	
	// get the jobs as JSON
	NSString *json = [[HtmlToJson new] jsonJobDetailFromData:data];
	
	debug(@"json is %@", json);
	
	JobDao *jobDao = [[JobDao alloc] initWithManager:[CoreDataPersistentManager sharedInstance]];
	JobMo *job = [jobDao jobWithName:@"Java developer" andUrl:@"http://www.google.com"];
	debug(@"job created: %@", [job describe]);
	
	job = [[JsonToMo new] fillin:job with:json];
	
	debug(@"job filled: %@", [job describe]);

	STAssertTrue(job.desc!=nil, @"Description shouldn't be nil");

}


@end



