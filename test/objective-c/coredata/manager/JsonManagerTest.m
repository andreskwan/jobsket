
#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "JSONKit.h"
#import "FileReader.h"
#import "JsonManager.h"
#import "GenericDaoTest.h"

@interface JsonManagerTest : GenericDaoTest {	
}

@end


@implementation JsonManagerTest


- (void) setUp {
	if (!dao){ 
		[self setUpWithDao:[SearchDao class] andMo:[SearchMo class]];
		[self setBlock:^(void){
			return [dao performSelector:@selector(search)];
		}];
	}
	[self removeAll];
}


-(void) testSearchFromJson {

	NSData *data;
	SearchMo *searchMo;
    JsonManager *jsonManager = [JsonManager new];
	
	data = [FileReader dataWithFilename:@"search-3jobs" andExtension:@"json"];
	searchMo = [jsonManager searchFromJson:data];
	STAssertTrue(searchMo!=nil, @"resulting object is nil");
	
	data = [FileReader dataWithFilename:@"search-emptyfile" andExtension:@"json"];
	searchMo = [jsonManager searchFromJson:data];
	STAssertTrue(searchMo==nil, @"resulting object is nil");
	
	data = [FileReader dataWithFilename:@"search-emptyjson" andExtension:@"json"];
	searchMo = [jsonManager searchFromJson:data];
	STAssertTrue(searchMo==nil, @"resulting object is nil");

	data = [FileReader dataWithFilename:@"search-invalid-SearchMo" andExtension:@"json"];
	searchMo = [jsonManager searchFromJson:data];
	STAssertTrue(searchMo==nil, @"resulting object is nil");
	
}


@end
