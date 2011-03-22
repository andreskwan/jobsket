
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "File.h"
#import "HtmlToJson.h"
#import "NSString+Extension.h"
#import "SearchManager.h"


@interface SearchManagerTest : SenTestCase {
}
@end


@implementation SearchManagerTest

- (void) setUp {
	[super setUp];
}


-(void) test1RemoveInstances {
	SearchDao *dao = [SearchDao new];
	[dao removeAllByClassName:NSStringFromClass([SearchMo class])];
	
	int instances = [[dao objectsOfEntityName:NSStringFromClass([SearchMo class])] count];
	STAssertTrue(instances==0, @"There should be no JobMo instances.");
}


-(void) test2Download {
	
    NSString *url = @"http://www.google.com";
	NSString *content = [[HttpDownload new] pageAsStringFromUrl:url];
	STAssertTrue(content!=nil, @"Content is nil, guess download failed");
}


-(void) test3HtmltoJson {
	NSData *data = [[[File alloc] initWithFilename:@"search-java-1job-utf-8" andExtension:@"html"] data];
	
	HtmlToJson *htmlToJson = [HtmlToJson new];
	NSString *json = [htmlToJson jsonJobsFromData:data];
	
	NSRange range = [json rangeOfString:@"JobMo"];

	STAssertTrue(range.location!=NSNotFound, @"Didn't found any job, but there should be one.");
}


-(void) test4RunQuery {
	SearchDao *dao = [SearchDao new];
	[dao removeAllByClassName:NSStringFromClass([SearchMo class])];
	
    Query *query = [Query new];
	query.keywords = @"java";
	
	SearchManager *searchManager = [SearchManager new];
	SearchMo *mo = [searchManager runQuery:query];
 
	debug(@"Got this back: %@", [mo describe]);
	
	// if this fails, copy paste the json to the validator at http://www.jsonlint.com/
    STAssertTrue(mo!=nil, @"Got no Mo back. Who knows what happened.");
}



@end
