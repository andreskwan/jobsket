
#import <GHUnitIOS/GHUnitIOS.h>
#import <UIKit/UIKit.h>
#import "DiskFile.h"

@interface DiskFileTest : GHTestCase
@end


@implementation DiskFileTest


- (void) setUp {
	[super setUp];
}


- (void) test1 {
	
	// initialize
    DiskFile *diskFile = [[DiskFile alloc] initWithFilename:@"all-companies" andExtension:@"json"];
	debug(@"[diskFile path] = %@", [diskFile path]);
	
	// write a random string
	debug(@"writing.. ");
	NSString *stringOut = @"fuck";
	[diskFile writeAsString:stringOut];
	GHAssertTrue([diskFile exists], nil);
	
	// read and check we got back the string we wrote
	debug(@"reading.. ");
	NSString *stringIn = [diskFile string];
	GHAssertTrue( [stringOut isEqualToString:stringIn], nil);
	
	// print modification date
	debug(@"modification date = %@",[diskFile modificationDate]);
	[diskFile delete];
	[NSThread sleepForTimeInterval:1];
	[diskFile writeAsString:@"coksucker motherfucker"];
	stringIn = [diskFile string];
	debug(@"modification date = %@",[diskFile modificationDate]);
}



/*
- (void) test1 {

	debug(@"\n");
	debug(@"########################################");
	
	debug(@"TEST: file doesn't exist");
	// the file must be in the application's bundle resource
	BundleFile *file = [[BundleFile alloc] initWithFilename:@"filetest" andExtension:@"txt"];
	BOOL exists = [file exists];
	GHAssertFalse(exists, @"file shouldn't exists");
	
	debug(@"\n");
	debug(@"########################################");
	
	debug(@"TEST: write to file and check file exists");
	[file writeString:@"fuck"];	
	exists = [file exists];
	GHAssertTrue(exists, @"file should exist");
}
*/
 

@end
