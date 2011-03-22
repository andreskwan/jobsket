
#import "ASIHTTPRequest.h"
#import "Singleton.h"
#import <SenTestingKit/SenTestingKit.h>

/**
 * Test ASIHTTPRequest library.
 */
//@interface ASIHTTPRequestTest : GHTestCase {
@interface ASIHTTPRequestTest : SenTestCase {
}

/** Test synchronous connection */
- (void) testSyncConnection;

/** Test asynchronous connection */
- (void) testAsyncConnection;

@end


@implementation ASIHTTPRequestTest


- (void) testSyncConnection {
	NSURL *url = [NSURL URLWithString:@"http://www.jano.com.es"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request startSynchronous];
	NSError *error = [request error];
	if (!error) {
		//NSString *response = [request responseString];
		debug(@"Response: %@", [request responseString]);
	} else {
		STAssertTrue(FALSE, @"There was an error");
	}
}


- (void) testAsyncConnection {
	NSURL *url = [NSURL URLWithString:@"http://www.jano.com.es"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];
    STAssertTrue(TRUE, @"There was an error");	
}


#pragma mark -
#pragma mark ASIHTTPRequest delegate methods


- (void)requestFinished:(ASIHTTPRequest *)request {
	// fetch as string
	//NSString *responseString = [request responseString];
	debug(@"Response as NSString: %@",[request responseString]);
	
	// fetch as binary data
	//NSData *responseData = [request responseData];        
	debug(@"Response as NSData: %@",[request responseData]);
}


- (void)requestFailed:(ASIHTTPRequest *)request {
	//NSError *error = [request error];
	debug(@"%@",[request error]);
}


@end

 