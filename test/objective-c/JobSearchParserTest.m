
#import "JobSearchParser.h"
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>


@interface JobSearchParserTest : SenTestCase {
}

-(void) testStuff;
-(NSData *) readFileWithName:(NSString*)name andExtension:(NSString*)type;

@end



@implementation JobSearchParserTest


- (void) testStuff {
	NSData *data = [self readFileWithName:@"3job-htmlstrict-search" andExtension:@"html"];
	[[JobSearchParser new] parseJobs:data];
}


/**
 * Read file name from the main bundle.
 */
-(NSData *) readFileWithName:(NSString*)name andExtension:(NSString*)type {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:type];
	NSData *data = [NSData dataWithContentsOfFile:filePath];  
	if (data) {  
		debug(@"Got %d bytes from %@.%@ in the main bundle",[data length],name,type);
	}
	return data;
}


@end
