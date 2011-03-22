
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "NSString+Extension.h"

@interface NSString_ExtensionTest : SenTestCase
@end


@implementation NSString_ExtensionTest


/** Test getting a UTF-8 string with the contents of a file. */
- (void) testOccurrencesOfString {
	NSString *string = @"for relaxing times, make it Suntory time";
	NSUInteger count = [string occurrencesOfString:@"time"];
	STAssertTrue(count==2, @"That should be a 2 you dummy, not a %d", count);
}


@end
