
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "File.h"
#import "HtmlToJson.h"
#import "JsonParser.h"

@interface JsonParserTest : SenTestCase
@end


@implementation JsonParserTest


- (void) testParseJson {
	
	File *file = [[File alloc] initWithFilename:@"json1-utf8-invalidchars" andExtension:@"json"];	
	STAssertTrue([file readingFileExists], @"File doesn't exist: %@.%@", [file name], [file extension]);
	
	NSString *json = [file string];
	
	debug(@"json: %@", json);
	NSDictionary *dict = [JsonParser parseJson:json];
	
	STAssertTrue(dict==nil, @"Wot? Parser should return nil because there are chars less than 0x020");
}


@end
