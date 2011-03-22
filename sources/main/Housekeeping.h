
#import <Foundation/Foundation.h>
#import "DiskFile.h"
#import "HttpDownload.h"
#import "JsonMoBuilder.h"

@interface Housekeeping : NSObject {
	NSString *filename;
	NSString *extension;
}

@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *extension;


-(void) refreshCompanies;
-(void) initializeFromBundle;
-(void) refreshFromInternet;


@end
