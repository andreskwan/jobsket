
#import "DiskFile.h"

@implementation DiskFile


- (id) initWithFilename:(NSString*)theFilename andExtension:(NSString*)theExtension {
    self = [super initWithFilename:theFilename andExtension:theExtension];
	if (self != nil){
	}
	return self;
}
		

/**
 * Write the file represented by this object.
 * This uses the encoding set in <code>initWithFilename:andExtension:</code>.
 */
-(BOOL) writeAsString:(NSString*)string {
	NSError *error = nil;
	BOOL success = [string writeToFile:self.path atomically:YES encoding:self.encoding error:&error];
	if (!success){ warn(@"error: %@", [error localizedDescription]); }
	debug(@"%d bytes written to disk", [string length]);
	return success;
}


/**
 * Write the given data to the file represented by this object.
 * Writing on a file replaces its contents.
 */
-(BOOL) writeAsData:(NSData*)data {
	NSError *error = nil;
	[data writeToFile:self.path options:NSDataWritingAtomic error:&error];
	if (error) { warn(@"error: %@", [error localizedDescription]); }
	return error==nil;
}


-(BOOL) delete {
	NSError *error = nil;
	BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
	if (error) {
		warn(@"error: %@", [error localizedDescription]);
	} else {
		debug(@"deleting %@", [self describe]);
	}
	return success;
}


@end
