
#import <Foundation/Foundation.h>


@interface File : NSObject {
	NSString *filename;
	NSString *extension;
	NSString *path;
	NSStringEncoding encoding;
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *extension;
@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, retain) NSString *path;

-(NSString *) string;
-(NSData *) data;

-(BOOL) exists;
- (id) initWithFilename:(NSString*)theFilename andExtension:(NSString*)theExtension;

-(NSDate*) modificationDate;

-(NSString*) describe;

-(void) writeToPlist:(NSDictionary*)dictionary;

@end
