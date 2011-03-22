
#import "File.h"

@implementation File

@synthesize filename, extension, encoding, path;


- (id) initWithFilename:(NSString*)theFilename andExtension:(NSString*)theExtension {
    self = [super init];
    if (self != nil){
        self.filename = theFilename;
		self.extension = theExtension;
		self.encoding = NSUTF8StringEncoding;

		// The path will be: <application-document-directory>/filename.extension
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *nameWithExtension = [NSString stringWithFormat:@"%@.%@", self.filename, self.extension];
		self.path = [documentsDirectory stringByAppendingPathComponent:nameWithExtension];
		
    }
    return self;
}


-(NSDate*) modificationDate {
	if (![self exists]) {
		warn(@"The file doesn't exist: %@.%@", self.filename, self.extension);
		return nil;
	}
	NSError *error;
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.path error:&error];
	return [attributes fileModificationDate];
}


-(BOOL) exists {
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


/** 
 * Return the file as string. 
 * This uses the encoding set in <code>initWithFilename:andExtension:</code>.
 */
-(NSString *) string {
	NSError *error;
	NSString *string = [NSString stringWithContentsOfFile:self.path encoding:self.encoding error:&error];
	if (string==nil) {
		warn(@"error: %@", [error localizedDescription]);
	}
	return string;
}


/**
 * Return the file as data.
 * This uses the encoding set in <code>initWithFilename:andExtension:</code>.
 */
-(NSData *) data {
	NSData *data = [self.string dataUsingEncoding:self.encoding];
	if (data) { debug(@"Returning %d bytes from %@.%@", [data length], filename, extension); }
	return data;
}


-(NSString*) describe {
	return [NSString stringWithFormat:@"%@.%@", self.filename, self.extension];
}


-(void) writeToPlist:(NSDictionary*)dictionary {
	
	if (![self.extension isEqualToString:@"plist"]) {
		warn(@"Target file doesn't have a plist extension: %@.%@", self.filename, self.extension);
    }
	
	NSString *error;
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:dictionary
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&error];
	if (plistData) {
		[dictionary writeToFile:self.path atomically:YES];
	} else {
		warn(@"%@", error);
		[error release];
	}

}



@end
