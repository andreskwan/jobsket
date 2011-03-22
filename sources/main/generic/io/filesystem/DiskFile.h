
#import <Foundation/Foundation.h>
#import "File.h"

@interface DiskFile : File {

}

-(BOOL) writeAsString:(NSString*)string;
-(BOOL) writeAsData:(NSData*)data;
-(BOOL) delete; 

@end
