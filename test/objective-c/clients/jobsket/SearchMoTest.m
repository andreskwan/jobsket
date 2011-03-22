
#import <SenTestingKit/SenTestingKit.h>


@interface SearchMoTest : SenTestCase {
}
-(NSString *) describe;
@end


@implementation SearchMoTest

- (void) setUp {
	[super setUp];
}


-(void) testDescribe {
    debug(@"%@", [self describe]);
	
	STAssertTrue(TRUE, @"Shouldn't be nil");
}


-(NSString *) describe {
	NSMutableString *json = [NSMutableString new];
	[json appendString:@"\n{"];
	[json appendString:@"\n\"SearchMo\": { "];
	NSMutableArray *array = [NSMutableArray new];
	[array addObject:[NSString stringWithFormat:@"\n      \"date\" : \"%@\"", [NSDate new] ]];
	[array addObject:[NSString stringWithFormat:@"\n  \"favorite\" : \"%@\"", @"0" ]];
	[array addObject:[NSString stringWithFormat:@"\n       \"url\" : \"%@\"", @"http://www.jobsket.es/search?" ]];
	if (TRUE) {
		NSMutableString *jobs = [NSMutableString new];
		[jobs appendString:@"\n      \"jobs\" : { "];
	    [jobs appendFormat:@"\n%@", @"" ];
		[jobs appendString:@"\n}"];
		[array addObject:jobs];
	}
	if ([array count]>0) [json appendFormat:@"%@", [array componentsJoinedByString:@","]];
	[json appendString:@"\n}} "];
	
	return json;
}



@end
