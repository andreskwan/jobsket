
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "HttpDownload.h"

@interface HttpDownloadTest : SenTestCase
@end


@implementation HttpDownloadTest


/** Test getting a UTF-8 string with the contents of a file. */
- (void) testStringFromUrl {
	NSString *url = @"http://www.jobsket.es/search?keywords=php&minSalary=15000&maxSalary=21000&category=2&location=31";
	NSString *contents = [[HttpDownload new] pageAsStringFromUrl:url];
	debug(@"%@", contents);
	STAssertTrue(contents!=nil, @"File read shouldn't be nil.");
}


@end
