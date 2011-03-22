
#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "PickersData.h"

@interface PickersDataTest : SenTestCase
@end


@implementation PickersDataTest


- (void) testInit {
	PickersData *pd = [PickersData new];
	STAssertTrue([pd placeDictionary]!=nil, @"placeDictionary still nil");
	STAssertTrue([pd categoryDictionary]!=nil, @"categoryDictionary still nil");
	STAssertTrue([pd experienceDictionary]!=nil, @"experienceDictionary still nil");
}


-(void) testCheatedSort {
    NSArray *unsortedKeys = [NSArray arrayWithObjects: @"aaa", @"BBB", @"ccc", nil];
	NSArray *sortedKeys = [[PickersData new] cheatedSort:unsortedKeys keyOnTop:@"BBB"];
	STAssertTrue( [[sortedKeys objectAtIndex:0] isEqualToString:@"BBB"], 
				  @"there should be a 'NOVALUE' key on top");
}



@end
