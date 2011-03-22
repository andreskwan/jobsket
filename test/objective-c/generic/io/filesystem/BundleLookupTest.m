
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "BundleLookup.h"


/** Test BundleLookup. */
@interface BundleLookupTest : SenTestCase
@end


@implementation BundleLookupTest


/** Test that we get a bundle for the current target. */
- (void) testGetBundle {
	NSBundle *bundle = [BundleLookup getBundle];
	debug(@"Did I find a bundle? %@", (bundle==nil) ? @"NO" : @"YES");
	STAssertTrue(bundle!=nil, @"Bundle was nil.");
}


@end
