
#import "BundleFile.h"

@implementation BundleFile


- (id) initWithFilename:(NSString*)theFilename andExtension:(NSString*)theExtension {
    self = [super init];
    if (self != nil){
        self.filename = theFilename;
		self.extension = theExtension;
		self.encoding = NSUTF8StringEncoding;
        self.path = [[BundleLookup getBundle] pathForResource:self.filename ofType:self.extension];
    }
    return self;
}


-(NSString *) string {
	if ([self exists]) {
		return [super string];
	} else {
		warn(@"Returning nil because the file is not in the bundle.");
		return nil;
	}
}


-(NSData *) data {
	if ([self exists]) {
		return [super data];
	} else {
		warn(@"Returning nil because the file is not in the bundle.");
		return nil;
	}
}


-(BOOL) exists {
	return self.path!=nil;
}


-(NSDictionary*) dictionaryFromPlist {
	
	if (![self.extension isEqualToString:@"plist"]) { warn(@"uh, I hope this is a plist"); }
	
	NSError *errorDesc = nil;
	NSPropertyListFormat format;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:self.path];
	NSDictionary *dict = (NSDictionary *)[NSPropertyListSerialization 
										  propertyListWithData:plistXML
										  options:0
										  format:&format
										  error:&errorDesc];
	if (!dict) { warn(@"Error reading plist: %@, format: %d", errorDesc, format); }
	
	return dict;
}


@end

