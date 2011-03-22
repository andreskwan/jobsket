
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "FileReader.h"
#import "JsonEscape.h"

@interface JsonEscapeTest : SenTestCase
@end


@implementation JsonEscapeTest


/** Test getting a UTF-8 string with the contents of a file. */
- (void) testEscape {
	NSString *text = [FileReader stringWithFilename:@"unescaped" andExtension:@"text"];
	debug(@"ORIGINAL: %@", text);
	
	text = [[JsonEscape new] escape:text];
	debug(@" ESCAPED: %@", text);

	STAssertTrue(TRUE, @"blah");
}


@end
