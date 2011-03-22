
#import <GHUnitIOS/GHUnitIOS.h>
#import <UIKit/UIKit.h>
#import "Housekeeping.h"
#import "BundleFile.h"
#import "Geocoding.h"

@interface HousekeepingTest : GHTestCase {	
}
@end


@implementation HousekeepingTest

- (void) setUp {
	[super setUp];
}


/*
- (void) test1refreshCompanies {
	[CoreDataPersistentManager sharedInstance];	
	Housekeeping *hk = [[Housekeeping alloc]init];

	DiskFile *file = [[DiskFile alloc] initWithFilename:hk.filename andExtension:hk.extension];
	if ([file exists]) [file delete];

	[NSThread detachNewThreadSelector:@selector(refreshCompaniesDetached) toTarget:hk withObject:nil]; 
	
	GHAssertTrue(TRUE, nil);
}
*/

/*
// adds coords to a plist of cities
-(void) test2Shit {
	BundleFile *bundleFile = [[BundleFile alloc] initWithFilename:@"citiestownsvillages-ie" andExtension:@"plist"];
	NSDictionary *dic = [bundleFile dictionaryFromPlist];
	
	NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
	
	Geocoding *geocoding = [[Geocoding alloc] init];
	
	for (NSString*key in dic){
		[NSThread sleepForTimeInterval:1];
		CLLocation *location = [geocoding geocodeCity:[NSString stringWithFormat:@"%@",key]];
		if (location){
		    NSString *loc = [NSString stringWithFormat:@"%@,%@",
			                 [NSNumber numberWithDouble:location.coordinate.latitude],
			                 [NSNumber numberWithDouble:location.coordinate.longitude]];
			[results setObject:loc forKey:key];
		}
		debug(@"key: %@, object: %@", key, [results objectForKey:key]);
	}
	
	File *file = [[File alloc] initWithFilename:@"citiestownsvillages-ie" andExtension:@"plist"];
	debug(@"Saving as plist to %@", file.path);
	[file writeToPlist:results];
}
*/

@end
