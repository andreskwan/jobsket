
#import <SenTestingKit/SenTestingKit.h>
#import "ASIHTTPRequest.h"
#import "JobSearchParser.h"
#import "CoreDataMemoryManager.h"
#import "CoreDataPersistentManager.h"
#import "SearchDao.h"
#import "SearchMo.h"


/** 
 * ASIHTTPRequest example code: http://allseeing-i.com/ASIHTTPRequest/How-to-use 
 */
@interface JobsketSearchTest : SenTestCase {
}
- (void) test1download;
- (void) test2parse;
- (NSData *) readFileWithName:(NSString*)name andExtension:(NSString*)type;

@end


@implementation JobsketSearchTest

NSString *searchUrl = @"http://www.jobsket.es/search?keywords=java";


#pragma mark download

NSData *pageData;
BOOL isError = false;
BOOL isFinished = false;


/**
 * Check that we can do an async download of a search page.
 */ 
- (void) test1download {
	NSURL *url = [NSURL URLWithString:searchUrl];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
	
	// hoping to be done in 2 seconds, otherwise the test fails
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
	
    STAssertTrue((isFinished && !isError), @"There was an error");	
}

- (void)requestFinished:(ASIHTTPRequest *)request {
	pageData = [request responseData];
	debug(@"responseString: %d bytes",[pageData length]);
	isFinished = TRUE;
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	debug(@"%@:%s Error saving context: %@", [self class], _cmd, [error localizedDescription]);
	isError = TRUE;
}


#pragma mark parse



/**
 * Check that we can parse a downloaded search page.
 */
- (void) test2parse {

	// look for existing SearchMo with that url
	CoreDataAbstractManager *manager = [CoreDataPersistentManager sharedInstance];
    SearchDao *searchDao = [[SearchDao alloc] initWithManager:manager];
    SearchMo *searchMo = [searchDao findByUrl:searchUrl];

    if (searchMo != nil) {
		// read from cache
        debug(@"Hooray! search already present: %@", [searchMo describe]);
        return;
    } else {
		// download fresh data
		debug(@"Getting fresh data...");
        NSData *data = [self readFileWithName:@"jobsket-search" andExtension:@"html"];

        // parse
        NSMutableSet *jobs = [[JobSearchParser new] parseJobs:data];
        debug(@"Got %d jobs back", [jobs count]);
        STAssertTrue([jobs count] > 0, @"No jobs returned.");

        // build the search object
        SearchMo *search = [searchDao createWithKeywords:@"java" 
													date:[NSDate date] 
												favorite:[NSNumber numberWithBool:NO] 
												 andJobs:jobs];
		search.url = searchUrl;
		
        debug(@"I just built searchMo: %@", search);
    }
}



/**
 * Read file name from the main bundle.
 */
-(NSData *) readFileWithName:(NSString*)name andExtension:(NSString*)type {
	
	NSBundle *bundle;
	NSArray *identifiers = [NSArray arrayWithObjects: @"es.com.jano.JobsketTest2", nil];
	for(NSString *bundleId in identifiers) {
		bundle = [NSBundle bundleWithIdentifier:bundleId];
		if (bundle!=nil) break;
	}
	NSString *filePath = [bundle pathForResource:name ofType:type];
	debug(@"Filepath %@", filePath);
	
	NSData *data = [NSData dataWithContentsOfFile:filePath];  
	if (data) {  
		debug(@"Got %d bytes from %@.%@ in the main bundle",[data length],name,type);
	}
	return data;
}


@end
