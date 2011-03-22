
#import <SenTestingKit/SenTestingKit.h>
#import "HttpDownload.h"
#import "Query.h"


@interface QueryTest : SenTestCase {
}
@end


@implementation QueryTest

- (void) setUp {
	[super setUp];
}


-(void) testUrl {
	Query *query = [Query new];
	query.experience = @"1-2 years in experience";
	NSString *url = [query url];
	
	debug(@"url = %@", url);
	
	HttpDownload *download = [HttpDownload new];
	NSString *contents = [download pageAsStringFromUrl:url];
	debug(@"Got %d characters", [contents length]);
	
	STAssertTrue(contents!=nil, @"Shouldn't be nil");
}


@end



