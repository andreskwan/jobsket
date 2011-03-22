
#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "Themes.h"
#import "DebugLog.h"
#import "File.h"

@interface ThemesTest : SenTestCase {
}
@end

@implementation ThemesTest


- (void) testConstant {
	
	//Themes *themes = [[Themes alloc] init];
	
	//debug(@"fuck = %@", [Themes fuck]);
	
	/*
	NSString *path = [themes.images objectForImages:TOP_BAR_BG];
	debug(@"path = %@",path);
	UIImage *image = [themes getCachedImage:path];
	debug(@"image = %@",image);
	
	File *file = [[File alloc] initWithFilename:path andExtension:@"png"];
	debug(@"File exist = %@", [file readingFileExists] ? @"TRUE" : @"FALSE");
	
	// STAssertTrue(dict==nil, @"Wot? Parser should return nil because there are chars less than 0x020");
	*/
}


@end
