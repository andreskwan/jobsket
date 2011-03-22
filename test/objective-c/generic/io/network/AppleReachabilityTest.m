
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "AppleReachability.h"

@interface AppleReachabilityTest : SenTestCase
@end

@implementation AppleReachabilityTest


/** Test that a specific host is reachable. */
- (void) testSyncHostReachability {
	AppleReachability *reach = [[AppleReachability reachabilityWithHostName: @"www.apple.com"] retain];
	NetworkStatus status = [reach currentReachabilityStatus];
	
	// status is one of NotReachable, ReachableViaWiFi, or ReachableViaWWAN
	BOOL isReachable = status!=NotReachable;
	STAssertTrue(isReachable, @"There is no access to the host www.apple.com");
}


/** Test that Internet is reachable. */
- (void) testSyncNetReachability {	
	AppleReachability *reach = [[AppleReachability reachabilityForInternetConnection] retain]; 
	NetworkStatus status = [reach currentReachabilityStatus];
	
	// status is one of NotReachable, ReachableViaWiFi, or ReachableViaWWAN
	BOOL isReachable = status!=NotReachable;
	STAssertTrue(isReachable, @"There is no Internet access.");
}


/** 
 * Test that local wifi is available. 
 * Disabled in case we are running on ethernet while we run the tests.
 */
- (void) testSyncWifiReachability {
	AppleReachability *reach = [[AppleReachability reachabilityForLocalWiFi] retain]; 
	NetworkStatus status = [reach currentReachabilityStatus];
	
	// status is one of NotReachable, ReachableViaWiFi, or ReachableViaWWAN
	BOOL isReachable = status!=NotReachable;
	STAssertTrue(isReachable, @"There is no WiFi access.");
}


// async testing //////////////////////////////////////////////////////////////////////////////////////

// I AM A SAD PANDA BECAUSE THIS PART SHOULD WORK BUT DOESN'T

/*
 
BOOL reachable = FALSE;


// Test asynchronous reachability.
- (void) testAsyncReachability {
	AppleReachability *reach = [[AppleReachability reachabilityWithHostName: @"www.apple.com"] retain];
	
	// register self as an observer for the kReachabilityChangedNotification event
	[ [NSNotificationCenter defaultCenter] addObserver: self
                                              selector: @selector(reachabilityChanged:)
                                                  name: kReachabilityChangedNotification
                                                object: nil];
	[reach startNotifier];
	NSTimeInterval fiveSecondsLater = [[NSDate date] timeIntervalSinceReferenceDate] + 10;	
	while(([[NSDate date] timeIntervalSinceReferenceDate] < fiveSecondsLater ) || reachable){
	}
	[reach stopNotifier];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
 
	STAssertTrue(reachable, @"didn't get any event");
}


- (void) reachabilityChanged: (NSNotification *)notification {
	debug(@"######## GOT EVENT %@", [notification class]);
    AppleReachability *reach = [notification object];
	if( [reach isKindOfClass: [AppleReachability class]]) {
    }
    NetworkStatus status = [reach currentReachabilityStatus];
	// save to global variable
	reachable = status!=NotReachable;
}

*/

@end
