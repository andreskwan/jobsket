
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CompanyLookup.h"


@interface ComLocLookupTest : SenTestCase

@end


@implementation ComLocLookupTest

- (void) setUp {
	[super setUp];
}

-(void) testLocationByName {
	
	CompanyLookup *lookup = [CompanyLookup new];
	
    for (int i = 0; i < 100; i++) {
		CLLocation *location = [lookup locationByName:@"x"];
		debug(@"shit = %@", location);
    }
	
	STAssertTrue( TRUE, @"lalala");
}


@end
