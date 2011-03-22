
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "File.h"
#import "HtmlToJson.h"
#import "NSString+Extension.h"


/**
 * Test the HtmlParser.
 * 
 * HtmlParser parses the HTML job search results from Jobsket, 
 * and returns the jobs as JSON.
 */
@interface HtmlToJsonTest : SenTestCase {
}
@end


@implementation HtmlToJsonTest

- (void) setUp {
	[super setUp];
}


-(void) test11ReplaceEntities {
	NSString *unsafe  = @"&Aacute; 12345 &aacute; 67890 &reg;";
	NSString *safe    = @"Á 12345 á 67890 ®";
	NSString *escaped = [[JsonEscape new] replaceEntities:unsafe];
	debug(@"unescaped: %@", unsafe);
	debug(@"  escaped: %@", escaped);
	STAssertTrue([safe isEqualToString:escaped], @"Got %@ but should be %@", escaped, safe);
}


// Check HTML entitites.
-(void) test12ReplaceEntities {
	NSString *unsafe = @"&#193;abc&#243;.";
	NSString *safe = @"Áabcó.";
	NSString *escaped = [[JsonEscape new] replaceEntities:unsafe];
	debug(@"unescaped: %@", unsafe);
	debug(@"  escaped: %@", escaped);
	STAssertTrue([safe isEqualToString:escaped], @"Got %@ but should be %@", escaped, safe);
}


// Escape newline.
-(void) test21Escape {
	NSString *unsafe = @"Twinkle,\n twinkle,\n little star";
	NSString *safe = @"Twinkle, twinkle, little star";
	NSString *escaped = [[JsonEscape new] escape:unsafe];
	debug(@"unescaped: %@", unsafe);
	debug(@"  escaped: %@", escaped);
	STAssertTrue([safe isEqualToString:escaped], @"Got %@ but should be %@", escaped, safe);
}


// Check that double quotes are not dropped.
-(void) test22Escape {
	NSString *unsafe = @"Mod parent \"OldManOnPorchWithShotgun\".";
	NSString *safe   = @"Mod parent \\\"OldManOnPorchWithShotgun\\\".";
	NSString *escaped = [[JsonEscape new] escape:unsafe];
	debug(@"unescaped: %@", unsafe);
	debug(@"  escaped: %@", escaped);
	STAssertTrue([safe isEqualToString:escaped], @"Got %@ but should be %@", escaped, safe);
}


// Check that accented vowels are not dropped.
-(void) test23Escape {
	NSString *unsafe = @"á é í ó ú ü";
	NSString *safe = @"á é í ó ú ü";
	NSString *escaped = [[JsonEscape new] escape:unsafe];
	debug(@"unescaped: %@", unsafe);
	debug(@"  escaped: %@", escaped);
	STAssertTrue([safe isEqualToString:escaped], @"Got %@ but should be %@", escaped, safe);
}


-(void) test31JsonJobsFromData {
	
	// we use a static file instead parsing
	NSData *data = [[[File alloc] initWithFilename:@"search-java2" andExtension:@"html"] data];
	
	// get the jobs as JSON
	NSString *jobsJsonDict = [[HtmlToJson new] jsonJobsFromData:data];
	
	debug(@"Got this back: %@", jobsJsonDict);
	
	// there should be 1
	int i = [jobsJsonDict occurrencesOfString:@"JobMo"];
	STAssertTrue(i==1, @"Should return 1 but was %d", i);
}


-(void) test32JsonJobsFromData {
	
	// we use a static file instead parsing
	NSData *data = [[[File alloc] initWithFilename:@"search-java" andExtension:@"html"] data];
	
	// get the jobs as JSON
	NSString *jobsJsonDict = [[HtmlToJson new] jsonJobsFromData:data];
	
	debug(@"Got this back: %@", jobsJsonDict);
	
	// there should be 1
	int i = [jobsJsonDict occurrencesOfString:@"JobMo"];
	STAssertTrue(i==26, @"Should return 26 but was %d", i);
}


-(void) test33JsonJobsFromData {
	
	// we use a static file instead parsing
	File *file = [[File alloc] initWithFilename:@"search-iphone-6jobs" andExtension:@"html"];
	NSString *string = [file string];
	string = [string stringByReplacingOccurrencesOfString:@"<!--[if gte mso 9]>" withString:@""];
	
	debug(@"string: %@", string);
	
	NSData *data = [string dataUsingEncoding:file.encoding];
	
	// get the jobs as JSON
	NSString *jobsJsonDict = [[HtmlToJson new] jsonJobsFromData:data];
	
	debug(@"Got this back: %@", jobsJsonDict);
	
	// there should be 1
	int i = [jobsJsonDict occurrencesOfString:@"JobMo"];
	STAssertTrue(i==6, @"Should return 6 but was %d", i);
}


@end



